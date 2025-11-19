import 'package:desmodus_app/model/entity/user.dart';
import 'package:desmodus_app/model/service/remote/auth_service.dart';
import 'package:desmodus_app/utils/cookies.dart';
import 'package:desmodus_app/utils/jwt.dart';
import 'package:flutter/material.dart' show WidgetsBinding, debugPrint;
import 'package:get/get.dart';

class AuthController extends GetxController {
  final _service = AuthService();
  final usuarioCompleto = false.obs;

  late final userData = User.anonymous().obs;
  final isLoading = false.obs;

  bool get isSignedId => userData.value.id == 0 ? false : true;

  @override
  void onInit() async {
    super.onInit();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      try {
        _obtenerDatosJWT();
        actualizarInfoUsuario();
      } catch (e) {
        debugPrint(e.toString());
      } finally {
        isLoading.value = false;
      }
    });
  }

  Future<void> _obtenerDatosJWT() async {
    try {
      final cookieAccessToken = await getCookie("access_token");

      assert(
        cookieAccessToken != null,
        "No se encontró el token de acceso en las cookies",
      );

      final payload = parseJwt(cookieAccessToken!);

      // userData.value = {
      //   "id": payload["id"],
      //   "name": payload["sub"],
      // };

      userData.value = User(
        id: payload["id"],
        name: payload["sub"],
        email: payload["email"] ?? userData.value.email,
        phone: payload["phone"] ?? userData.value.phone,
        dni: payload["dni"] ?? userData.value.dni,
        distritoId: payload["distrito_id"] ?? userData.value.distritoId,
        avatarUrl: payload["avatar_url"] ?? userData.value.avatarUrl,
      );
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  // bool isUserInfoComplete(Map<String, dynamic> user) {
  //   final requiredFields = ["name", "email", "phone", "dni", "distrito_id"];
  //   for (var field in requiredFields) {
  //     if (user[field] == null ||
  //         (user[field] is String && user[field].trim().isEmpty)) {
  //       return false;
  //     }
  //   }
  //   return true;
  // }

  Future<void> actualizarInfoUsuario({String? newToken}) async {
    final cookieAccessToken = await getCookie("access_token");

    if (newToken == null && cookieAccessToken == null) {
      userData.value = User.anonymous();
      // return Get.offAndToNamed("/login");
      return Get.offAndToNamed("/home");
    }

    try {
      isLoading.value = true;

      Get.offAndToNamed("/home");

      final user = await _service.getUserData(
        newToken ?? cookieAccessToken ?? "UNAUTHORIZED",
      );

      userData.value = user;

      if (userData.value.isComplete()) {
        usuarioCompleto.value = true;
      } else {
        debugPrint("Usuario incompleto, redirigiendo a cuestionario...");
        return Get.offAndToNamed("/cuestionario");
      }
    } catch (e) {
      debugPrint(e.toString());
      Get.offAndToNamed("/login");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> iniciarSesionConGoogle() async {
    try {
      isLoading.value = true;

      final newAccessToken =
          await _service.googleSignIn(); // manejado con google_sign_in

      storeCookie("access_token", newAccessToken);

      return await actualizarInfoUsuario(
        newToken: newAccessToken,
      ); // incluye redirección
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> iniciarSesionConDs() async {
    try {
      isLoading.value = true;

      return await _service.discordSignIn(); // manejado con launchUrl
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> cerrarSesion() async {
    deleteCookie("access_token");
    await Get.offAndToNamed("/login");
  }
}
