import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MapButton extends StatelessWidget {
  const MapButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      // onPressed: () => Get.toNamed('/heatmap'),
      onPressed: null,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.map),
          const SizedBox(width: 8),
          const Text('Ingresar al mapa'),
        ],
      ),
    );
  }
}
