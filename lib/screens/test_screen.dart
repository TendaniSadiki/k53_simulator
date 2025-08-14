import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({super.key});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  int _currentQuestion = 0;
  int _score = 0;
  // final FirestoreService _firestore = FirestoreService();

  // Sample K53 questions
  final List<Map<String, dynamic>> _questions = [
    {
      'question': 'What does a red traffic light indicate?',
      'options': ['Stop', 'Proceed with caution', 'Speed up', 'Turn left'],
      'correctIndex': 0
    },
    {
      'question': 'When approaching a yield sign, you should:',
      'options': ['Stop completely', 'Slow down and be ready to stop', 'Speed up', 'Honk your horn'],
      'correctIndex': 1
    },
    {
      'question': 'What is the speed limit in a residential area?',
      'options': ['60 km/h', '80 km/h', '100 km/h', '120 km/h'],
      'correctIndex': 0
    }
  ];

  void _answerQuestion(int selectedIndex) {
    final isCorrect = selectedIndex == _questions[_currentQuestion]['correctIndex'];
    
    setState(() {
      if (isCorrect) _score++;
      _currentQuestion++;
    });

    // Save answer to Firestore
    // _firestore.saveAnswer(userId, {
    //   'question': _questions[_currentQuestion]['question'],
    //   'selectedOption': selectedIndex,
    //   'isCorrect': isCorrect,
    //   'timestamp': FieldValue.serverTimestamp()
    // });
  }

  void _shareResults() {
    Share.share(
      'I scored $_score out of ${_questions.length} on the K53 test!',
      subject: 'My K53 Test Results'
    );

    // Track share in Firestore
    // _firestore.trackShare(userId, sessionId);
  }

  @override
  Widget build(BuildContext context) {
    if (_currentQuestion >= _questions.length) {
      return Scaffold(
        appBar: AppBar(title: const Text('Test Results')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Your Score: $_score/${_questions.length}'),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _shareResults,
                child: const Text('Share Results on WhatsApp'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => setState(() {
                  _currentQuestion = 0;
                  _score = 0;
                }),
                child: const Text('Restart Test'),
              )
            ],
          ),
        ),
      );
    }

    final question = _questions[_currentQuestion];
    return Scaffold(
      appBar: AppBar(title: const Text('K53 Test')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Question ${_currentQuestion + 1}/${_questions.length}',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 20),
            Text(
              question['question'],
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 20),
            ...question['options'].asMap().entries.map((entry) {
              final index = entry.key;
              final option = entry.value;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: ElevatedButton(
                  onPressed: () => _answerQuestion(index),
                  child: Text(option),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}