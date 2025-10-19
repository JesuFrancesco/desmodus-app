import 'dart:convert' show jsonEncode;

import 'package:desmodus_app/config.dart';
import 'package:http/http.dart' as http;

class CuestionarioService {
  Future<void> guardarDatos(
    String accessToken,
    Map<String, dynamic> data,
  ) async {
    final res = await http.patch(
      Uri.parse("${Config.apiUrl}/users/current"),
      headers: {
        "Content-Type": "application/json",
        "Cookie": "access_token=$accessToken",
      },
      body: jsonEncode(data),
    );

    if (res.statusCode != 200 && res.statusCode != 201) {
      throw Exception("Error guardando datos del usuario");
    }
  }
}
