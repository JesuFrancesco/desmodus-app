import 'package:desmodus_app/viewmodel/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthGuard extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final controller = Get.find<AuthController>();

    if (controller.isSignedId == false) {
      debugPrint("Token de acceso no encontrado, redirigiendo a /login");
      return const RouteSettings(name: '/login');
    }

    debugPrint("Token de acceso encontrado, permitiendo el acceso a $route");
    return null;
  }
}
