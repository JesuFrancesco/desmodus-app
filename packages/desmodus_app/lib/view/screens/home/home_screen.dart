import 'package:desmodus_app/utils/padding_extensions.dart';
import 'package:desmodus_app/view/screens/home/feed/feed_screen.dart'
    show FeedScreen;
import 'package:desmodus_app/view/screens/home/gallery/gallery_screen.dart'
    show GalleryScreen;
import 'package:desmodus_app/view/screens/home/settings/settings_screen.dart'
    show SettingsScreen;
import 'package:desmodus_app/view/ui/theme/fonts.dart';
import 'package:desmodus_app/viewmodel/controllers/sync_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:desmodus_app/viewmodel/controllers/home_controller.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  Widget _buildCurrentScreen() {
    switch (controller.currentIndex.value) {
      case 0:
        return const FeedScreen();
      case 1:
        return const SettingsScreen();
      case 2:
        return const GalleryScreen();
      default:
        return const FeedScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    final synController = Get.find<SyncController>();

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
            actions: [
              Obx(
                () =>
                    synController.isSyncing.value
                        ? Row(
                          children: [
                            SizedBox(
                              width: 20,
                              height: 20,
                              child: const CircularProgressIndicator(),
                            ),
                            20.ph,
                          ],
                        )
                        : const SizedBox.shrink(),
              ),
            ],
          ),
          body: Scaffold(
            body: Obx(() => _buildCurrentScreen()),
            bottomNavigationBar: Stack(
              alignment: Alignment.bottomCenter,
              clipBehavior: Clip.none,
              children: [
                Obx(
                  () => BottomNavigationBar(
                    currentIndex: controller.currentIndex.value,
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
                      // BottomNavigationBarItem(
                      //   icon: Icon(Icons.chat_outlined),
                      //   label: 'Chatbot',
                      // ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.photo),
                        label: 'Galería',
                      ),
                    ],
                    onTap: controller.onBottomNavTap,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
