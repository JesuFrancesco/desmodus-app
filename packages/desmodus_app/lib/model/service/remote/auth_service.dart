import 'dart:convert';
import 'package:desmodus_app/model/entity/user.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:desmodus_app/config.dart';
import 'package:url_launcher/url_launcher.dart';

class AuthService {
  Future<String> flutterGoogleCallback(String gAccessToken) async {
    final url = Uri.parse("${Config.apiUrl}/google-auth/flutter-callback");

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Cookie": "access_token=$gAccessToken",
      },
    );

    if (response.statusCode == 200) {
      final jwt =
          response.headersSplitValues["set-cookie"]
              ?.firstWhere((element) => element.contains("access_token"))
              .split("=")[1]
              .split(";")[0];

      if (jwt != null) {
        return jwt;
      }
    }

    throw Exception(
      'Error al autenticarse con Google. Código ${response.statusCode}',
    );
  }

  Future<String> googleSignIn() async {
    await GoogleSignIn.instance.initialize(
      clientId: Config.googleAndroidClientId,
      serverClientId: Config.googleWebClientId,
    );

    final googleUser = await GoogleSignIn.instance.authenticate();

    final gAuthorization = await googleUser.authorizationClient
        .authorizationForScopes(['email', 'profile']);

    assert(gAuthorization != null);

    final gAccessToken = gAuthorization!.accessToken;

    final jwt = await AuthService().flutterGoogleCallback(gAccessToken);

    return jwt;
  }

  Future<void> discordSignIn() async {
    final uri = Uri.parse(Config.discordOauthUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw Exception('No se pudo abrir Discord OAuth URL');
    }
  }

  Future<Map<String, dynamic>> getUserPayload(String jwt) async {
    final uri = Uri.parse("${Config.apiUrl}/auth/current-user");

    final response = await http.get(
      uri,
      headers: {
        "Content-Type": "application/json",
        "Cookie": "access_token=$jwt",
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final Map<String, dynamic> payload = data["user_data"];
      return payload;
    }

    throw Exception("Algo salió mal. Código: ${response.statusCode}");
  }

  Future<User> getUserData(String jwt) async {
    final uri = Uri.parse("${Config.apiUrl}/users/current");

    final response = await http.get(
      uri,
      headers: {
        "Content-Type": "application/json",
        "Cookie": "access_token=$jwt",
      },
    );

    if (response.statusCode != 200) {
      throw Exception("Algo salió mal ${response.statusCode}");
    }

    final data = jsonDecode(response.body);

    final user = User.fromJson(data);
    debugPrint(
      "👨 Datos del usuario: ${user.toJson()}, isComplete: ${user.isComplete()}",
    );

    return user;
  }
}
