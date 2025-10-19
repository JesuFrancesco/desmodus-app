import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:desmodus_app/model/service/remote/avist_service.dart'
    show RemoteSightingsService;

import '../../../model/entity/avistamiento.dart';

class RemoteSightingsController extends GetxController {
  final service = RemoteSightingsService();

  final allAvistamientos = <Avistamiento>[].obs;
  final myAvistamientos = <Avistamiento>[].obs;
  final isLoading = true.obs;

  @override
  void onReady() async {
    await cargarAvistamientos();
    await cargarMisAvistamientos();
  }

  Future<void> cargarAvistamientos() async {
    try {
      isLoading.value = true;
      allAvistamientos.value = await service.getAllAvistamientos();
    } catch (e) {
      debugPrint('Error cargando avistamientos: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> cargarMisAvistamientos() async {
    try {
      isLoading.value = true;
      myAvistamientos.value = await service.getMyAvistamientos();
    } catch (e) {
      debugPrint('Error cargando mis avistamientos: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> eliminarAvistamiento(int avistId) async {
    try {
      isLoading.value = true;

      // Lógica para eliminar el avistamiento en el servidor
      await service.deleteAvistamiento(avistId);

      // Luego recargar la lista de mis avistamientos
      await cargarMisAvistamientos();
      await cargarAvistamientos();
    } catch (e) {
      debugPrint('Error eliminando avistamiento: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
