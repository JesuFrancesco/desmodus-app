import 'dart:io' show File;

import 'package:desmodus_app/model/entity/gallery_sighting.dart'
    show GallerySighting;
import 'package:desmodus_app/view/screens/home/gallery/gallery_item/gallery_item_screen.dart'
    show GalleryItemScreen;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PreviewGalleryItem extends StatelessWidget {
  final GallerySighting sighting;

  const PreviewGalleryItem({super.key, required this.sighting});

  @override
  Widget build(BuildContext context) {
    final image =
        sighting.isLocal
            ? Image.file(
              File(sighting.imagePath ?? ""),
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return const Center(child: Text("Error cargando imagen"));
              },
            )
            : Image.network(
              sighting.imagePath ?? "",
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return const Center(child: Text("Error cargando imagen"));
              },
            );

    return GestureDetector(
      onTap:
          () => Get.to(
            GalleryItemScreen(
              image: image,
              descTmp: sighting.description,
              fechaTmp: sighting.date,
            ),
          ),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: image.image,
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.black.withValues(alpha: 0.25),
                  BlendMode.darken,
                ),
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(
                    context,
                  ).colorScheme.primary.withValues(alpha: 0.2),
                  offset: const Offset(0, 2),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 10,
            left: 10,
            child:
                sighting.isLocal
                    ? Icon(Icons.cloud_off, color: Colors.red, size: 30)
                    : Icon(Icons.cloud_outlined, size: 30),
          ),
        ],
      ),
    );
  }
}
