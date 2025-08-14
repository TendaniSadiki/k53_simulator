import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ErrorService {
  static String getAuthErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return 'Please enter a valid email address';
      case 'user-disabled':
        return 'This account has been disabled';
      case 'user-not-found':
        return 'No account found for this email';
      case 'wrong-password':
        return 'Incorrect password';
      case 'email-already-in-use':
        return 'This email is already registered';
      case 'weak-password':
        return 'Password must be at least 8 characters with letters, numbers & symbols';
      case 'operation-not-allowed':
        return 'This operation is not allowed';
      default:
        return 'Authentication failed: ${e.message}';
    }
  }

  static void showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('OK'),
          )
        ],
      ),
    );
  }
}