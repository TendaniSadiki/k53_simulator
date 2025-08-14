import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firestore_service.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Sign in with email and password
  Future<User> signIn(String email, String password) async {
    UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
    return result.user!;
  }

  // Register with email and password
  Future<User> register(String email, String password, String fullName, String phone) async {
    UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
    await result.user!.sendEmailVerification();
    
    // Update display name
    await result.user!.updateDisplayName(fullName);
    
    // Save profile to Firestore with firstLogin flag
    final firestoreService = FirestoreService();
    await firestoreService.saveUserProfile(
      result.user!.uid,
      fullName,
      email,
      phone
    );
    
    // Mark first login
    await FirebaseFirestore.instance
      .collection('users')
      .doc(result.user!.uid)
      .update({'firstLogin': true});
    
    return result.user!;
  }

  // Send password reset email
  Future<void> sendPasswordResetEmail(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  // Send email verification
  Future<void> sendEmailVerification() async {
    if (_auth.currentUser != null) {
      await _auth.currentUser!.sendEmailVerification();
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Auth state stream
  Stream<User?> get user {
    return _auth.authStateChanges();
  }
}