import 'dart:math';

import 'package:desmodus_app/viewmodel/controllers/sightings/client_sightings_controller.dart'
    show ClientSightingsController;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ultralytics_yolo/ultralytics_yolo.dart';
import 'package:ultralytics_yolo/ultralytics_yolo_platform_interface.dart';

const String _viewType = 'ultralytics_yolo_camera_preview';

/// A widget that displays the camera preview and run inference on the frames
/// using a Ultralytics YOLO model.
class UltralyticsYoloCameraPreview extends StatefulWidget {
  /// Constructor to create a [UltralyticsYoloCameraPreview].
  const UltralyticsYoloCameraPreview({
    required this.predictor,
    required this.controller,
    required this.onCameraCreated,
    required this.injectedAuthState,
    required this.injectedClientSightingsController,
    required this.injectedSpecies,
    this.boundingBoxesColorList = const [Colors.green, Colors.red],
    this.classificationOverlay,
    this.loadingPlaceholder,
    super.key,
  });

  /// The predictor used to run inference on the camera frames.
  final Predictor? predictor;

  /// The list of colors used to draw the bounding boxes.
  final List<Color> boundingBoxesColorList;

  /// The classification overlay widget.
  final BaseClassificationOverlay? classificationOverlay;

  /// The controller for the camera preview.
  final UltralyticsYoloCameraController controller;

  /// The callback invoked when the camera is created.
  final VoidCallback onCameraCreated;

  /// The placeholder widget displayed while the predictor is loading.
  final Widget? loadingPlaceholder;

  final ClientSightingsController injectedClientSightingsController;
  final bool injectedAuthState;
  final String injectedSpecies;

  @override
  State<UltralyticsYoloCameraPreview> createState() =>
      _UltralyticsYoloCameraPreviewState();
}

class _UltralyticsYoloCameraPreviewState
    extends State<UltralyticsYoloCameraPreview> {
  final _ultralyticsYoloPlatform = UltralyticsYoloPlatform.instance;

  double _currentZoomFactor = 1;

  final double _zoomSensitivity = 0.05;

  final double _minZoomLevel = 1;

  final double _maxZoomLevel = 5;

  void _onPlatformViewCreated(_) {
    widget.onCameraCreated();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<UltralyticsYoloCameraValue>(
      valueListenable: widget.controller,
      builder: (context, value, child) {
        return Stack(
          children: [
            // Camera preview
            () {
              final creationParams = <String, dynamic>{
                'lensDirection': widget.controller.value.lensDirection,
                'format': widget.predictor?.model.format.name,
                'deferredProcessing':
                    widget.controller.value.deferredProcessing,
              };

              switch (defaultTargetPlatform) {
                case TargetPlatform.android:
                  return AndroidView(
                    viewType: _viewType,
                    onPlatformViewCreated: _onPlatformViewCreated,
                    creationParams: creationParams,
                    creationParamsCodec: const StandardMessageCodec(),
                  );
                case TargetPlatform.iOS:
                  return UiKitView(
                    viewType: _viewType,
                    creationParams: creationParams,
                    onPlatformViewCreated: _onPlatformViewCreated,
                    creationParamsCodec: const StandardMessageCodec(),
                  );
                case TargetPlatform.fuchsia ||
                      TargetPlatform.linux ||
                      TargetPlatform.windows ||
                      TargetPlatform.macOS:
                  return Container();
              }
            }(),

            // Results
            () {
              // Predictor not found
              if (widget.predictor == null) {
                return widget.loadingPlaceholder ?? Container();
              }

              // Predictor found, check its type
              switch (widget.predictor.runtimeType) {
                // ignore: type_literal_in_constant_pattern PORFAVOR IGNORAR ESTE WARNING ME QUITO MEDIO DÍA DEBUGEANDOLO
                case ObjectDetector:
                  final objectDetector = widget.predictor as ObjectDetector;

                  return StreamBuilder(
                    stream: objectDetector.detectionResultStream,
                    builder: (
                      BuildContext context,
                      AsyncSnapshot<List<DetectedObject?>?> snapshot,
                    ) {
                      if (snapshot.data == null ||
                          !widget.controller.value.isInferenceOn) {
                        return Container();
                      }

                      final inferenceData = snapshot.data!;
                      print("inferenceData !!!!");
                      print(inferenceData);

                      if (inferenceData.isEmpty) {
                        // Decrementamos el contador de inferencias
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          // WIP
                        });
                        return Container();
                      }

                      // PostFrame para no interrumpir el frame actual
                      // y evitar problemas de rendimiento
                      WidgetsBinding.instance.addPostFrameCallback((_) async {
                        if (inferenceData.every((detectedObject) =>
                            detectedObject?.label != "desmodus-rotundus")) {
                          return;
                        }

                        // Incrementamos el contador de inferencias
                        // y verificamos si ya hemos inferido 30 veces
                        widget.injectedClientSightingsController
                            .incrementInferenceCount();

                        // Si hemos inferido 30 veces, registramos el avistamiento
                        // y mostramos el diálogo de especie detectada
                        if (widget.injectedClientSightingsController
                                .inferencedTimes.value >=
                            30) {
                          // Reiniciamos el contador de inferencias
                          widget.injectedClientSightingsController
                              .resetInferenceCount();

                          // Desactivamos la predicción en vivo
                          widget.controller.toggleLivePrediction();

                          // Tomamos la foto
                          final imageFilePath =
                              await widget.controller.takePicture();

                          if (imageFilePath == null) {
                            print("Error al tomar la foto");
                            return;
                          }

                          // Registramos el avistamiento de forma local
                          widget.injectedClientSightingsController
                              .addSighting(imageFilePath);

                          // Mostramos el diálogo de especie detectada
                          showDetectedSpeciesDialog(
                              context.mounted ? context : context);
                        }
                      });

                      return CustomPaint(
                        painter: ObjectDetectorPainter(
                          snapshot.data! as List<DetectedObject>,
                          widget.boundingBoxesColorList,
                          widget.controller.value.strokeWidth,
                        ),
                      );
                    },
                  );
                // ignore: type_literal_in_constant_pattern PORFAVOR IGNORAR ESTE WARNING ME QUITO MEDIO DÍA DEBUGEANDOLO
                case ImageClassifier:
                  return widget.classificationOverlay ??
                      StreamBuilder(
                        stream: (widget.predictor! as ImageClassifier)
                            .classificationResultStream,
                        builder: (context, snapshot) {
                          final classificationResults = snapshot.data;

                          if (classificationResults == null ||
                              classificationResults.isEmpty) {
                            return Container();
                          }

                          return ClassificationResultOverlay(
                            classificationResults: classificationResults,
                          );
                        },
                      );
                default:
                  return Container();
              }
            }(),

            // Zoom detector
            GestureDetector(
              onScaleUpdate: (details) {
                if (details.pointerCount == 2) {
                  // Calculate the new zoom factor
                  var newZoomFactor = _currentZoomFactor * details.scale;

                  // Adjust the sensitivity for zoom out
                  if (newZoomFactor < _currentZoomFactor) {
                    newZoomFactor = _currentZoomFactor -
                        (_zoomSensitivity *
                            (_currentZoomFactor - newZoomFactor));
                  } else {
                    newZoomFactor = _currentZoomFactor +
                        (_zoomSensitivity *
                            (newZoomFactor - _currentZoomFactor));
                  }

                  // Limit the zoom factor to a range between
                  // _minZoomLevel and _maxZoomLevel
                  final clampedZoomFactor = max(
                    _minZoomLevel,
                    min(_maxZoomLevel, newZoomFactor),
                  );

                  // Update the zoom factor
                  _ultralyticsYoloPlatform.setZoomRatio(clampedZoomFactor);

                  // Update the current zoom factor for the next update
                  _currentZoomFactor = clampedZoomFactor;
                }
              },
              child: Container(
                height: double.infinity,
                width: double.infinity,
                color: Colors.transparent,
                child: const Center(child: Text('')),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<dynamic> showDetectedSpeciesDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Has detectado un murciélago vampiro",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          content: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 120,
                child: Icon(
                  Icons.warning_amber_outlined,
                  color: Colors.orange,
                  size: 120.0,
                ),
              ),
              Text(
                "Este incidente quedará registrado en la base de datos.",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(
                  context,
                ).popUntil(ModalRoute.withName("/dashboard"));
              },
              child: Text(
                "Cerrar",
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          ],
        );
      },
    );
  }
}
