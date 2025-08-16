import 'package:cloud_firestore/cloud_firestore.dart';

class Session {
  final String? sessionId;
  final String userId;
  final DateTime startedAt;
  final DateTime? completedAt;
  final String testType;
  final List<Question> questions;

  Session({
    this.sessionId,
    required this.userId,
    required this.startedAt,
    this.completedAt,
    required this.testType,
    required this.questions,
  });

  // Convert to Firestore document
  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'startedAt': Timestamp.fromDate(startedAt),
      'completedAt': completedAt != null ? Timestamp.fromDate(completedAt!) : null,
      'testType': testType,
      'questions': questions.map((q) => q.toMap()).toList(),
    };
  }

  // Create from Firestore document
  factory Session.fromFirestore(String id, Map<String, dynamic> data) {
    return Session(
      sessionId: id,
      userId: data['userId'] ?? '',
      startedAt: (data['startedAt'] as Timestamp).toDate(),
      completedAt: data['completedAt'] != null ? (data['completedAt'] as Timestamp).toDate() : null,
      testType: data['testType'] ?? '',
      questions: (data['questions'] as List<dynamic>? ?? []).map((q) => Question.fromMap(q)).toList(),
    );
  }
}

class Question {
  final String questionId;
  final String text;
  final String type;
  final List<String> options;
  final int correctIndex;
  final int? selectedIndex;
  final bool isCorrect;

  Question({
    required this.questionId,
    required this.text,
    required this.type,
    required this.options,
    required this.correctIndex,
    this.selectedIndex,
    required this.isCorrect,
  });

  // Convert to map
  Map<String, dynamic> toMap() {
    return {
      'questionId': questionId,
      'text': text,
      'type': type,
      'options': options,
      'correctIndex': correctIndex,
      'selectedIndex': selectedIndex,
      'isCorrect': isCorrect,
    };
  }

  // Create from map
  factory Question.fromMap(Map<String, dynamic> map) {
    return Question(
      questionId: map['questionId'] ?? '',
      text: map['text'] ?? '',
      type: map['type'] ?? '',
      options: List<String>.from(map['options'] ?? []),
      correctIndex: map['correctIndex'] ?? -1,
      selectedIndex: map['selectedIndex'],
      isCorrect: map['isCorrect'] ?? false,
    );
  }
}