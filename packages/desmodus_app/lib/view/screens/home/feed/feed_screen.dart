import 'package:desmodus_app/utils/padding_extensions.dart';
import 'package:desmodus_app/view/ui/theme/fonts.dart';
import 'package:desmodus_app/viewmodel/auth_controller.dart'
    show AuthController;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:desmodus_app/view/screens/home/feed/widgets/news_card.dart';
import 'package:desmodus_app/view/screens/home/feed/widgets/heatmap_preview.dart';
import 'package:desmodus_app/viewmodel/controllers/home_controller.dart';

class FeedScreen extends GetView<HomeController> {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Sección de últimas noticias
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(child: UserGreetingsWidget()),
                      const Text(
                        'Últimas noticias',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          fontFamily: AppFonts.primaryFont,
                        ),
                      ),
                      16.pv,
                      Obx(
                        () =>
                            controller.isLoading.value
                                ? Center(child: CircularProgressIndicator())
                                : SizedBox(
                                  height: 300,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    // padding: const EdgeInsets.only(left: 16),
                                    itemCount: controller.newsList.length,
                                    itemBuilder: (context, index) {
                                      final noticia =
                                          controller.newsList[index];
                                      return NoticiaCard(
                                        noticia: noticia,
                                        onTap: () {
                                          controller.navigateToNewsDetail(
                                            noticia,
                                          );
                                        },
                                      );
                                    },
                                  ),
                                ),
                      ),
                    ],
                  ),

                  16.pv,

                  // Mapa de calor
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Zonas afectadas',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          fontFamily: AppFonts.primaryFont,
                        ),
                      ),
                      16.pv,
                      ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: SizedBox(
                          height: 300,
                          child: const HeatmapPreview(),
                        ),
                      ),
                    ],
                  ),

                  32.pv,
                ],
              ),
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          floatingActionButton: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FloatingActionButton(
                heroTag: "camera",
                onPressed: () => Get.toNamed("detector"),
                child: const Icon(Icons.camera_alt),
              ),
              10.pv,
              FloatingActionButton(
                heroTag: "chatbot",
                child: Icon(Icons.chat_outlined, size: 28),
                onPressed: () => Get.toNamed("chatbot"),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class UserGreetingsWidget extends GetView<AuthController> {
  const UserGreetingsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () =>
          controller.isLoading.value
              ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: const LinearProgressIndicator(),
              )
              : Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Column(
                  children: [
                    Text(
                      "Hola ${controller.userData.value.name}! 👋",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        fontFamily: AppFonts.primaryFont,
                      ),
                    ),
                    10.pv,
                    CircleAvatar(
                      radius: 50,
                      backgroundImage:
                          controller.userData.value.avatarUrl != null
                              ? NetworkImage(
                                "${controller.userData.value.avatarUrl}",
                              )
                              : null,
                      backgroundColor: Colors.grey[200],
                      child:
                          controller.userData.value.avatarUrl == null
                              ? Icon(
                                Icons.account_circle_rounded,
                                color: Colors.black,
                                size: 100,
                              )
                              : null, // fallback background
                    ),
                  ],
                ),
              ),
    );
  }
}
