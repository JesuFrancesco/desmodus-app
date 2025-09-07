import 'package:desmodus_app/viewmodel/controllers/location_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';

import '../../../../model/entity/avistamiento.dart';

class AvistamientoTile extends StatelessWidget {
  final Avist avistamiento;
  const AvistamientoTile({super.key, required this.avistamiento});

  String get avistamientoDetails => """Avistamiento: ${avistamiento.id}
Latitud ${avistamiento.latitud}
Longitud ${avistamiento.longitud} 
Descripción ${avistamiento.description} 
Fecha ${DateFormat('dd/MM/yyyy HH:MM').format(avistamiento.detectedAt)}""";

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
          flex: 2,
          child: SizedBox(
            width: 100,
            height: 100,
            child: Image.asset(
              "assets/image/logo_filled.png",
              fit: BoxFit.contain,
            ),
          ),
        ),
        Expanded(
          flex: 8,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  avistamientoDetails,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  maxLines: 4,
                  textAlign: TextAlign.left,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
        Flexible(
          flex: 2,
          child: IconButton(
            onPressed: () {
              Get.back();
              final locationController = Get.find<LocationController>();
              locationController.mapController.move(
                LatLng(avistamiento.latitud, avistamiento.longitud),
                12.5,
              );
            },
            icon: const Icon(Icons.chevron_right_sharp),
          ),
        ),
      ],
    );
  }
}
