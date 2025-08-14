import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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