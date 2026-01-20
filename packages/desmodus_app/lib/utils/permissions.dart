import 'dart:io' show Platform;

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart' show debugPrint;
import 'package:permission_handler/permission_handler.dart';

Future<bool> checkCameraAndStoragePermissions() async {
  List<Permission> missingPermissions = [];

  final cameraStatus = await Permission.camera.status;
  if (!cameraStatus.isGranted) missingPermissions.add(Permission.camera);

  if (Platform.isAndroid) {
    final androidInfo = await DeviceInfoPlugin().androidInfo;

    if (androidInfo.version.sdkInt <= 32) {
      final storageStatus = await Permission.storage.status;
      if (!storageStatus.isGranted) {
        missingPermissions.add(Permission.storage);
      }
    } else {
      final photosStatus = await Permission.photos.status;
      if (!photosStatus.isGranted) {
        missingPermissions.add(Permission.photos);
      }
    }
  }

  if (missingPermissions.isEmpty) {
    return true;
  }

  try {
    Map<Permission, PermissionStatus> statuses =
        await missingPermissions.request();

    return statuses[Permission.camera] == PermissionStatus.granted &&
        (statuses[Permission.storage] == PermissionStatus.granted ||
            statuses[Permission.photos] == PermissionStatus.granted);
  } on Exception catch (e) {
    debugPrint("Error solicitando permisos: $e");
    return false;
  }
}
