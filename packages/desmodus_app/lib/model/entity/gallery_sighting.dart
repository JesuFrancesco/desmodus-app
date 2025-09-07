import 'package:desmodus_app/database.dart' show Sighting;

class GallerySighting extends Sighting {
  final bool isLocal;

  const GallerySighting({
    required this.isLocal,
    required super.id,
    required super.userId,
    required super.latitude,
    required super.longitude,
    required super.date,
    required super.description,
    required super.imagePath,
  });
}
