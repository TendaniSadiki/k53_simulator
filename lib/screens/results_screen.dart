import 'package:flutter/material.dart';
import '../services/share_service.dart';
import '../models/session_model.dart';

class ResultsScreen extends StatelessWidget {
  final Session session;

  const ResultsScreen({super.key, required this.session});

  @override
  Widget build(BuildContext context) {
    final score = session.questions.where((q) => q.isCorrect).length;
    final total = session.questions.length;

    return Scaffold(
      appBar: AppBar(title: const Text('Test Results')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Your Score: $score/$total', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: session.questions.length,
                itemBuilder: (ctx, index) {
                  final question = session.questions[index];
                  return ListTile(
                    title: Text(question.text),
                    subtitle: Text(question.options[question.selectedIndex ?? -1]),
                    trailing: Icon(
                      question.isCorrect ? Icons.check : Icons.close,
                      color: question.isCorrect ? Colors.green : Colors.red,
                    ),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: () => ShareService.shareProgress(session.sessionId!, session.userId),
              child: const Text('Share Results via WhatsApp'),
            ),
          ],
        ),
      ),
    );
  }
}