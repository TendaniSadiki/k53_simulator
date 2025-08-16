import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:k53_simulator/models/image_question.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Save user profile
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

  // Save an image question
  Future<void> saveImageQuestion(ImageQuestion question) {
    return _firestore.collection('image_questions').doc(question.id).set(question.toMap());
  }

  // Fetch randomized image questions
  Future<List<ImageQuestion>> fetchRandomImageQuestions(int limit, {String? userId}) async {
    final query = _firestore.collection('image_questions');
    
    // Optionally filter out questions seen by user
    if (userId != null) {
      query.where('seenBy', arrayContains: userId);
    }

    final snapshot = await query.get();
    final questions = snapshot.docs
      .map((doc) => ImageQuestion.fromMap(doc.data() as Map<String, dynamic>))
      .toList();
    
    // Shuffle and limit results
    questions.shuffle();
    return questions.take(limit).toList();
  }

  // Mark question as seen by user
  Future<void> markQuestionSeen(String questionId, String userId) {
    return _firestore.collection('image_questions').doc(questionId).update({
      'seenBy': FieldValue.arrayUnion([userId])
    });
  }
}