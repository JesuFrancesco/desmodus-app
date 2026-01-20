import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:desmodus_app/view/ui/theme/custom_icons.dart'
    show DesmodusCustomIcons;
import 'package:desmodus_app/viewmodel/auth_controller.dart'
    show AuthController;

class GoogleSignInButton extends GetView<AuthController> {
  const GoogleSignInButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => ElevatedButton(
        onPressed:
            controller.isLoading.value
                ? null
                : () => controller.iniciarSesionConGoogle(),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(DesmodusCustomIcons.google),
            const SizedBox(width: 8),
            const Text('Inicia sesión con Google'),
          ],
        ),
      ),
    );
  }
}
