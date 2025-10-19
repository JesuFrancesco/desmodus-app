import 'dart:io' show File;

import 'package:desmodus_app/database.dart';
import 'package:flutter/material.dart';

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
    super.x,
    super.y,
    super.w,
    super.h,
  });

  Image getImage() {
    final image =
        isLocal
            ? Image.file(
              File(imagePath ?? ""),
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return const Center(child: Text("Error cargando imagen"));
              },
            )
            : Image.network(
              imagePath ?? "",
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return const Center(child: Text("Error cargando imagen"));
              },
            );
    return image;
  }
}
