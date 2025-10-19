import 'dart:convert' show jsonDecode;

import 'package:desmodus_app/config.dart';
import 'package:desmodus_app/model/entity/departamento.dart';
import 'package:http/http.dart' as http show get;

class RankingService {
  Future<List<DepartamentoRanking>> obtenerRankingDepartamentos() async {
    final res = await http.get(
      Uri.parse('${Config.apiUrl}/departamento/ranking'),
      headers: {'Content-Type': 'application/json'},
    );

    if (res.statusCode == 200) {
      final List<dynamic> data = jsonDecode(res.body);
      return data.map((e) => DepartamentoRanking.fromJson(e)).toList();
    } else {
      throw Exception('Error al cargar los departamentos');
    }
  }
}
