import 'dart:convert' show jsonDecode;

import 'package:desmodus_app/config.dart';
import 'package:desmodus_app/model/entity/noticia.dart';
import 'package:http/http.dart' as http show get;

class NoticiaService {
  Future<List<Noticia>> obtenerNoticiasRecientes() async {
    final res = await http.get(
      Uri.parse('${Config.apiUrl}/noticias'),
      headers: {'Content-Type': 'application/json'},
    );

    if (res.statusCode == 200) {
      final List<dynamic> data = jsonDecode(res.body);
      return data.map((e) => Noticia.fromJson(e)).toList();
    } else {
      throw Exception('Error al cargar las noticias');
    }
  }
}
