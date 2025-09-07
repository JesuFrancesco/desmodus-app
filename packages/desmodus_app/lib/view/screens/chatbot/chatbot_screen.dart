import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:desmodus_app/viewmodel/controllers/chatbot_controller.dart';
import 'package:desmodus_app/model/entity/local_message.dart';
import 'package:desmodus_app/view/screens/chatbot/widget/message_widget.dart';

class ChatbotScreen extends StatelessWidget {
  const ChatbotScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final assistantController = Get.put(AssistantController());
    final messageControllerInput = TextEditingController();

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Text("Soporte", style: Theme.of(context).textTheme.titleLarge),
            // CHAT MESSAGES
            FutureBuilder<void>(
              future: assistantController.cargarHistorial(),
              builder:
                  (context, snapshot) => Obx(
                    () => Expanded(
                      child:
                          assistantController.isLoading.value
                              ? const Center(child: CircularProgressIndicator())
                              : assistantController.messages.isEmpty
                              ? const Center(
                                child: Text("Consulta lo que necesites"),
                              )
                              : ListView.builder(
                                itemCount: assistantController.messages.length,
                                itemBuilder: (context, index) {
                                  final message =
                                      assistantController.messages[index];
                                  return MessageWidget(message: message);
                                },
                              ),
                    ),
                  ),
            ),
            // CHAT INPUT
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: messageControllerInput,
                          minLines: 1,
                          maxLines: null,
                          decoration: const InputDecoration(
                            labelText: 'Envía tu mensaje',
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 15,
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.send),
                        onPressed: () {
                          if (messageControllerInput.text.isNotEmpty) {
                            assistantController.enviarMensaje(
                              LocalMessage(
                                sender: "Usuario",
                                message: messageControllerInput.text,
                                createdAt: DateTime.now(),
                              ),
                            );

                            messageControllerInput.clear();
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
