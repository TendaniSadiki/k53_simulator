import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/session_model.dart';

class SessionService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Create a new session
  Future<Session> createSession(String userId, String testType, List<Question> questions) async {
    final docRef = _firestore.collection('sessions').doc();
    final session = Session(
      sessionId: docRef.id,
      userId: userId,
      startedAt: DateTime.now(),
      testType: testType,
      questions: questions,
    );

    await docRef.set(session.toFirestore());
    return session;
  }

  // Update session with answers
  Future<void> updateSessionAnswers(String sessionId, List<Question> updatedQuestions) async {
    await _firestore.collection('sessions').doc(sessionId).update({
      'questions': updatedQuestions.map((q) => q.toMap()).toList(),
    });
  }

  // Complete a session
  Future<void> completeSession(String sessionId) async {
    await _firestore.collection('sessions').doc(sessionId).update({
      'completedAt': Timestamp.now(),
    });
  }

  // Get user sessions
  Stream<List<Session>> getUserSessions(String userId) {
    return _firestore
        .collection('sessions')
        .where('userId', isEqualTo: userId)
        .orderBy('startedAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Session.fromFirestore(doc.id, doc.data() as Map<String, dynamic>))
            .toList());
  }

  // Get single session
  Future<Session> getSession(String sessionId) async {
    final doc = await _firestore.collection('sessions').doc(sessionId).get();
    return Session.fromFirestore(doc.id, doc.data() as Map<String, dynamic>);
  }
}