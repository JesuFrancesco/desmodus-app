import 'package:desmodus_app/view/screens/heatmap/widgets/avistamiento_heatmap.dart';
import 'package:desmodus_app/viewmodel/controllers/location_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HeatmapPreview extends StatelessWidget {
  const HeatmapPreview({super.key});

  @override
  Widget build(BuildContext context) {
    final locationController = Get.find<LocationController>();

    return AvistamientoHeatmap(
      additionalStackWidgets: [
        Positioned(
          top: 10,
          right: 10,
          child: ElevatedButton(
            onPressed: locationController.abrirMapa,
            style: ElevatedButton.styleFrom(
              shape: CircleBorder(),
              padding: EdgeInsets.all(10),
              backgroundColor: Colors.white,
            ),
            child: Icon(Icons.fullscreen, color: Colors.black),
          ),
        ),
      ],
    );
  }
}
