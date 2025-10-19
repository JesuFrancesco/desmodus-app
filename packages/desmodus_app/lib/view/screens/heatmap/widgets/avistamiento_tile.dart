import 'package:desmodus_app/model/entity/avistamiento.dart';
import 'package:desmodus_app/utils/constants.dart';
import 'package:desmodus_app/viewmodel/controllers/location_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';

class AvistamientoTile extends StatelessWidget {
  final Avistamiento avistamiento;
  const AvistamientoTile({super.key, required this.avistamiento});

  String get avistamientoDetails => """ID: ${avistamiento.id}
Fecha: ${DateFormat('dd/MM/yyyy HH:mm').format(avistamiento.detectedAt)}
Departamento: ${departamentosPeru[avistamiento.departamentoId] ?? 'Desconocido'}
Latitud: ${avistamiento.latitud}
Longitud: ${avistamiento.longitud} 
""";

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.back();
        final locationController = Get.find<LocationController>();
        locationController.mapController.move(
          LatLng(avistamiento.latitud, avistamiento.longitud),
          12.5,
        );
      },
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                flex: 2,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    // color: Theme.of(context).colorScheme.primaryContainer,
                    color:
                        Theme.of(context).brightness == Brightness.light
                            ? Colors.grey.shade200
                            : Colors.grey.shade800,
                  ),
                  width: 100,
                  height: 100,
                  child:
                      avistamiento.archivo != null
                          ? Image.network(
                            avistamiento.archivo!.imageUrl,
                            fit: BoxFit.contain,
                          )
                          : Icon(Icons.image, color: Colors.grey[300]),
                ),
              ),
              Expanded(
                flex: 6,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 2.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            avistamientoDetails,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                            textAlign: TextAlign.left,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Flexible(flex: 1, child: Icon(Icons.chevron_right_sharp)),
            ],
          ),
          Text(
            avistamiento.description,
            style: const TextStyle(fontStyle: FontStyle.italic),
            textAlign: TextAlign.left,
            // overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
