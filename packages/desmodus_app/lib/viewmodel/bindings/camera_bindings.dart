import 'package:desmodus_app/viewmodel/controllers/sightings/client_sightings_controller.dart'
    show ClientSightingsController;
import 'package:get/get.dart';

class CameraBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ClientSightingsController());
  }
}
