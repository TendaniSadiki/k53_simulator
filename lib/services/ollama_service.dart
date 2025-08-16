import 'dart:convert';
import 'package:http/http.dart' as http;

class OllamaService {
  static const String _baseUrl = 'http://localhost:11434/api';

  /// Sends a prompt to the Ollama API and returns the generated response
  static Future<String> generateResponse(String prompt) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/generate'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'model': 'deepseek-coder:1.3b',
          'prompt': prompt,
          'stream': false,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['response'] ?? '';
      } else {
        throw Exception('Failed to generate response: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  /// Sends a chat-style prompt to the Ollama API
  static Future<String> chat(String prompt) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/chat'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'model': 'deepseek-coder:1.3b',
          'messages': [
            {'role': 'user', 'content': prompt}
          ],
        }),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to chat: ${response.statusCode}');
      }
      
      final data = jsonDecode(response.body);
      return data['message']['content'] ?? '';
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}