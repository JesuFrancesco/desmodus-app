import 'package:desmodus_app/utils/padding_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_heatmap/flutter_map_heatmap.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:desmodus_app/config.dart';
import 'package:desmodus_app/viewmodel/controllers/location_controller.dart';
import 'package:desmodus_app/viewmodel/controllers/sightings/remote_sightings_controller.dart';
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
        action: SnackBarAction(
          label: 'Okay',
          onPressed: () {
            // Some code to undo the change.
          },
        ),
      ),
    );

    return Obx(
      () => !locationController.hasPermission.value
          ? DeniedLocationPermissionWidget()
          // : avistController.isLoading.value
          // ? const Center(child: CircularProgressIndicator())
          : FlutterMap(
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
                TileLayer(
                  urlTemplate:
                      "https://tile.jawg.io/jawg-terrain/{z}/{x}/{y}.png?access-token=${Config.jawgAccessToken}",
                  // urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                  userAgentPackageName: "github.jesufrancesco.desmodus_app",
                ),
                Obx(() {
                  if (avistController.allAvistamientos.isEmpty) {
                    return const SizedBox();
                  }
                  final avistamientoData = InMemoryHeatMapDataSource(
                    data: avistController.allAvistamientos
                        .map(
                          (e) => WeightedLatLng(
                            LatLng(e.latitud, e.longitud),
                            5e1, // 50 avistamientos de peso
                          ),
                        )
                        .toList(),
                  );
                  return HeatMapLayer(
                    heatMapOptions: HeatMapOptions(
                      radius: 1e2, // 100 metros
                    ),
                    heatMapDataSource: avistamientoData,
                  );
                }),
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
                            onTap: () =>
                                Get.snackbar("Avistamiento onTap", "Okay"),
                            child: Icon(
                              Icons.warning,
                              size: 20,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }),
                ...additionalStackWidgets,
              ],
            ),
    );
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
