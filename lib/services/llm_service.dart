import 'dart:convert';
import 'package:http/http.dart' as http;

class LLMService {
  static const String _baseUrl = 'http://localhost:11434';
  
  /// Generates code using the DeepSeek-Coder 1.3B model
  static Future<String> generateCode(String prompt) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/api/generate'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'model': 'deepseek-coder:1.3b',
          'prompt': prompt,
          'stream': false,
          'options': {'temperature': 0.5}
        })
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body)['response'];
      } else {
        throw Exception('Failed to generate code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('LLM service error: $e');
    }
  }

  /// Checks if Ollama service is running
  static Future<bool> checkService() async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl'));
      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }
}