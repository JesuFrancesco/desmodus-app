import 'package:desmodus_app/model/entity/archivo.dart';

class Avistamiento {
  final int id;
  final String description;
  final double longitud;
  final double latitud;

  final double? x;
  final double? y;
  final double? w;
  final double? h;

  final Archivo? archivo;
  final DateTime detectedAt;

  final String departamentoId;
  final int userId;

  Avistamiento({
    required this.id,
    required this.description,
    required this.longitud,
    required this.latitud,
    this.x,
    this.y,
    this.w,
    this.h,
    required this.detectedAt,
    required this.archivo,
    required this.userId,
    required this.departamentoId,
  });

  factory Avistamiento.fromJson(Map<String, dynamic> json) {
    return Avistamiento(
      id: json['id'],
      description: json['description'],
      longitud: double.parse(json['longitud'].toString()),
      latitud: double.parse(json['latitud'].toString()),
      x: json['x'] != null ? double.parse(json['x'].toString()) : null,
      y: json['y'] != null ? double.parse(json['y'].toString()) : null,
      w: json['w'] != null ? double.parse(json['w'].toString()) : null,
      h: json['h'] != null ? double.parse(json['h'].toString()) : null,
      userId: json['userId'],
      departamentoId: json['departamentoId'],
      archivo:
          json['archivo'] == null ? null : Archivo.fromJson(json['archivo']),
      detectedAt: DateTime.parse(json['detectedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
      'longitud': longitud,
      'latitud': latitud,
      'x': x,
      'y': y,
      'w': w,
      'h': h,
      'userId': userId,
      'departamentoId': departamentoId,
      'archivo': archivo?.toJson(),
      'detectedAt': detectedAt.toIso8601String(),
    };
  }
}
