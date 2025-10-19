import 'dart:io';
import 'package:desmodus_app/model/entity/gallery_sighting.dart';
import 'package:desmodus_app/view/screens/home/gallery/gallery_item/gallery_item_screen.dart';
import 'package:desmodus_app/view/ui/theme/colors.dart';
import 'package:desmodus_app/viewmodel/controllers/sightings/client_sightings_controller.dart';
import 'package:desmodus_app/viewmodel/controllers/sightings/remote_sightings_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class PreviewGalleryItem extends StatelessWidget {
  final GallerySighting sighting;

  const PreviewGalleryItem({super.key, required this.sighting});

  @override
  Widget build(BuildContext context) {
    final shareLoading = false.obs;
    final deleteLoading = false.obs;

    return GestureDetector(
      onTap:
          () => Get.to(
            () => GalleryItemScreen(gallerySighting: sighting),
            transition: Transition.zoom,
            duration: const Duration(milliseconds: 200),
          ),
      onLongPress: () {
        showCupertinoModalPopup(
          context: Get.context!,
          builder:
              (BuildContext context) => GalleryItemActions(
                shareLoading: shareLoading,
                sighting: sighting,
                deleteLoading: deleteLoading,
              ),
        );
      },
      child: PreviewGridItem(sighting: sighting),
    );
  }
}

class GalleryItemActions extends StatelessWidget {
  const GalleryItemActions({
    super.key,
    required this.shareLoading,
    required this.sighting,
    required this.deleteLoading,
  });

  final RxBool shareLoading;
  final GallerySighting sighting;
  final RxBool deleteLoading;

  @override
  Widget build(BuildContext context) {
    return CupertinoActionSheet(
      actions: <CupertinoActionSheetAction>[
        CupertinoActionSheetAction(
          isDefaultAction: true,
          onPressed: () async {
            try {
              shareLoading.value = true;
              final response = await http.get(Uri.parse(sighting.imagePath!));

              if (response.statusCode == 200) {
                final tempDir = await getTemporaryDirectory();
                final file = File('${tempDir.path}/shared_image.jpg');

                await file.writeAsBytes(response.bodyBytes);
                await SharePlus.instance.share(
                  ShareParams(
                    files: [XFile(file.path)],
                    text:
                        '¡Mira este avistamiento del Desmodus Rotundus que registré en lat. ${sighting.latitude} long. ${sighting.longitude}!',
                  ),
                );
              } else {
                throw Exception('Error al descargar la imagen');
              }
            } catch (e) {
              debugPrint('Error compartiendo la imagen: $e');
            } finally {
              shareLoading.value = false;
              Get.back();
              Get.back(result: true);
            }
          },
          child: Obx(
            () =>
                shareLoading.value
                    ? const CircularProgressIndicator()
                    : const Text('Compartir'),
          ),
        ),
        CupertinoActionSheetAction(
          isDestructiveAction: true,
          onPressed:
              () => Get.dialog(
                AlertDialog(
                  title: const Text('Eliminar avistamiento'),
                  content: const Text(
                    '¿Estás seguro de que deseas eliminar este avistamiento? Esta acción no se puede deshacer.',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () async {
                        try {
                          deleteLoading.value = true;
                          if (sighting.isLocal) {
                            await Get.find<ClientSightingsController>()
                                .deleteSighting(sighting);
                          } else {
                            await Get.find<RemoteSightingsController>()
                                .eliminarAvistamiento(sighting.id);
                          }
                        } catch (e) {
                          debugPrint('Error eliminando avistamiento: $e');
                        } finally {
                          deleteLoading.value = false;
                          Get.back();
                          Get.back(result: true);
                        }
                      },
                      child: Obx(
                        () =>
                            deleteLoading.value
                                ? const CircularProgressIndicator()
                                : const Text(
                                  'Eliminar',
                                  style: TextStyle(
                                    color: AppColors.dangerColor,
                                  ),
                                ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Get.back(); // Cierra el diálogo
                      },
                      child: const Text('Cancelar'),
                    ),
                  ],
                ),
              ),
          child: const Text('Eliminar'),
        ),
      ],
      cancelButton: CupertinoActionSheetAction(
        onPressed: Get.back,
        child: const Text('Cancelar'),
      ),
    );
  }
}

class PreviewGridItem extends StatelessWidget {
  const PreviewGridItem({super.key, required this.sighting});

  final GallerySighting sighting;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: sighting.getImage().image,
              fit: BoxFit.cover,
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
          bottom: 0,
          left: 0,
          child: CustomPaint(
            size: const Size(60, 60), // triangle size
            painter: TrianglePainter(
              color: Colors.black.withValues(alpha: 0.6), // dark background
            ),
          ),
        ),
        Positioned(
          bottom: 5,
          left: 5,
          child:
              sighting.isLocal
                  ? const Icon(Icons.cloud_off, color: Colors.red, size: 25)
                  : const Icon(Icons.cloud_outlined, size: 25),
        ),
      ],
    );
  }
}

class TrianglePainter extends CustomPainter {
  final Color color;
  TrianglePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = color
          ..style = PaintingStyle.fill;

    final path =
        Path()
          ..moveTo(0, size.height) // bottom-left corner
          ..lineTo(size.width, size.height) // bottom-right
          ..lineTo(0, 0) // top-left
          ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(TrianglePainter oldDelegate) => false;
}
