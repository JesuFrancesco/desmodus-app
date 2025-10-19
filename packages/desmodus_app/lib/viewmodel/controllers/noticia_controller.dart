import 'package:desmodus_app/model/entity/noticia.dart';
import 'package:desmodus_app/model/service/remote/noticia_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NoticiaController extends GetxController {
  final service = NoticiaService();
  final allReports = <Noticia>[].obs;
  final isLoading = true.obs;

  @override
  void onReady() async {
    // get noticias / articulos
    try {
      allReports.value = await service.obtenerNoticiasRecientes();
    } catch (e) {
      debugPrint("Error al cargar noticias: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> likeNoticia(int noticiaId) async {
    try {
      // await service.likeNoticia(noticiaId);

      // Actualizar el estado local si es necesario
      final index = allReports.indexWhere((noticia) => noticia.id == noticiaId);
      if (index != -1) {
        // allReports[index].likes += 1;
        allReports.refresh();
      }
    } catch (e) {
      debugPrint("Error al dar like a la noticia: $e");
    }
  }

  Future<void> dislikeNoticia(int noticiaId) async {
    try {
      // await service.dislikeNoticia(noticiaId);

      // Actualizar el estado local si es necesario
      final index = allReports.indexWhere((noticia) => noticia.id == noticiaId);
      if (index != -1) {
        // allReports[index].likes -= 1;
        allReports.refresh();
      }
    } catch (e) {
      debugPrint("Error al dar dislike a la noticia: $e");
    }
  }
}
