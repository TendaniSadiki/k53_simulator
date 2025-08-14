import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';
import '../services/error_service.dart';

class EmailVerificationScreen extends StatefulWidget {
  const EmailVerificationScreen({super.key});

  @override
  State<EmailVerificationScreen> createState() => _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  final AuthService _auth = AuthService();
  bool _isLoading = false;
  bool _emailSent = false;

  Future<void> _resendVerificationEmail() async {
    setState(() => _isLoading = true);
    try {
      await _auth.sendEmailVerification();
      setState(() => _emailSent = true);
    } on FirebaseAuthException catch (e) {
      ErrorService.showErrorDialog(context, ErrorService.getAuthErrorMessage(e));
    } catch (e) {
      ErrorService.showErrorDialog(context, 'Failed to send verification email');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Email Verification')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.email, size: 80, color: Colors.blue),
            const SizedBox(height: 20),
            const Text(
              'Please verify your email address',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            const Text(
              'We sent a verification email to your inbox. Please check your email and click the verification link.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            if (_emailSent)
              const Text(
                'New verification email sent!',
                style: TextStyle(color: Colors.green),
              ),
            const SizedBox(height: 20),
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _resendVerificationEmail,
                    child: const Text('Resend Verification Email'),
                  ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () => _auth.signOut(),
              child: const Text('Sign Out'),
            ),
          ],
        ),
      ),
    );
  }
}