import 'package:desmodus_app/utils/padding_extensions.dart';
import 'package:desmodus_app/view/ui/theme/fonts.dart';
import 'package:desmodus_app/viewmodel/auth_controller.dart'
    show AuthController;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:desmodus_app/view/screens/home/feed/widgets/news_card.dart';
import 'package:desmodus_app/view/screens/home/feed/widgets/affected_zones_map.dart';
import 'package:desmodus_app/view/screens/home/feed/widgets/district_ranking.dart';
import 'package:desmodus_app/viewmodel/controllers/home_controller.dart';

class FeedScreen extends GetView<HomeController> {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();
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
                      Center(
                        child: UserGreetingsWidget(
                          authController: authController,
                        ),
                      ),

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
                        () => SizedBox(
                          height: 400,
                          child: ListView.separated(
                            itemCount: controller.newsList.length,
                            separatorBuilder:
                                (context, index) => const SizedBox(height: 12),
                            itemBuilder: (context, index) {
                              final news = controller.newsList[index];
                              return NoticiaCard(
                                noticia: news,
                                onTap:
                                    () => controller.navigateToNewsDetail(news),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),

                  16.pv,

                  // Sección de zonas afectadas
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
                      const AffectedZonesMap(),
                    ],
                  ),

                  16.pv,

                  // Sección de ranking de distritos
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Ranking de distritos más afectados',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          fontFamily: AppFonts.primaryFont,
                        ),
                      ),
                      16.pv,
                      const DistrictRanking(),
                    ],
                  ),

                  16.pv,

                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Center(
                      child: TextButton(
                        style: Theme.of(
                          context,
                        ).textButtonTheme.style?.copyWith(
                          foregroundColor: WidgetStateProperty.all(Colors.red),
                          backgroundColor: WidgetStateProperty.all(
                            Colors.red.shade50,
                          ),
                        ),
                        onPressed: () => authController.cerrarSesion(),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(Icons.logout),
                            10.ph,
                            Text("Cerrar sesión"),
                          ],
                        ),
                      ),
                    ),
                  ),
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

class UserGreetingsWidget extends StatelessWidget {
  const UserGreetingsWidget({super.key, required this.authController});

  final AuthController authController;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () =>
          authController.isLoading.value
              ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: const CircularProgressIndicator(),
              )
              : Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Column(
                  children: [
                    Text(
                      "Hola ${authController.userData.value.name}! 👋",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        fontFamily: AppFonts.primaryFont,
                      ),
                    ),
                    10.pv,
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(
                        "${authController.userData.value.avatarUrl}",
                      ),
                      backgroundColor: Colors.grey[200], // fallback background
                    ),
                  ],
                ),
              ),
    );
  }
}
