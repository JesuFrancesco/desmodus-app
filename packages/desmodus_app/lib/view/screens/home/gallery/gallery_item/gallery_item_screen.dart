import 'dart:async' show Completer;
import 'dart:ui' as ui;

import 'package:desmodus_app/model/entity/gallery_sighting.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GalleryItemController extends GetxController {
  final GallerySighting gallerySighting;

  GalleryItemController(this.gallerySighting);

  final decodedImage = Rxn<ui.Image>();

  bool get hasDecodedImage => decodedImage.value != null;
  bool get hasDetection =>
      gallerySighting.x != null &&
      gallerySighting.y != null &&
      gallerySighting.w != null &&
      gallerySighting.h != null;

  @override
  void onInit() {
    super.onInit();
    _decodeImage();
  }

  Future<void> _decodeImage() async {
    final imageProvider = gallerySighting.getImage().image;
    final completer = Completer<ui.Image>();

    imageProvider
        .resolve(const ImageConfiguration())
        .addListener(
          ImageStreamListener((info, _) {
            completer.complete(info.image);
          }),
        );

    final img = await completer.future;
    decodedImage.value = img;
  }
}

class GalleryItemScreen extends StatelessWidget {
  final GallerySighting gallerySighting;

  const GalleryItemScreen({super.key, required this.gallerySighting});

  @override
  Widget build(BuildContext context) {
    // Iniciar controller
    final controller = Get.put(GalleryItemController(gallerySighting));

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Obx(() {
            final img = controller.decodedImage.value;

            if (img == null) {
              return const Center(child: CircularProgressIndicator());
            }

            final origW = img.width.toDouble();
            final origH = img.height.toDouble();

            return Center(
              child: FittedBox(
                fit: BoxFit.contain,
                child: SizedBox(
                  width: origW,
                  height: origH,
                  child: Stack(
                    children: [
                      gallerySighting.getImage(),
                      if (controller.hasDetection)
                        DetectionBox(
                          gallerySighting: gallerySighting,
                          origW: origW,
                          origH: origH,
                        ),
                    ],
                  ),
                ),
              ),
            );
          }),
          SafeArea(
            child: Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: Get.back,
              ),
            ),
          ),
          Positioned(
            bottom: 40,
            left: 20,
            child: SizedBox(
              width: MediaQuery.of(context).size.width - 40,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Imagen tomada el ${gallerySighting.date.toLocal()}",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  Text(
                    gallerySighting.description,
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DetectionBox extends StatelessWidget {
  const DetectionBox({
    super.key,
    required this.gallerySighting,
    required this.origW,
    required this.origH,
  });

  final GallerySighting gallerySighting;
  final double origW;
  final double origH;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          left: gallerySighting.x!.toDouble() * origW,
          top: gallerySighting.y!.toDouble() * origH,
          width: gallerySighting.w!.toDouble() * origW,
          height: gallerySighting.h!.toDouble() * origH,
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.red, width: 8),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
        Positioned(
          left: gallerySighting.x!.toDouble() * origW,
          top: (gallerySighting.y!.toDouble() * origH) - 30,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              "${gallerySighting.date.toLocal()}",
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
