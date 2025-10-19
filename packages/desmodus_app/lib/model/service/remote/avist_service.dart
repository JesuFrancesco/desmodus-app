import 'dart:convert' show jsonDecode, jsonEncode;
import 'dart:io' show File;

import 'package:desmodus_app/model/entity/avistamiento.dart';
import 'package:desmodus_app/utils/cookies.dart';
import 'package:flutter/material.dart' show debugPrint;
import 'package:http/http.dart' as http;
import 'package:desmodus_app/config.dart' show Config;

class RemoteSightingsService {
  Future<List<Avistamiento>> getAllAvistamientos({
    int offset = 0,
    int limit = 50,
  }) async {
    final res = await http.get(
      Uri.parse('${Config.apiUrl}/avist?offset=$offset&limit=$limit'),
      headers: {'Content-Type': 'application/json'},
    );
    if (res.statusCode == 200) {
      final List<dynamic> data = jsonDecode(res.body);
      return data.map((e) => Avistamiento.fromJson(e)).toList();
    } else {
      throw Exception('Error al cargar los avistamientos');
    }
  }

  Future<List<Avistamiento>> getMyAvistamientos() async {
    final userJwt = getCookie("access_token");

    final res = await http.get(
      Uri.parse('${Config.apiUrl}/avist/user'),
      headers: {
        'Content-Type': 'application/json',
        "Cookie": "access_token=$userJwt",
      },
    );
    if (res.statusCode == 200) {
      final List<dynamic> data = jsonDecode(res.body);
      return data.map((e) => Avistamiento.fromJson(e)).toList();
    } else {
      throw Exception('Error al cargar los avistamientos');
    }
  }

  Future<bool> uploadAvistamiento(Avistamiento avist, File imageFile) async {
    final userJwt = getCookie("access_token");

    final request = http.MultipartRequest(
      'POST',
      Uri.parse('${Config.apiUrl}/avist/'),
    );

    request.fields["data"] = jsonEncode(avist.toJson());
    request.files.add(
      await http.MultipartFile.fromPath('file', imageFile.path),
    );

    request.headers.addAll({
      'Content-Type': 'application/json',
      "Cookie": "access_token=$userJwt",
    });

    final res = await request.send();

    if (res.statusCode != 200) {
      throw Exception(
        'Error al subir avistamiento. status_code=${res.statusCode}',
      );
    }

    return true;
  }

  Future<bool> deleteAvistamiento(int avistId) async {
    final userJwt = getCookie("access_token");

    final request = http.MultipartRequest(
      'DELETE',
      Uri.parse('${Config.apiUrl}/avist/user/$avistId'),
    );

    request.headers.addAll({
      'Content-Type': 'application/json',
      "Cookie": "access_token=$userJwt",
    });

    final res = await request.send();
    final body = await res.stream.bytesToString();

    if (res.statusCode != 200) {
      debugPrint(body);
      throw Exception(
        'Error al eliminar avistamiento. status_code=${res.statusCode}',
      );
    }

    return true;
  }
}
