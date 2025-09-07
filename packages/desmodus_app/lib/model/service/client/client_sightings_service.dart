import 'dart:io' show File;

import 'package:drift/drift.dart' show OrderingTerm;
import 'package:desmodus_app/database.dart';
import 'package:path_provider/path_provider.dart'
    show getApplicationDocumentsDirectory;

class ClientSightingsService {
  Future<List<Sighting>> fetchClientSights() async {
    final db = AppDatabase.instance();
    return (db.select(db.sightings)
      ..orderBy([(t) => OrderingTerm.desc(t.date)])).get();
  }

  Future<Sighting?> insertarAvistamiento(SightingsCompanion sighting) async {
    try {
      final db = AppDatabase.instance();
      final id = await db.into(db.sightings).insert(sighting);
      return Sighting(
        id: id,
        latitude: sighting.latitude.value,
        longitude: sighting.longitude.value,
        description: sighting.description.value,
        imagePath: sighting.imagePath.value,
        date: sighting.date.value,
        userId: sighting.userId.value,
      );
    } on Exception {
      return null;
    }
  }

  Future<bool> eliminarAvistamiento(Sighting sighting) async {
    try {
      final db = AppDatabase.instance();
      await (db.delete(db.sightings)
        ..where((t) => t.id.equals(sighting.id))).go();

      if (sighting.imagePath == null || sighting.imagePath!.isEmpty) {
        return true;
      }

      final file = File(sighting.imagePath!);

      if (await file.exists()) {
        await file.delete();
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> eliminarAvistamientos() async {
    try {
      final db = AppDatabase.instance();
      await db.delete(db.sightings).go();

      final dir = await getApplicationDocumentsDirectory();

      await Future.wait(
        dir
            .listSync()
            .whereType<File>()
            .where(
              (file) =>
                  file.path.endsWith('.jpg') || file.path.endsWith('.png'),
            )
            .map((file) => file.delete()),
      );
      return true;
    } catch (e) {
      return false;
    }
  }
}
