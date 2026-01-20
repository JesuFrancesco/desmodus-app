import 'package:desmodus_app/model/mapper/sighting_avist_mapper.dart';
import 'package:desmodus_app/utils/padding_extensions.dart';
import 'package:desmodus_app/view/screens/home/gallery/gallery_item/gallery_item_screen.dart';
import 'package:desmodus_app/viewmodel/controllers/location_controller.dart';
import 'package:desmodus_app/viewmodel/controllers/sightings/remote_sightings_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_heatmap/flutter_map_heatmap.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:permission_handler/permission_handler.dart';

class AvistamientoHeatmap extends StatelessWidget {
  final List<Widget> additionalStackWidgets;
  const AvistamientoHeatmap({super.key, required this.additionalStackWidgets});

  @override
  Widget build(BuildContext context) {
    final locationController = Get.find<LocationController>();
    final avistController = Get.find<RemoteSightingsController>();

    void showUserSnackbar() => ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('¡Eres tú!'),
        action: SnackBarAction(label: 'Okay', onPressed: () {}),
      ),
    );

    return Obx(() {
      if (!locationController.hasPermission.value) {
        return const DeniedLocationPermissionWidget();
      }

      if (avistController.isLoading.value ||
          locationController.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      final lat = locationController.latitud.value;
      final lng = locationController.longitud.value;

      // Validar coordenadas antes de crear el mapa
      if (lat.isNaN ||
          lng.isNaN ||
          !lat.isFinite ||
          !lng.isFinite ||
          (lat == 0 && lng == 0)) {
        return const Center(child: Text("Esperando coordenadas válidas..."));
      }

      return FlutterMap(
        key: locationController.mapKey,
        mapController: locationController.mapController,
        options: MapOptions(
          initialZoom: 12.5,
          minZoom: 5,
          initialCenter: LatLng(
            locationController.latitud.value,
            locationController.longitud.value,
          ),
        ),
        children: [
          // ======================
          // OSM map tile
          // ======================
          Obx(
            () => TileLayer(
              urlTemplate: locationController.mapTileUrl.value,
              userAgentPackageName: "github.jesufrancesco.desmodus_app",
            ),
          ),
          // ====================
          // Heatmap layer
          // ====================
          Obx(
            () =>
                avistController.allAvistamientos.isEmpty
                    ? SizedBox.shrink()
                    : HeatMapLayer(
                      heatMapOptions: HeatMapOptions(
                        radius:
                            locationController.heatmapRadius.value, // 50 metros
                      ),
                      heatMapDataSource: InMemoryHeatMapDataSource(
                        data:
                            avistController.allAvistamientos
                                .map(
                                  (e) => WeightedLatLng(
                                    LatLng(e.latitud, e.longitud),
                                    3e1, // 30 avistamientos de peso
                                  ),
                                )
                                .toList(),
                      ),
                    ),
          ),
          // ============================
          // Avistamiento Markers layer
          // ============================
          Obx(() {
            final lat = locationController.latitud.value;
            final lng = locationController.longitud.value;
            final allAvist = avistController.allAvistamientos;
            return MarkerLayer(
              markers: [
                Marker(
                  point: LatLng(lat, lng),
                  child: GestureDetector(
                    onTap: showUserSnackbar,
                    child: const Icon(
                      Icons.location_pin,
                      size: 32,
                      color: Colors.black,
                    ),
                  ),
                ),
                ...allAvist.map(
                  (e) => Marker(
                    point: LatLng(e.latitud, e.longitud),
                    child: GestureDetector(
                      onTap: () {
                        final mapper = SightingAvistMapper();
                        Get.to(
                          GalleryItemScreen(
                            gallerySighting: mapper
                                .avistamientoToGallerySighting(e),
                          ),
                        );
                      },
                      child: Icon(Icons.warning, size: 20, color: Colors.red),
                    ),
                  ),
                ),
              ],
            );
          }),
          ...additionalStackWidgets,
        ],
      );
    });
  }
}

class DeniedLocationPermissionWidget extends StatelessWidget {
  const DeniedLocationPermissionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Text(
                "No tienes permisos de ubicación",
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            10.pv,
            const Text("Por favor, habilita los permisos de ubicación"),
            10.pv,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    openAppSettings();
                  },
                  child: const Text("Ir a configuración"),
                ),
                10.ph,
                IconButton(
                  icon: Icon(Icons.replay),
                  onPressed: () {
                    final locationController = Get.find<LocationController>();
                    locationController.checkPermisoDeUbicacion();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
