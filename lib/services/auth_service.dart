import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firestore_service.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Sign in with email and password
  Future<UserCredential> signIn(String email, String password) async {
    return await _auth.signInWithEmailAndPassword(
        email: email, password: password);
  }

  // Register with email and password
  Future<UserCredential> register(String email, String password, String fullName, String phone) async {
    final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
    
    // Send verification email
    await userCredential.user!.sendEmailVerification();
    
    // Update display name
    await userCredential.user!.updateDisplayName(fullName);
    
    // Save profile to Firestore
    final firestoreService = FirestoreService();
    await firestoreService.saveUserProfile(
      userCredential.user!.uid,
      fullName,
      email,
      phone
    );
    
    // Mark first login
    await FirebaseFirestore.instance
      .collection('users')
      .doc(userCredential.user!.uid)
      .update({'firstLogin': true});
    
    return userCredential;
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