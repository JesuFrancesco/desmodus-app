import 'dart:async' show Timer;

import 'package:desmodus_app/model/service/remote/ubigeo_service.dart';
import 'package:desmodus_app/utils/exceptions.dart';
import 'package:desmodus_app/viewmodel/controllers/noticia_controller.dart';
import 'package:desmodus_app/viewmodel/controllers/ranking_controller.dart';
import 'package:desmodus_app/viewmodel/controllers/sightings/client_sightings_controller.dart';
import 'package:desmodus_app/viewmodel/controllers/sightings/remote_sightings_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SyncController extends GetxController {
  late final Timer _timer;
  final isLoading = true.obs;
  final isSyncing = false.obs;
  final clientController = Get.find<ClientSightingsController>();
  final remoteController = Get.find<RemoteSightingsController>();

  @override
  void onInit() {
    super.onInit();

    try {
      _timer = Timer.periodic(
        Duration(minutes: 1),
        (_) => sincronizarAvistamientos(),
      );
    } catch (e) {
      debugPrint("Error al iniciar el controlador de sincronización: $e");
    } finally {
      isLoading.value = false;
      debugPrint("Controlador de sincronización inicializado.");
    }
  }

  @override
  void onClose() {
    _timer.cancel();
    super.onClose();
  }

  Future<bool> sincronizarAvistamientos() async {
    if (isSyncing.value) {
      debugPrint("Sincronización ya en curso, abortando nueva solicitud.");
      return false;
    }

    debugPrint("Sincronizando avistamientos...");
    isSyncing.value = true;

    try {
      final rxSightings = clientController.mySightings;
      List sightings = [...rxSightings];

      if (sightings.isEmpty) {
        debugPrint("No hay avistamientos para sincronizar.");
        return true;
      }

      for (final s in sightings) {
        debugPrint("♦ Sincronizando avistamiento: id=${s.id} ♦");

        assert(Get.context != null, "Contexto no disponible");

        final ubigeoService = UbigeoService();

        String ubigeoCode = "000000";
        try {
          ubigeoCode = await ubigeoService.obtenerCodigoUbigeoDeLatLong(
            s.latitude,
            s.longitude,
          );
        } on UbigeoNotFoundException catch (e) {
          debugPrint("Error: ${e.message}");
          ubigeoCode = "000000";
        }
        await clientController.uploadSightingToServer(
          Get.context!,
          s,
          ubigeoCode,
        );
      }

      debugPrint("♦ Avistamientos sincronizados con el servidor. ♦");

      Get.snackbar(
        "Éxito",
        "Sincronización completada.",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Theme.of(Get.context!).colorScheme.primaryContainer,
        colorText: Theme.of(Get.context!).colorScheme.onPrimaryContainer,
      );

      remoteController.cargarMisAvistamientos();
      remoteController.cargarAvistamientos();

      Get.find<RankingController>().onInit();

      return true;
    } catch (e) {
      debugPrint("Error al sincronizar avistamientos: $e");
      return false;
    } finally {
      debugPrint("Sincronización de avistamientos finalizada.");
      isSyncing.value = false;
    }
  }

  Future<bool> reiniciarControllers() async {
    try {
      debugPrint("Reiniciando controllers...");

      clientController.onInit();
      remoteController.onInit();

      Get.find<NoticiaController>().onInit();
      Get.find<RankingController>().onInit();
      // Get.find<DashboardController>().onInit();

      return true;
    } catch (e) {
      debugPrint("Error al reiniciar controllers: $e");
      return false;
    }
  }
}
