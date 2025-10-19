import 'package:desmodus_app/viewmodel/controllers/cuestionario_controller.dart';
import 'package:get/get.dart';

class CuestionarioBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CuestionarioController());
  }
}
