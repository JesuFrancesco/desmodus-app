import 'package:desmodus_app/model/entity/ubigeo.dart';

class Departamento extends Ubigeo {
  final String thumbnailUrl;

  Departamento({
    required super.id,
    required super.nombre,
    required this.thumbnailUrl,
  });

  factory Departamento.empty() {
    return Departamento(id: "null", nombre: "-", thumbnailUrl: "");
  }

  factory Departamento.fromJson(Map<String, dynamic> json) {
    return Departamento(
      id: json['id'],
      nombre: json['nombre'],
      thumbnailUrl: json['thumbnailUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'nombre': nombre, 'thumbnailUrl': thumbnailUrl};
  }
}

class DepartamentoRanking extends Departamento {
  final int totalAvistamientos;

  DepartamentoRanking({
    required super.id,
    required super.nombre,
    required super.thumbnailUrl,
    required this.totalAvistamientos,
  });

  factory DepartamentoRanking.fromJson(Map<String, dynamic> json) {
    return DepartamentoRanking(
      id: json['id'],
      nombre: json['nombre'],
      thumbnailUrl: json['thumbnailUrl'],
      totalAvistamientos: json['totalAvistamientos'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final data = super.toJson();
    data['totalAvistamientos'] = totalAvistamientos;
    return data;
  }
}
