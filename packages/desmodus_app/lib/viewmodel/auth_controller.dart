import 'package:get/get.dart';
import 'package:desmodus_app/model/service/remote/auth_service.dart';
import 'package:desmodus_app/utils/cookies.dart';

class AuthController extends GetxController {
  final _service = AuthService();
  final usuarioCompleto = false.obs;
  final userData = <String, dynamic>{}.obs;
  final isLoading = false.obs;

  String? get accessToken => getCookie("access_token");
  bool get isSignedId => userData.isEmpty ? false : true;

  @override
  void onInit() {
    super.onInit();
    actualizarInfoUsuario();
  }

  Future<void> actualizarInfoUsuario({String? newToken}) async {
    try {
      isLoading.value = true;

      final user = await _service.getUserPayload(newToken ?? accessToken!);

      userData.value = user;

      if (usuarioCompleto.value || _isUserDataComplete(user)) {
        usuarioCompleto.value = true;
        Get.offAndToNamed("/home");
      } else {
        Get.offAndToNamed("/cuestionario");
      }
    } catch (e) {
      print(e);
    } finally {
      isLoading.value = false;
    }
  }

  bool _isUserDataComplete(Map<String, dynamic> user) {
    final requiredFields = ["name", "email", "phone", "dni", "distrito_id"];
    for (var field in requiredFields) {
      if (user[field] == null ||
          (user[field] is String && user[field].trim().isEmpty)) {
        return false;
      }
    }
    return true;
  }

  Future<void> iniciarSesionConGoogle() async {
    try {
      isLoading.value = true;

      final newAccessToken = await _service.googleSignIn();

      if (accessToken != "") {
        storeCookie("access_token", newAccessToken);
        await actualizarInfoUsuario(newToken: newAccessToken);
        print("Autorización exitosa: $newAccessToken");
        // Get.offAndToNamed("/home");
      }
    } catch (e) {
      print(e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> iniciarSesionConDs() async {
    try {
      isLoading.value = true;

      await _service.discordSignIn();
    } catch (e) {
      print(e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> cerrarSesion() async {
    deleteCookie("access_token");
    Get.offAndToNamed("/login");
  }

  void logout() {
    cerrarSesion();
  }
}
