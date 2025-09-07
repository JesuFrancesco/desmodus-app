import 'package:desmodus_app/utils/padding_extensions.dart';
import 'package:desmodus_app/view/ui/theme/fonts.dart';
import 'package:desmodus_app/viewmodel/auth_controller.dart'
    show AuthController;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:desmodus_app/view/screens/home/widgets/news_card.dart';
import 'package:desmodus_app/view/screens/home/widgets/affected_zones_map.dart';
import 'package:desmodus_app/view/screens/home/widgets/district_ranking.dart';
import 'package:desmodus_app/viewmodel/controllers/home_controller.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            elevation: 0,
            centerTitle: true,
            title: Text(
              'Desmodus App',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                fontFamily: AppFonts.primaryFont,
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Sección de últimas noticias
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: Column(
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
                      const SizedBox(height: 16),
                      Obx(
                        () => Column(
                          children:
                              controller.newsList
                                  .map(
                                    (news) => NewsCard(
                                      news: news,
                                      onTap:
                                          () => controller.navigateToNewsDetail(
                                            news,
                                          ),
                                    ),
                                  )
                                  .toList(),
                        ),
                      ),
                    ],
                  ),
                ),

                // Sección de zonas afectadas
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
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
                      const SizedBox(height: 16),
                      const AffectedZonesMap(),
                    ],
                  ),
                ),

                // Sección de ranking de distritos
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
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
                      const SizedBox(height: 16),
                      const DistrictRanking(),
                    ],
                  ),
                ),

                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: TextButton(
                      style: Theme.of(context).textButtonTheme.style?.copyWith(
                        foregroundColor: WidgetStateProperty.all(Colors.red),
                        backgroundColor: WidgetStateProperty.all(
                          Colors.red.shade50,
                        ),
                      ),
                      onPressed: () => authController.logout(),
                      child: Text("Cerrar sesión"),
                    ),
                  ),
                ),
              ],
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
          bottomNavigationBar: Stack(
            alignment: Alignment.bottomCenter,
            clipBehavior: Clip.none,
            children: [
              BottomNavigationBar(
                currentIndex: 0,
                type: BottomNavigationBarType.fixed,
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home),
                    label: 'Feed',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.settings),
                    label: 'Ajustes',
                  ),
                ],
                onTap: controller.onBottomNavTap,
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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        children: [
          Text(
            "Hola ${authController.userPayload["name"]}! 👋",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 24, fontFamily: AppFonts.primaryFont),
          ),
          10.pv,
          CircleAvatar(
            radius: 50,
            backgroundImage: NetworkImage(
              "${authController.userPayload["avatar_url"]}",
            ),
            backgroundColor: Colors.grey[200], // fallback background
          ),
        ],
      ),
    );
  }
}
