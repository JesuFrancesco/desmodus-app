import 'package:desmodus_app/utils/padding_extensions.dart';
import 'package:desmodus_app/view/screens/heatmap/widgets/avistamiento_heatmap.dart';
import 'package:desmodus_app/view/screens/heatmap/widgets/avistamiento_tile.dart';
import 'package:desmodus_app/viewmodel/controllers/location_controller.dart';
import 'package:desmodus_app/viewmodel/controllers/sightings/remote_sightings_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

class HeatmapScreen extends StatelessWidget {
  const HeatmapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final avistController = Get.find<RemoteSightingsController>();
    final isRadiusControlVisible = false.obs;

    void showAvistamientosRecientes() {
      Get.bottomSheet(
        DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.75,
          minChildSize: 0.3,
          maxChildSize: 0.75,
          builder:
              (_, controller) => Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: SingleChildScrollView(
                  controller: controller,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          'Listado de avistamientos',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                      5.pv,
                      const Divider(),
                      5.pv,
                      Obx(
                        () =>
                            (avistController.isLoading.value)
                                ? const Center(
                                  child: CircularProgressIndicator(),
                                )
                                : (avistController.allAvistamientos.isEmpty)
                                ? const Center(
                                  child: Text("No hay avistamientos"),
                                )
                                : ListView.separated(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  separatorBuilder: (context, index) {
                                    return Column(
                                      children: [8.pv, const Divider(), 8.pv],
                                    );
                                  },
                                  itemCount:
                                      avistController.allAvistamientos.length,
                                  itemBuilder: (context, index) {
                                    return AvistamientoTile(
                                      avistamiento:
                                          avistController
                                              .allAvistamientos[index],
                                    );
                                  },
                                  // shrinkWrap: true,
                                ),
                      ),
                    ],
                  ),
                ),
              ),
        ),
        isScrollControlled: true,
      );
    }

    return Scaffold(
      body: SafeArea(
        child: AvistamientoHeatmap(
          additionalStackWidgets: [
            Positioned(
              top: 20,
              left: 10,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: Get.back,
              ),
            ),
            Positioned(
              top: 20,
              right: 10,
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      final locationController = Get.find<LocationController>();
                      locationController.mapController.move(
                        LatLng(
                          locationController.latitud.value,
                          locationController.longitud.value,
                        ),
                        12.5,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(12),
                      backgroundColor: Colors.white,
                    ),
                    child: const Icon(
                      Icons.my_location,
                      color: Colors.black,
                      size: 24,
                    ),
                  ),
                  8.pv,
                  ElevatedButton(
                    onPressed: isRadiusControlVisible.toggle,
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(12),
                      backgroundColor: Colors.white,
                    ),
                    child: const Icon(
                      Icons.radar,
                      color: Colors.black,
                      size: 24,
                    ),
                  ),
                  // Animated radius controls
                  Obx(
                    () => AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      child:
                          isRadiusControlVisible.value
                              ? Column(
                                key: const ValueKey('radiusControls'),
                                children: [
                                  8.pv,
                                  ElevatedButton(
                                    onPressed: () {
                                      final locationController =
                                          Get.find<LocationController>();
                                      locationController.increaseRadius();
                                    },
                                    style: ElevatedButton.styleFrom(
                                      shape: const CircleBorder(),
                                      padding: const EdgeInsets.all(8),
                                      backgroundColor: Colors.white,
                                    ),
                                    child: const Icon(
                                      Icons.add,
                                      color: Colors.black,
                                      size: 20,
                                    ),
                                  ),
                                  4.pv,
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withValues(
                                            alpha: 0.1,
                                          ),
                                          blurRadius: 4,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    child: Text(
                                      "${Get.find<LocationController>().heatmapRadius.value.toInt()} m",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color:
                                            Theme.of(context).brightness ==
                                                    Brightness.light
                                                ? Colors.black
                                                : Colors.grey[800],
                                      ),
                                    ),
                                  ),
                                  4.pv,
                                  ElevatedButton(
                                    onPressed: () {
                                      final locationController =
                                          Get.find<LocationController>();
                                      locationController.decreaseRadius();
                                    },
                                    style: ElevatedButton.styleFrom(
                                      shape: const CircleBorder(),
                                      padding: const EdgeInsets.all(8),
                                      backgroundColor: Colors.white,
                                    ),
                                    child: const Icon(
                                      Icons.remove,
                                      color: Colors.black,
                                      size: 20,
                                    ),
                                  ),
                                ],
                              )
                              : const SizedBox.shrink(),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 20,
              right: 10,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(12),
                  backgroundColor: Colors.white,
                ),
                onPressed: showAvistamientosRecientes,
                child: const Icon(Icons.menu, color: Colors.black, size: 24),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
