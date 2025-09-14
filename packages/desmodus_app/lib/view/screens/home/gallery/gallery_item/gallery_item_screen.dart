import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GalleryItemScreen extends StatelessWidget {
  final Image image;
  final String descTmp;
  final DateTime fechaTmp;

  const GalleryItemScreen(
      {super.key,
      required this.image,
      required this.descTmp,
      required this.fechaTmp});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned(
              bottom: 40,
              left: 20,
              child: SizedBox(
                width: MediaQuery.of(context).size.width - 40,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Imagen tomada el $fechaTmp",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    Text(
                      descTmp,
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    )
                  ],
                ),
              )),
          Center(child: image),
          SafeArea(
            child: Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: Get.back,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
