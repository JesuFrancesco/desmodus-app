import 'package:desmodus_app/config.dart';
import 'package:desmodus_app/viewmodel/controllers/sightings/remote_sightings_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart'
    show openAppSettings;

class LocationController extends GetxController {
  final mapController = MapController();
  final mapKey = UniqueKey();
  final locacionGPS = Location();

  final isLoading = true.obs;
  final hasPermission = false.obs;

  final mapTileUrl =
      Config.jawgAccessToken == "UNDEFINED"
          ? "https://tile.openstreetmap.org/{z}/{x}/{y}.png".obs
          : "https://tile.jawg.io/jawg-terrain/{z}/{x}/{y}.png?access-token=${Config.jawgAccessToken}"
              .obs;
  final heatmapRadius = 50.0.obs;
  final latitud = 0.0.obs;
  final longitud = 0.0.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    isLoading.value = true;
    try {
      await checkPermisoDeUbicacion();
      await _escucharEventosLocator();
    } catch (e) {
      print("Algo salió mal al inicializar el controlador de ubicación: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> checkPermisoDeUbicacion() async {
    try {
      final status = await locacionGPS.hasPermission();

      if (status == PermissionStatus.denied) {
        final newStatus = await locacionGPS.requestPermission();
        if (newStatus != PermissionStatus.granted) {
          await _mostrarDialogoPermiso(
            "Permisos de ubicación",
            "Para usar esta función, debes habilitar los permisos de ubicación.",
          );

          await locacionGPS.requestPermission();
        }
      } else if (status == PermissionStatus.deniedForever) {
        await _mostrarDialogoPermiso(
          "Permisos de ubicación",
          "Los permisos de ubicación están permanentemente denegados. Ve a la configuración para habilitarlos.",
          mostrarBotonConfiguracion: true,
        );
      }

      hasPermission.value =
          await locacionGPS.hasPermission() == PermissionStatus.granted;
    } catch (e) {
      // handle errors
    }
  }

  Future<void> _escucharEventosLocator() async {
    bool serviceEnabled = await locacionGPS.serviceEnabled();

    if (!serviceEnabled) {
      serviceEnabled = await locacionGPS.requestService();
      if (!serviceEnabled) return;
    }

    final locationData = await locacionGPS.getLocation();
    latitud.value = locationData.latitude!;
    longitud.value = locationData.longitude!;

    locacionGPS.onLocationChanged.listen((LocationData locationData) {
      latitud.value = locationData.latitude!;
      longitud.value = locationData.longitude!;
    });
  }

  Future<Map<String, double>> obtenerUbicacionActual() async {
    try {
      final locationData = await locacionGPS.getLocation();
      latitud.value = locationData.latitude!;
      longitud.value = locationData.longitude!;
      return {"latitud": latitud.value, "longitud": longitud.value};
    } catch (e) {
      debugPrint("Error al obtener la ubicación: $e");
      return {"latitud": 0.0, "longitud": 0.0};
    }
  }

  Future<void> abrirMapa() async {
    Get.toNamed(
      "/heatmap",
      arguments: {"latitud": latitud.value, "longitud": longitud.value},
    );
  }

  Future<void> _mostrarDialogoPermiso(
    String titulo,
    String contenido, {
    bool mostrarBotonConfiguracion = false,
  }) async {
    await Get.dialog(
      AlertDialog(
        title: Text(titulo),
        content: Text(contenido),
        actions: [
          if (mostrarBotonConfiguracion)
            ElevatedButton(
              onPressed: () {
                Get.back();
              },
              child: const Text("Cancelar"),
            ),
          ElevatedButton(
            onPressed: () async {
              Get.back();
              openAppSettings();
            },
            child: const Text("Ir a configuración"),
          ),
        ],
      ),
    );
  }

  Future<void> _forceRefreshHeatmapLayer() async {
    final avistController = Get.find<RemoteSightingsController>();

    // ignore: invalid_use_of_protected_member
    final currentMapTileResource = avistController.allAvistamientos.value;

    // Clear the list and then reassign it to force the heatmap layer to refresh
    avistController.allAvistamientos.value = [];
    await Future.delayed(Duration(milliseconds: 10));
    avistController.allAvistamientos.value = currentMapTileResource;
  }

  void increaseRadius() {
    if (heatmapRadius.value < 1e4) {
      heatmapRadius.value += 10;
    }
    _forceRefreshHeatmapLayer();
  }

  void decreaseRadius() {
    if (heatmapRadius.value > 10) {
      heatmapRadius.value -= 10;
    }
    _forceRefreshHeatmapLayer();
  }
}
