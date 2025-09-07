import 'package:desmodus_app/utils/padding_extensions.dart';
import 'package:desmodus_app/utils/permissions.dart'
    show checkCameraAndStoragePermissions;
import 'package:desmodus_app/view/screens/detector/widget/missing_permissions.dart'
    show PermissionsMissingWidget;
import 'package:desmodus_app/view/screens/detector/widget/times.dart'
    show Times;
import 'package:desmodus_app/viewmodel/detector_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ultralytics_yolo/camera_preview/ultralytics_yolo_camera_controller.dart'
    show UltralyticsYoloCameraController;
import 'package:ultralytics_yolo/camera_preview/ultralytics_yolo_camera_preview.dart';
import 'package:ultralytics_yolo/predict/detect/object_detector.dart'
    show ObjectDetector;

class DetectorScreen extends StatelessWidget {
  const DetectorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DetectorController>();
    final ultralyticsController = UltralyticsYoloCameraController(
      deferredProcessing: true,
    );

    return Scaffold(
      body: FutureBuilder<bool>(
        future: checkCameraAndStoragePermissions(),
        builder: (context, snapshot) {
          final allPermissionsGranted = snapshot.data ?? false;

          if (!allPermissionsGranted) {
            return PermissionsMissingWidget();
          }
          return FutureBuilder<ObjectDetector>(
            future: controller.initObjectDetectorWithLocalModel(),
            builder: (context, snapshot) {
              final predictor = snapshot.data;

              if (predictor == null) {
                return Center(
                  child: Column(
                    key: Key("UltralyticsCameraScreenError"),
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Obx(
                        () => Text(
                          "No se ha encontrado el modelo ${controller.detectionModel}...",
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                      20.pv,
                      ElevatedButton(onPressed: Get.back, child: Text("Salir")),
                    ],
                  ),
                );
              }

              return SafeArea(
                key: const Key("UltralyticsCameraScreen"),
                child: Obx(
                  () => Stack(
                    children: [
                      UltralyticsYoloCameraPreview(
                        boundingBoxesColorList: [
                          Colors.red,
                          Colors.green,
                          Colors.blue,
                          Colors.yellow,
                          Colors.purple,
                          Colors.orange,
                        ],
                        controller: ultralyticsController,
                        predictor: predictor,
                        onCameraCreated: () {
                          predictor.loadModel();
                          predictor.setConfidenceThreshold(
                            controller.detectionThreshold.value,
                          );
                        },
                      ),
                      StreamBuilder<double?>(
                        stream: predictor.inferenceTime,
                        builder: (context, snapshot) {
                          final inferenceTime = snapshot.data;

                          return StreamBuilder<double?>(
                            stream: predictor.fpsRate,
                            builder: (context, snapshot) {
                              final fpsRate = snapshot.data;

                              return Times(
                                inferenceTime: inferenceTime,
                                fpsRate: fpsRate,
                              );
                            },
                          );
                        },
                      ),
                      // Return Arrow
                      Positioned(
                        top: 20,
                        left: 10,
                        child: IconButton(
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Colors.black,
                          ),
                          onPressed: () => Get.back(),
                        ),
                      ),
                      // FAB inference button
                      Align(
                        alignment:
                            Alignment.lerp(
                              Alignment.bottomCenter,
                              Alignment.center,
                              0.25,
                            )!,
                        child: FloatingActionButton(
                          heroTag: "toggleInference",
                          onPressed: () {
                            ultralyticsController.toggleLivePrediction();
                            controller.isInferenceOn.value =
                                ultralyticsController.value.isInferenceOn;
                          },
                          child:
                              controller.isInferenceOn.value
                                  ? Icon(Icons.pause_circle_outlined)
                                  : Icon(Icons.radio_button_checked_rounded),
                        ),
                      ),
                      // FAB toggle lens and flashlight
                      Positioned(
                        bottom: 20,
                        right: 10,
                        child: Column(
                          children: [
                            FloatingActionButton(
                              heroTag: "toggleLens",
                              onPressed:
                                  ultralyticsController.toggleLensDirection,
                              child: const Icon(Icons.cameraswitch),
                            ),
                            10.pv,
                            FloatingActionButton(
                              heroTag: "toggleFlashlight",
                              onPressed: () {
                                ultralyticsController.toggleFlashlight();
                                controller.isFlashlightOn.value =
                                    ultralyticsController.value.isFlashlightOn;
                              },
                              child: Icon(
                                controller.isFlashlightOn.value
                                    ? Icons.flashlight_off
                                    : Icons.flashlight_on,
                              ),
                            ),
                          ],
                        ),
                      ),
                      //// Complete inference bar
                      Positioned(
                        top: 0,
                        child: Stack(
                          children: [
                            // Background
                            Container(
                              width: MediaQuery.of(context).size.width,
                              height: 20,
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.secondary,
                                border: Border.all(color: Colors.black),
                              ),
                            ),
                            // Foreground
                            Obx(
                              () => Container(
                                width:
                                    (controller.inferencedCombo.value / 30)
                                        .clamp(0.0, 1.0) *
                                    MediaQuery.of(context).size.width,
                                height: 20,
                                decoration: BoxDecoration(
                                  color: Colors.lightGreen,
                                  border: Border.all(color: Colors.black),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
