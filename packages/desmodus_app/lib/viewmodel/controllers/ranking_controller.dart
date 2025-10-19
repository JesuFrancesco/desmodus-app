import 'package:desmodus_app/model/entity/departamento.dart';
import 'package:desmodus_app/model/service/remote/ranking_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RankingController extends GetxController {
  final service = RankingService();
  final departamentoRankings = <DepartamentoRanking>[].obs;
  final isLoading = true.obs;

  @override
  void onReady() async {
    try {
      departamentoRankings.value = await service.obtenerRankingDepartamentos();
    } catch (e) {
      debugPrint("Error al cargar rankings: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
