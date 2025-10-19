import 'package:desmodus_app/model/entity/noticia_archivo.dart';

class Noticia {
  final int id;
  final String title;
  final String content;
  final int likes = 0;
  final List<NoticiaArchivo> noticiaArchivos;

  const Noticia(this.id, this.title, this.content, this.noticiaArchivos);

  // Factory constructor to create an instance from JSON
  factory Noticia.fromJson(Map<String, dynamic> json) {
    return Noticia(
      json['id'] as int,
      json['title'] as String,
      json['content'] as String,
      (json['noticiaArchivos'] as List)
          .map((item) => NoticiaArchivo.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}
