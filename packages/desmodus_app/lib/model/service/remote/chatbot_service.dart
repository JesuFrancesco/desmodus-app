import 'dart:convert';
import 'package:desmodus_app/config.dart' show Config;
import 'package:http/http.dart' as http;

class AssistantService {
  Future<String> preguntarChatbot(String message) async {
    final uri = Uri.parse(
      '${Config.apiUrl}/chat?prompt=${Uri.encodeComponent(message)}',
    );

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['output'] ?? 'Sin respuesta del chatbot.';
    } else {
      return 'Error del servidor: ${response.statusCode}';
    }
  }
}
