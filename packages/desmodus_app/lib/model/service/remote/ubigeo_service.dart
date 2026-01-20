import 'dart:convert';

import 'package:desmodus_app/config.dart';
import 'package:desmodus_app/utils/cookies.dart';
import 'package:desmodus_app/utils/exceptions.dart';
import 'package:desmodus_app/utils/geocoder.dart';
import 'package:desmodus_app/model/entity/departamento.dart';
import 'package:desmodus_app/model/entity/distrito.dart';
import 'package:desmodus_app/model/entity/provincia.dart';
import 'package:flutter/material.dart' show debugPrint;
import 'package:http/http.dart' as http show get;

class UbigeoService {
  Future<String> obtenerCodigoUbigeoDeLatLong(double lat, double long) async {
    final placemarks = await getPlacemarksFromLatLong(lat, long);

    if (placemarks.isEmpty) {
      throw UbigeoNotFoundException(
        'No se encontraron datos de ubicación para las coordenadas proporcionadas.',
      );
    }

    final placemark = placemarks.first;

    for (final p in [
      placemark.administrativeArea,
      placemark.subAdministrativeArea,
      placemark.locality,
      placemark.name,
    ]) {
      if (p == null || p.isEmpty) {
        continue;
      }

      final departamento = p;

      final userJWT = await getCookie("access_token");

      final res = await http.get(
        Uri.parse("${Config.apiUrl}/departamento/query?name=$departamento"),
        headers: {
          'Content-Type': 'application/json',
          "Cookie": "access_token=$userJWT",
        },
      );

      if (res.statusCode != 200) {
        print(res.body);
        continue;
      }

      final data = jsonDecode(res.body);

      if (data == null || data["id"] == null) {
        continue;
      }

      return data["id"];
    }
    // throw UbigeoNotFoundException(
    //   'No se pudo encontrar un código de ubigeo válido para las coordenadas proporcionadas.',
    // );
    debugPrint(
      'No se pudo encontrar un código de ubigeo válido para las coordenadas proporcionadas.'
      "\tUsando código por defecto '000000'.",
    );
    return '000000';
  }

  Future<List<Departamento>> listarDepartamentos() async {
    final res = await http.get(Uri.parse("${Config.apiUrl}/departamento"));
    if (res.statusCode != 200) throw Exception("Error cargando departamentos");

    final departamentosJson = jsonDecode(res.body);
    return (departamentosJson as List)
        .map((e) => Departamento.fromJson(e))
        .toList();
  }

  Future<List<Provincia>> listarProvincias(String departamentoId) async {
    final res = await http.get(
      Uri.parse("${Config.apiUrl}/provincia/$departamentoId"),
    );
    if (res.statusCode != 200) throw Exception("Error cargando provincias");

    final provinciasJson = jsonDecode(res.body);
    return (provinciasJson as List).map((e) => Provincia.fromJson(e)).toList();
  }

  Future<List<Distrito>> listarDistritos(String provinciaId) async {
    final res = await http.get(
      Uri.parse("${Config.apiUrl}/distrito/$provinciaId"),
    );
    if (res.statusCode != 200) throw Exception("Error cargando distritos");

    final distritosJson = jsonDecode(res.body);
    return (distritosJson as List).map((e) => Distrito.fromJson(e)).toList();
  }
}
