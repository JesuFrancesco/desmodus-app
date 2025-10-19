import 'package:desmodus_app/viewmodel/controllers/home_controller.dart';
import 'package:desmodus_app/viewmodel/controllers/noticia_controller.dart';
import 'package:desmodus_app/viewmodel/controllers/ranking_controller.dart';
import 'package:desmodus_app/viewmodel/controllers/sync_controller.dart';
import 'package:get/get.dart';
import 'package:desmodus_app/viewmodel/controllers/sightings/client_sightings_controller.dart';
import 'package:desmodus_app/viewmodel/controllers/location_controller.dart';
import 'package:desmodus_app/viewmodel/controllers/sightings/remote_sightings_controller.dart';

class HomeBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(HomeController(), permanent: true);
    Get.put(ClientSightingsController(), permanent: true);
    Get.put(RemoteSightingsController(), permanent: true);
    Get.put(LocationController(), permanent: true);

    // Get.lazyPut(() => DashboardController());
    Get.lazyPut(() => NoticiaController());
    Get.lazyPut(() => RankingController());

    Get.put(SyncController(), permanent: true);
  }
}
