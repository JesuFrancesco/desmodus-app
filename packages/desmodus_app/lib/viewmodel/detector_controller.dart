import 'package:desmodus_app/model/service/client/detector_service.dart';
import 'package:get/get.dart';
import 'package:ultralytics_yolo/predict/detect/object_detector.dart';
import 'dart:io' as io;

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart';
import 'package:ultralytics_yolo/ultralytics_yolo.dart';
import 'package:ultralytics_yolo/yolo_model.dart';

class DetectorController extends GetxController {
  final _service = DetectorService();
  final detectionModel = 'desmodus-y11n'.obs;

  final detectionThreshold = 0.70.obs;

  final isInferenceOn = true.obs;
  final isFlashlightOn = false.obs;

  final localModelsInstalled = <String>[].obs;
  final inferencedCombo = 0.obs;

  @override
  void onInit() {
    super.onInit();
    _loadAvailableModels();
    _loadPreferredModel();
    _loadPrefferedThreshold();

    // _beepTimer = Timer.periodic(const Duration(milliseconds: 1200), (_) async {
    //   if (playBeepSound.value) {
    //     debugPrint("🥺 Reproduciendo sonido de beep...");
    //     playSound();
    //     Future.microtask(() => playSound());
    //   }
    // });
  }

  Future<ObjectDetector> initObjectDetectorWithLocalModel() async {
    final selectedModel = detectionModel.value;

    final modelPath = await _copy(
      "assets/ai-models/$selectedModel/model.tflite",
    );
    final metadataPath = await _copy(
      "assets/ai-models/$selectedModel/metadata.yaml",
    );

    final model = LocalYoloModel(
      id: '',
      task: Task.detect,
      format: Format.tflite,
      modelPath: modelPath,
      metadataPath: metadataPath,
    );

    return ObjectDetector(model: model);
  }

  Future<String> _copy(String assetPath) async {
    final path = '${(await getApplicationSupportDirectory()).path}/$assetPath';

    await io.Directory(dirname(path)).create(recursive: true);

    final file = io.File(path);

    if (!await file.exists()) {
      final byteData = await rootBundle.load(assetPath);
      await file.writeAsBytes(
        byteData.buffer.asUint8List(
          byteData.offsetInBytes,
          byteData.lengthInBytes,
        ),
      );
    }

    return file.path;
  }

  Future<void> _loadAvailableModels() async {
    localModelsInstalled.value = await _service.getLocalModels();
  }

  void _loadPreferredModel() {
    final preferredModel = _service.getPreferredModel();

    if (preferredModel != null) {
      setSelectedModel(preferredModel);
    } else {
      setSelectedModel("lissachatina-yolo-11n");
    }
  }

  void _loadPrefferedThreshold() {
    final preferredThreshold = _service.getPreferredThreshold();

    if (preferredThreshold != null) {
      setDetectionThreshold(preferredThreshold);
    } else {
      setDetectionThreshold(0.70);
    }
  }

  void savePreferredModel() {
    _service.setPreferredModel(detectionModel.value);
  }

  void savePreferredThreshold() {
    _service.setPreferredThreshold(detectionThreshold.value);
  }

  void setDetectionThreshold(double value) => detectionThreshold.value = value;

  void setSelectedModel(String model) => detectionModel.value = model;
}
