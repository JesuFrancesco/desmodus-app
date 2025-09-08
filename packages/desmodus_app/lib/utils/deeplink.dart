import 'package:app_links/app_links.dart';
import 'package:get/get.dart';
import 'package:desmodus_app/model/service/remote/auth_service.dart';
import 'package:desmodus_app/utils/cookies.dart' show storeCookie;

class DeepLinkParser {
  // Singleton
  DeepLinkParser._();
  static final _instance = DeepLinkParser._();
  factory DeepLinkParser() => _instance;

  final _appLinks = AppLinks();

  Future<Uri?> getInitialLink() => _appLinks.getInitialLink();

  void iniciarDeepLinkListener() => _appLinks.uriLinkStream.listen((
    Uri uri,
  ) async {
    print("Entrada por DeepLink: $uri");

    final String jwt = uri.queryParameters['jwt'] ?? '';

    if (jwt.isEmpty) {
      return;
    }

    storeCookie("access_token", jwt);

    bool isUserDataComplete(Map<String, dynamic> user) {
      final requiredFields = ["name", "email", "phone", "dni", "distrito_id"];
      for (var field in requiredFields) {
        if (user[field] == null ||
            (user[field] is String && user[field].trim().isEmpty)) {
          return false;
        }
      }
      return true;
    }

    final user = await AuthService().getUserPayload(jwt);
    print("Autorización exitosa: $jwt");

    if (isUserDataComplete(user)) {
      Get.offAndToNamed("/home");
    } else {
      Get.offAndToNamed("/cuestionario");
    }
  });

  // Future<void> verifyAuth() async {
  //   final uri = await getInitialLink();

  //   if (uri == null) {
  //     final jwt = getCookie("access_token") ?? '';

  //     if (jwt.isEmpty) {
  //       Get.offAllNamed("/login");
  //     } else {
  //       Get.offAllNamed("/home");

  //       try {
  //         final payload = await AuthService().getUserPayload(jwt);
  //         // Stay in home
  //         print("Token válido: $payload");
  //       } catch (e) {
  //         print("Token inválido: $e");
  //         Get.offAllNamed("/login");
  //       }
  //     }
  //   }
  // }
}
