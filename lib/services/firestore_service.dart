import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_profile.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Create user profile on registration
  Future<void> createUserProfile(UserProfile profile) async {
    await _firestore.collection('user_profiles').doc(profile.uid).set(profile.toMap());
  }

  // Get user profile stream
  Stream<UserProfile> getUserProfile(String uid) {
    return _firestore.collection('user_profiles').doc(uid).snapshots().map(
          (snapshot) => snapshot.exists ? UserProfile.fromMap(uid, snapshot.data()!) : UserProfile(
            uid: uid,
            learnersLicenseNumber: '',
            preferredLanguage: 'en',
            vehicleType: 'light',
          ),
    );
  }

  // Update user profile
  Future<void> updateUserProfile(UserProfile profile) async {
    await _firestore.collection('user_profiles').doc(profile.uid).update(profile.toMap());
  }

  // Add test result to profile
  Future<void> addTestResult(String uid, TestResult result) async {
    await _firestore.collection('user_profiles').doc(uid).update({
      'testHistory': FieldValue.arrayUnion([result.toMap()])
    });
  }

  // Existing methods below...

  // Save user profile (original)
  Future<void> saveUserProfile(String userId, String fullName, String email, String phone) {
    return _firestore.collection('users').doc(userId).set({
      'fullName': fullName,
      'email': email,
      'phone': phone,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  // Save a new session
  Future<void> saveSession(String userId, Map<String, dynamic> sessionData) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('sessions')
        .add(sessionData);
  }

  // Track WhatsApp shares
  Future<void> trackShare(String userId, String sessionId) {
    return _firestore
        .collection('shares')
        .doc(sessionId)
        .set({'userId': userId, 'timestamp': FieldValue.serverTimestamp()});
  }
}