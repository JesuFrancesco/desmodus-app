import 'dart:io' show File;

import 'package:desmodus_app/database.dart' show Sighting, SightingsCompanion;
import 'package:desmodus_app/model/mapper/sighting_avist_mapper.dart'
    show SightingAvistMapper;
import 'package:desmodus_app/model/service/client/client_sightings_service.dart'
    show ClientSightingsService;
import 'package:desmodus_app/model/service/remote/avist_service.dart'
    show RemoteSightingsService;
import 'package:desmodus_app/utils/exceptions.dart' show BajaConfianzaException;
import 'package:desmodus_app/utils/padding_extensions.dart';
import 'package:desmodus_app/viewmodel/auth_controller.dart'
    show AuthController;
import 'package:desmodus_app/viewmodel/controllers/location_controller.dart'
    show LocationController;
import 'package:desmodus_app/viewmodel/controllers/sightings/remote_sightings_controller.dart'
    show RemoteSightingsController;
import 'package:desmodus_app/viewmodel/detector_controller.dart'
    show DetectorController;
import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Value;

class ClientSightingsController extends GetxController {
  final service = ClientSightingsService();
  final mySightings = <Sighting>[].obs;
  final isLoading = true.obs;

  static const maxInferencedTimes = 30;
  final inferencedTimes = 0.obs;

  @override
  void onInit() async {
    super.onInit();
    try {
      mySightings.value = await service.fetchClientSights();
    } catch (e) {
      print("Error al cargar avistamientos locales: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void resetInferenceCount() {
    inferencedTimes.value = 0;
  }

  void incrementInferenceCount() {
    inferencedTimes.value =
        inferencedTimes.value < maxInferencedTimes
            ? inferencedTimes.value + 1
            : maxInferencedTimes;
  }

  void decrementInferenceCount() {
    inferencedTimes.value =
        inferencedTimes.value > 0 ? inferencedTimes.value - 1 : 0;
  }

  Future<void> uploadSightingToServer(
    BuildContext context,
    Sighting sighting,
    String ubigeoCode,
  ) async {
    try {
      // Mapeo de Sighting (local) a Avistamiento (remoto)
      final mapper = SightingAvistMapper();
      final avistamiento = mapper.sightingToAvistamiento(sighting, ubigeoCode);

      // Subir a servidor
      final remoteAvistService = RemoteSightingsService();
      await remoteAvistService.uploadAvistamiento(
        avistamiento,
        File(sighting.imagePath!),
      );

      // Quitar avistamiento de dispositivo local
      await deleteSighting(sighting);
    } on BajaConfianzaException catch (e) {
      // Si la confianza del avistamiento levanto exception, no subir e informar
      print(e);
      await deleteSighting(sighting);
      Get.dialog(
        AlertDialog(
          icon: Icon(Icons.warning, size: 48, color: Colors.amber),
          title: Text(
            "Advertencia: Clasificación de baja confianza",
            style: Get.theme.textTheme.titleMedium,
          ),
          content: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Descripcion
                Text(
                  "El presente avistamiento fue clasificado con baja confianza. Se cancelará su subida a la base de datos.",
                  style: Get.theme.textTheme.bodyMedium,
                ),
                20.pv,
                // Imagen
                DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Image.file(File(sighting.imagePath!)),
                ),
              ],
            ),
          ),
          actions: [TextButton(onPressed: Get.back, child: Text("Okay"))],
        ),
      );
    } catch (e) {
      // Si ocurre un error al subir el avistamiento, mostrar un mensaje de error
      Get.snackbar(
        "Error",
        "Algo salió mal. (${e.toString()})",
        snackPosition: SnackPosition.TOP,
        backgroundColor:
            Theme.of(
              context.mounted ? context : context,
            ).colorScheme.errorContainer,
        colorText:
            Theme.of(
              context.mounted ? context : context,
            ).colorScheme.onErrorContainer,
      );

      print("Algo salio mal al subir avistamiento $e");
    }
  }

  Future<void> addSighting(String imageFilePath) async {
    isLoading.value = true;

    final authController = Get.find<AuthController>();
    final locationController = Get.find<LocationController>();
    final detectorController = Get.find<DetectorController>();

    final sighting = SightingsCompanion(
      userId: Value(authController.userData.toJson()['id']),
      date: Value(DateTime.now()),
      description: Value(
        'Detección de murciélago vampiro con modelo ${detectorController.detectionModel.value}.',
      ),
      latitude: Value(locationController.latitud.value),
      longitude: Value(locationController.longitud.value),
      imagePath: Value(imageFilePath),
    );

    final insertedSightning = await service.insertarAvistamiento(sighting);

    if (insertedSightning != null) {
      mySightings.insert(0, insertedSightning);
    }

    Get.find<RemoteSightingsController>().cargarAvistamientos();
    Get.find<RemoteSightingsController>().cargarMisAvistamientos();

    isLoading.value = false;
  }

  Future<void> deleteSighting(Sighting sighting) async {
    isLoading.value = true;

    await service.eliminarAvistamiento(sighting);

    mySightings.remove(sighting);

    isLoading.value = false;
  }

  Future<void> deleteSightings() async {
    isLoading.value = true;

    await service.eliminarAvistamientos();

    mySightings.clear();
    isLoading.value = false;
  }
}
