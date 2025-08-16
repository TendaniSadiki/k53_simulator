import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({super.key});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  int _currentQuestion = 0;
  int _score = 0;
  Interpreter? _interpreter; // TensorFlow Lite interpreter
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
  void initState() {
    super.initState();
    _loadModel();
  }

  @override
  void dispose() {
    _interpreter?.close();
    super.dispose();
  }

  Future<void> _loadModel() async {
    try {
      _interpreter = await Interpreter.fromAsset('assets/models/model.tflite');
    } catch (e) {
      print('Failed to load model: $e');
      // Handle error appropriately (e.g., show error UI)
    }
  }

  // Sample inference function
  Future<void> _runInference() async {
    if (_interpreter == null) {
      print('Interpreter not loaded');
      return;
    }

    try {
      // Create sample input (adjust dimensions based on your model)
      final input = [List.filled(10, 1.0)]; // Example: 10 features
      final output = [List.filled(1, 0.0)]; // Example: single output
      
      // Run inference
      _interpreter!.run(input, output);
      
      print('Inference result: ${output[0][0]}');
    } catch (e) {
      print('Inference error: $e');
    }
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
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _runInference,
                child: const Text('Test Model'),
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