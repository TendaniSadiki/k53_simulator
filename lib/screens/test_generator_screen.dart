import 'package:flutter/material.dart';
import '../services/llm_service.dart';

class TestGeneratorScreen extends StatefulWidget {
  const TestGeneratorScreen({super.key});

  @override
  State<TestGeneratorScreen> createState() => _TestGeneratorScreenState();
}

class _TestGeneratorScreenState extends State<TestGeneratorScreen> {
  final TextEditingController _promptController = TextEditingController();
  String _generatedContent = '';
  bool _isGenerating = false;

  Future<void> _generateTestScenario() async {
    setState(() => _isGenerating = true);
    try {
      final prompt = "Generate a K53 driving test scenario about: ${_promptController.text}";
      final response = await LLMService.generateCode(prompt);
      setState(() => _generatedContent = response);
    } catch (e) {
      setState(() => _generatedContent = "Error: $e");
    } finally {
      setState(() => _isGenerating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Test Scenario Generator')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _promptController,
              decoration: const InputDecoration(
                labelText: 'Enter scenario topic',
                hintText: 'e.g. parallel parking in rainy conditions'
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isGenerating ? null : _generateTestScenario,
              child: _isGenerating 
                ? const CircularProgressIndicator()
                : const Text('Generate Test Scenario'),
            ),
            const SizedBox(height: 30),
            Expanded(
              child: SingleChildScrollView(
                child: Text(_generatedContent),
              ),
            ),
          ],
        ),
      ),
    );
  }
}