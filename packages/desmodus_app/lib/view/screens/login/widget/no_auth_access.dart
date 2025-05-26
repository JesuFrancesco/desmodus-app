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
          const Icon(Icons.lock_open),
          const SizedBox(width: 8),
          const Text('Ingresar únicamente a detector'),
        ],
      ),
    );
  }
}
