import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:desmodus_app/viewmodel/auth_controller.dart'
    show AuthController;

class NoAuthAccessButton extends StatelessWidget {
  const NoAuthAccessButton({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();
    return Obx(
      () => ElevatedButton(
        onPressed:
            authController.isLoading.value
                ? null
                : () => Get.toNamed('/login/no-auth-cta'),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.visibility),
            const SizedBox(width: 8),
            const Text('Ingresar al detector'),
          ],
        ),
      ),
    );
  }
}
