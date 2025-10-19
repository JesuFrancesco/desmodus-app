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
import 'package:desmodus_app/viewmodel/controllers/sync_controller.dart';
import 'package:desmodus_app/viewmodel/detector_controller.dart'
    show DetectorController;
import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Value;
import 'package:ultralytics_yolo/camera_preview/ultralytics_yolo_camera_controller.dart';
import 'package:ultralytics_yolo/predict/detect/detect.dart';

class ClientSightingsController extends GetxController {
  final service = ClientSightingsService();
  final mySightings = <Sighting>[].obs;
  final isLoading = true.obs;

  static const speciesName = "desmodus-rotundus";
  static const maxInferencedTimes = 30;
  final predCombo = 0.obs;

  @override
  void onInit() async {
    super.onInit();
    try {
      mySightings.value = await service.obtenerAvistamientos();
    } catch (e) {
      debugPrint("Error al cargar avistamientos locales: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void resetInferenceCount() {
    predCombo.value = 0;
  }

  void incrementInferenceCount() {
    predCombo.value =
        predCombo.value < maxInferencedTimes
            ? predCombo.value + 1
            : maxInferencedTimes;
  }

  void decrementInferenceCount() {
    predCombo.value = predCombo.value > 0 ? predCombo.value - 1 : 0;
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

  Future<void> addSighting(
    DetectedObject highestConfidenceObject,
    String imageFilePath,
  ) async {
    try {
      isLoading.value = true;

      final authController = Get.find<AuthController>();
      final locationController = Get.find<LocationController>();
      final detectorController = Get.find<DetectorController>();

      final sighting = SightingsCompanion(
        userId: Value(authController.userData.toJson()['id']),
        date: Value(DateTime.now()),
        description: Value(
          """Detección de ${highestConfidenceObject.label} con modelo ${detectorController.detectionModel.value} con ${(highestConfidenceObject.confidence * 100.0).toStringAsFixed(2)}% de confianza.""",
        ),
        latitude: Value(locationController.latitud.value),
        longitude: Value(locationController.longitud.value),
        x: Value(highestConfidenceObject.x),
        y: Value(highestConfidenceObject.y),
        w: Value(highestConfidenceObject.width),
        h: Value(highestConfidenceObject.height),
        imagePath: Value(imageFilePath),
      );

      debugPrint("Agregando avistamiento a la base de datos local...");
      final insertedSighting = await service.insertarSighting(sighting);

      if (insertedSighting == null) {
        throw Exception(
          "Error al insertar avistamiento en la base de datos local."
          "Revisar logs para más detalles.",
        );
      }

      mySightings.insert(0, insertedSighting);

      Get.find<RemoteSightingsController>().cargarAvistamientos();
      Get.find<RemoteSightingsController>().cargarMisAvistamientos();
    } catch (e) {
      debugPrint("Error al agregar avistamiento: $e");
      Get.snackbar(
        "Error",
        "No se pudo guardar el avistamiento localmente. Intenta de nuevo.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.errorContainer,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteSighting(Sighting sighting) async {
    isLoading.value = true;

    await service.eliminarAvistamiento(sighting);

    mySightings.remove(sighting);

    isLoading.value = false;
  }

  Future<void> deleteSightingById(int id) async {
    isLoading.value = true;

    await service.eliminarAvistamientoPorId(id);

    mySightings.removeWhere((sighting) => sighting.id == id);

    isLoading.value = false;
  }

  Future<void> deleteSightings() async {
    isLoading.value = true;

    await service.eliminarAvistamientos();

    mySightings.clear();
    isLoading.value = false;
  }

  Future<void> handleDetectedObjects(
    List<DetectedObject?> inferenceData,
    UltralyticsYoloCameraController controller,
  ) async {
    final authController = Get.find<AuthController>();

    // Verificamos si se ha detectado el murciélago Desmodus
    if (inferenceData.every(
      (detectedObject) => detectedObject?.label != speciesName,
    )) {
      return;
    }

    // Incrementamos el contador de inferencias
    // y verificamos si ya hemos inferido 30 veces
    incrementInferenceCount();

    // Si hemos inferido 30 veces, registramos el avistamiento
    // y mostramos el diálogo de especie detectada
    if (predCombo.value < 30) return;

    // Reiniciamos el contador de inferencias
    resetInferenceCount();

    // Desactivamos la predicción en vivo
    controller.toggleLivePrediction();

    // Tomamos la foto
    final imageFilePath = await controller.takePicture();

    if (imageFilePath == null) {
      debugPrint("Error al tomar la foto");
      return;
    }

    // Registramos el avistamiento de forma local
    final highestConfidenceObject =
        inferenceData
            .where((obj) => obj != null && obj.label == speciesName)
            .reduce((a, b) => a!.confidence > b!.confidence ? a : b)!;

    debugPrint("Agregando avistamiento local...");

    debugPrint(highestConfidenceObject.x.toString());
    debugPrint(highestConfidenceObject.y.toString());
    debugPrint(highestConfidenceObject.width.toString());
    debugPrint(highestConfidenceObject.height.toString());

    addSighting(highestConfidenceObject, imageFilePath);

    // Mostramos el diálogo de especie detectada
    Get.dialog(
      AlertDialog(
        title: Text(
          "¡Has detectado un murciélago Desmodus!",
          textAlign: TextAlign.center,
          style: Get.theme.textTheme.titleLarge,
        ),
        content: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 120,
              child: Icon(
                Icons.warning_amber_outlined,
                color: Colors.orange,
                size: 120.0,
              ),
            ),
            10.pv,
            Text(
              "Este incidente quedará registrado en la base de datos.",
              textAlign: TextAlign.center,
              style: Get.theme.textTheme.titleMedium,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () async {
              if (authController.isSignedId) {
                Get.find<SyncController>().sincronizarAvistamientos();
                Get.offAllNamed("/home");
              } else {
                Get.offAllNamed("/login");
              }
            },
            child: Text("Cerrar", style: Get.theme.textTheme.titleMedium),
          ),
        ],
      ),
    );
  }
}
