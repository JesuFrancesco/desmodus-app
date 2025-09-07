import 'package:desmodus_app/database.dart' show Sighting;
import 'package:desmodus_app/model/entity/avistamiento.dart';
import 'package:desmodus_app/model/entity/gallery_sighting.dart'
    show GallerySighting;

class SightingAvistMapper {
  Avist sightingToAvistamiento(Sighting sighting, String ubigeoCode) {
    return Avist(
      id: sighting.id,
      userId: sighting.userId,
      latitud: sighting.latitude,
      longitud: sighting.longitude,
      detectedAt: sighting.date,
      description: sighting.description,
      departamentoId: ubigeoCode,
      archivo: null,
    );
  }

  // gallery
  GallerySighting avistamientoToGallerySighting(Avist avistamiento) {
    return GallerySighting(
      id: avistamiento.id ?? -1,
      description: avistamiento.description ?? 'No hay descripción',
      userId: avistamiento.userId,
      latitude: avistamiento.latitud,
      longitude: avistamiento.longitud,
      date: avistamiento.detectedAt,
      imagePath: avistamiento.archivo?.imageUrl ?? '',
      isLocal: false,
    );
  }

  GallerySighting localSightingToGallerySighting(Sighting sighting) {
    return GallerySighting(
      id: sighting.id,
      description: sighting.description,
      userId: sighting.userId,
      latitude: sighting.latitude,
      longitude: sighting.longitude,
      date: sighting.date,
      imagePath: sighting.imagePath,
      isLocal: true,
    );
  }
}
