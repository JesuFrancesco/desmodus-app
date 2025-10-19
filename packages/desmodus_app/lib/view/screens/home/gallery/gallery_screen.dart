import 'package:desmodus_app/model/mapper/sighting_avist_mapper.dart'
    show SightingAvistMapper;
import 'package:desmodus_app/utils/padding_extensions.dart';
import 'package:desmodus_app/view/screens/home/gallery/widgets/preview_gallery_item.dart'
    show PreviewGalleryItem;
import 'package:desmodus_app/viewmodel/controllers/sightings/client_sightings_controller.dart'
    show ClientSightingsController;
import 'package:desmodus_app/viewmodel/controllers/sightings/remote_sightings_controller.dart'
    show RemoteSightingsController;
import 'package:desmodus_app/viewmodel/controllers/sync_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GalleryScreen extends StatelessWidget {
  const GalleryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final clientSightingsController = Get.find<ClientSightingsController>();
    final remoteSightingsController = Get.find<RemoteSightingsController>();

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          await Get.find<SyncController>().sincronizarAvistamientos();
          return remoteSightingsController.cargarMisAvistamientos();
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Avistamientos de la especie.",
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.left,
              ),
              20.pv,
              Expanded(
                child: Obx(() {
                  final mapper = SightingAvistMapper();

                  final sightings = [
                    ...remoteSightingsController.myAvistamientos.map(
                      mapper.avistamientoToGallerySighting,
                    ),
                    ...clientSightingsController.mySightings.map(
                      mapper.localSightingToGallerySighting,
                    ),
                  ];

                  if (sightings.isEmpty) {
                    return const Center(child: Text("No hay avistamientos."));
                  }

                  return GridView.builder(
                    padding: const EdgeInsets.all(10),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                    itemCount: sightings.length,
                    itemBuilder: (context, index) {
                      return PreviewGalleryItem(sighting: sightings[index]);
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
