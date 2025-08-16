import 'package:flutter/material.dart';
import 'package:k53_simulator/services/ollama_service.dart';

class AIChatScreen extends StatefulWidget {
  const AIChatScreen({super.key});

  @override
  State<AIChatScreen> createState() => _AIChatScreenState();
}

class _AIChatScreenState extends State<AIChatScreen> {
  final TextEditingController _controller = TextEditingController();
  String _response = '';
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _sendPrompt() async {
    if (_controller.text.isEmpty) return;

    setState(() {
      _isLoading = true;
      _response = '';
      _errorMessage = null;
    });

    try {
      final response = await OllamaService.chat(_controller.text);
      setState(() {
        _response = response;
        _controller.clear(); // Clear input after successful send
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to connect to AI service. Please check that Ollama is running.';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Assistant'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_errorMessage != null)
                      Container(
                        padding: const EdgeInsets.all(12),
                        color: Colors.red[100],
                        child: Row(
                          children: [
                            const Icon(Icons.error, color: Colors.red),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                _errorMessage!,
                                style: const TextStyle(color: Colors.red),
                              ),
                            ),
                            TextButton(
                              onPressed: _sendPrompt,
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      ),
                    if (_isLoading)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16.0),
                        child: Center(
                          child: Column(
                            children: [
                              CircularProgressIndicator(),
                              SizedBox(height: 8),
                              Text('Thinking...'),
                            ],
                          ),
                        ),
                      ),
                    if (_response.isNotEmpty)
                      Text(_response),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    enabled: !_isLoading,
                    decoration: const InputDecoration(
                      hintText: 'Ask me anything about K53...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                if (_isLoading)
                  const CircularProgressIndicator()
                else
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: _sendPrompt,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}