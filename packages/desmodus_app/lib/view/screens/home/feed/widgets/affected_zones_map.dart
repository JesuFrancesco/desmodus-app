import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:get/get.dart';
import 'package:desmodus_app/viewmodel/controllers/home_controller.dart';

class AffectedZonesMap extends GetView<HomeController> {
  const AffectedZonesMap({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Mapa OpenStreetMap
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Obx(
              () => FlutterMap(
                options: MapOptions(
                  initialCenter:
                      controller.userLocation.value ??
                      const LatLng(-12.1175, -77.0467), // Lima por defecto
                  initialZoom: 13.0,
                  onTap: (_, __) => controller.checkZoneAlert(),
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.example.desmodus_app',
                  ),
                  // Capa de zonas críticas
                  CircleLayer(
                    circles:
                        controller.criticalZones
                            .map(
                              (zone) => CircleMarker(
                                point: zone.center,
                                radius: zone.radius,
                                color: Colors.red.withValues(alpha: 0.3),
                                borderColor: Colors.red,
                                borderStrokeWidth: 2,
                              ),
                            )
                            .toList(),
                  ),
                  // Marcador de ubicación del usuario
                  if (controller.userLocation.value != null)
                    MarkerLayer(
                      markers: [
                        Marker(
                          point: controller.userLocation.value!,
                          width: 40,
                          height: 40,
                          child: const Icon(
                            Icons.my_location,
                            color: Colors.blue,
                            size: 30,
                          ),
                        ),
                      ],
                    ),
                  // Marcadores de avistamientos
                  MarkerLayer(
                    markers:
                        controller.sightingMarkers
                            .map(
                              (sighting) => Marker(
                                point: sighting.location,
                                width: 40,
                                height: 40,
                                child: Icon(
                                  Icons.location_on,
                                  color:
                                      sighting.isCritical
                                          ? Colors.red
                                          : Colors.orange,
                                  size: 30,
                                ),
                              ),
                            )
                            .toList(),
                  ),
                ],
              ),
            ),
          ),

          // Botón de expandir
          Positioned(
            top: 16,
            right: 16,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: IconButton(
                icon: const Icon(Icons.fullscreen, size: 20),
                onPressed: () => Get.toNamed('/heatmap'),
              ),
            ),
          ),

          // Indicador de zona crítica
          if (controller.isInCriticalZone.value)
            Positioned(
              top: 16,
              left: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.warning, color: Colors.white, size: 16),
                    SizedBox(width: 4),
                    Text(
                      'Zona Crítica',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
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
