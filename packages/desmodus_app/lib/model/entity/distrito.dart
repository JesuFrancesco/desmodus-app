import 'package:desmodus_app/model/entity/ubigeo.dart';

class Distrito extends Ubigeo {
  final String provinciaId;

  Distrito({
    required super.id,
    required super.nombre,
    required this.provinciaId,
  });

  factory Distrito.empty() {
    return Distrito(id: "null", nombre: "-", provinciaId: "null");
  }

  factory Distrito.fromJson(Map<String, dynamic> json) {
    return Distrito(
      id: json['id'],
      nombre: json['nombre'],
      provinciaId: json['provinciaId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'nombre': nombre, 'provinciaId': provinciaId};
  }
}
