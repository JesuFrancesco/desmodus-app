import 'package:app_links/app_links.dart';
import 'package:get/get.dart';
import 'package:desmodus_app/model/service/remote/auth_service.dart';
import 'package:desmodus_app/utils/cookies.dart' show storeCookie, getCookie;

class DeepLinkParser {
  DeepLinkParser._();

  static final _instance = DeepLinkParser._();

  factory DeepLinkParser() => _instance;

  final _appLinks = AppLinks();

  Future<Uri?> getInitialLink() => _appLinks.getInitialLink();

  Future<Map<String, dynamic>> _getUserPayload(String jwt) =>
      AuthService().getUserPayload(jwt);

  void initDeepLinkHandler() => _appLinks.uriLinkStream.listen((Uri uri) {
    print("Deep link recibido: $uri");
    final String jwt = uri.queryParameters['jwt'] ?? '';

    if (jwt.isNotEmpty) {
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

      _getUserPayload(jwt)
          .then((user) {
            print("Autorización exitosa: $jwt");
            // Get.offAndToNamed("/dashboard", arguments: payload);
            if (isUserDataComplete(user)) {
              Get.offAndToNamed("/dashboard");
            } else {
              Get.offAndToNamed("/cuestionario");
            }
          })
          .catchError((e) {
            print(e);
          });
    }
  });

  Future<String> getFirstScreen() async {
    Uri? uri = await getInitialLink();

    if (uri == null) {
      print("El usuario no ha ingresado con un deep link");

      print("Verificando el token...");

      try {
        final jwt = getCookie("access_token") ?? '';

        if (jwt.isEmpty) {
          throw Exception("Token de acceso no encontrado");
        }

        final payload = await _getUserPayload(jwt);
        print("Autorización exitosa: $jwt");
        print(payload);

        return "/home";
      } catch (e) {
        print("Error en la autorización: $e");
      }
    }

    // TODO: manejar deeplinks a pantallas específicas
    return "/login";
  }
}
