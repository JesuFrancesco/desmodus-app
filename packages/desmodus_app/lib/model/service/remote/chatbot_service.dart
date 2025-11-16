import 'dart:convert';
import 'package:desmodus_app/config.dart' show Config;
import 'package:desmodus_app/utils/cookies.dart';
import 'package:http/http.dart' as http;

class AssistantService {
  Future<String> preguntarChatbot(String message) async {
    final userJwt = getCookie("access_token");

    final uri = Uri.parse('${Config.apiUrl}/chatbot/');

    final response = await http.post(
      uri,
      body: jsonEncode({"question": message}),
      headers: {
        'Content-Type': 'application/json',
        "Cookie": "access_token=$userJwt",
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['response'] is String) {
        return data['response'];
      } else {
        return data['response'].first["text"] ??
            'Lo siento no puedo responder esa pregunta ahora mismo.';
      }
    } else {
      return 'Error del servidor: ${response.statusCode}';
    }
  }
}
