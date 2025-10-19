import 'package:desmodus_app/database.dart';
import 'package:desmodus_app/model/entity/avistamiento.dart';
import 'package:desmodus_app/model/entity/gallery_sighting.dart';

class SightingAvistMapper {
  Avistamiento sightingToAvistamiento(Sighting sighting, String ubigeoCode) {
    return Avistamiento(
      id: sighting.id,
      userId: sighting.userId,
      latitud: sighting.latitude,
      longitud: sighting.longitude,
      detectedAt: sighting.date,
      description: sighting.description,
      x: sighting.x,
      y: sighting.y,
      w: sighting.w,
      h: sighting.h,
      departamentoId: ubigeoCode,
      archivo: null,
    );
  }

  // gallery
  GallerySighting avistamientoToGallerySighting(Avistamiento avistamiento) {
    return GallerySighting(
      id: avistamiento.id,
      description: avistamiento.description,
      userId: avistamiento.userId,
      latitude: avistamiento.latitud,
      longitude: avistamiento.longitud,
      date: avistamiento.detectedAt,
      x: avistamiento.x,
      y: avistamiento.y,
      w: avistamiento.w,
      h: avistamiento.h,
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
      x: sighting.x,
      y: sighting.y,
      w: sighting.w,
      h: sighting.h,
      isLocal: true,
    );
  }
}
