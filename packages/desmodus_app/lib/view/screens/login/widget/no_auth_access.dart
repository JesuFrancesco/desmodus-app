import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NoAuthAccessButton extends StatelessWidget {
  const NoAuthAccessButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => Get.toNamed('/login/no-auth-cta'),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.visibility),
          const SizedBox(width: 8),
          const Text('Ingresar al detector'),
        ],
      ),
    );
  }
}
