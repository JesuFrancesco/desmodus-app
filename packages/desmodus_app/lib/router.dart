import 'package:desmodus_app/view/screens/home/home_screen.dart';
import 'package:desmodus_app/view/screens/detector/detector_screen.dart';
import 'package:desmodus_app/view/screens/heatmap/heatmap_screen.dart';
import 'package:desmodus_app/view/screens/loading/loading_screen.dart'
    show LoadingScreen;
import 'package:desmodus_app/view/screens/news_detail/news_detail_screen.dart';
import 'package:desmodus_app/viewmodel/bindings/camera_bindings.dart';
import 'package:desmodus_app/viewmodel/bindings/home_bindings.dart';
import 'package:desmodus_app/viewmodel/bindings/initial_bindings.dart';
import 'package:get/get.dart';
import 'package:desmodus_app/view/screens/login/login_screen.dart';
import 'package:desmodus_app/view/screens/login/no-auth-cta/no_auth_cta_screen.dart';
import 'package:desmodus_app/view/screens/chatbot/chatbot_screen.dart'
    show ChatbotScreen;
import 'package:desmodus_app/view/screens/cuestionario/cuestionario_screen.dart';
import 'package:desmodus_app/view/ui/theme/theme.dart';
import 'package:desmodus_app/viewmodel/controllers/location_controller.dart';
import 'package:desmodus_app/viewmodel/controllers/news_detail_controller.dart';
import 'package:desmodus_app/viewmodel/controllers/sightings/remote_sightings_controller.dart';

GetMaterialApp getAppRouter(String firstScreen) {
  return GetMaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Desmodus App',
    theme: appTheme,
    darkTheme: darkAppTheme,
    initialRoute: firstScreen,
    getPages: [
      GetPage(name: '/loading', page: () => const LoadingScreen()),
      GetPage(
        name: '/login',
        page: () => const LoginScreen(),
        children: [
          GetPage(name: '/no-auth-cta', page: () => const NoAuthCtaScreen()),
        ],
      ),
      GetPage(
        name: '/home',
        page: () => const HomeScreen(),
        binding: HomeBindings(),
      ),
      GetPage(
        name: '/news-detail',
        page: () => const NewsDetailScreen(),
        binding: BindingsBuilder(() {
          Get.lazyPut(() => NewsDetailController());
        }),
      ),
      GetPage(
        name: '/detector',
        page: () => const DetectorScreen(),
        binding: CameraBindings(),
        // bindings: [],
      ),
      GetPage(
        name: '/chatbot',
        page: () => const ChatbotScreen(),
        // bindings: [],
      ),
      GetPage(
        name: '/heatmap',
        page: () => const HeatmapScreen(),
        binding: BindingsBuilder(() {
          Get.lazyPut(() => RemoteSightingsController());
          Get.lazyPut(() => LocationController());
        }),
      ),
      GetPage(name: '/cuestionario', page: () => const CuestionarioScreen()),
    ],
    initialBinding: InitialBindings(),
  );
}
