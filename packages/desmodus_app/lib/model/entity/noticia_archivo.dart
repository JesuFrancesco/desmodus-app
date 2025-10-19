import 'package:desmodus_app/model/entity/archivo.dart';

class NoticiaArchivo {
  final int id;
  final int noticiaId;
  final int archivoId;
  final Archivo archivo;

  const NoticiaArchivo(this.id, this.noticiaId, this.archivoId, this.archivo);

  // Factory constructor to create an instance from JSON
  factory NoticiaArchivo.fromJson(Map<String, dynamic> json) {
    return NoticiaArchivo(
      json['id'] as int,
      json['noticiaId'] as int,
      json['archivoId'] as int,
      Archivo.fromJson(json['archivo'] as Map<String, dynamic>),
    );
  }
}
