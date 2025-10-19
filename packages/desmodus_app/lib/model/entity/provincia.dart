import 'package:desmodus_app/model/entity/ubigeo.dart';

class Provincia extends Ubigeo {
  final String departamentoId;

  Provincia({
    required super.id,
    required super.nombre,
    required this.departamentoId,
  });

  factory Provincia.empty() {
    return Provincia(id: "null", nombre: "-", departamentoId: "null");
  }

  factory Provincia.fromJson(Map<String, dynamic> json) {
    return Provincia(
      id: json['id'],
      nombre: json['nombre'],
      departamentoId: json['departamentoId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'nombre': nombre, 'departamentoId': departamentoId};
  }
}
