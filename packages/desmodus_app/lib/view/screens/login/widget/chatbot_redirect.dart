import 'package:flutter/material.dart';
// import 'package:get/get.dart';

class ChatbotButton extends StatelessWidget {
  const ChatbotButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      // onPressed: () => Get.toNamed('/chatbot'),
      onPressed: null,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.chat),
          const SizedBox(width: 8),
          const Text('Hablar con chatbot'),
        ],
      ),
    );
  }
}
