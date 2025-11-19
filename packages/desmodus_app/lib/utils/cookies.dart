import 'package:desmodus_app/utils/storage.dart';

Future<void> storeCookie(String cookieName, String cookieValue) async {
  await GlobalStorage.secureStorage.write(key: cookieName, value: cookieValue);
}

Future<String?> getCookie(String cookieName) async {
  return await GlobalStorage.secureStorage.read(key: cookieName);
}

Future<void> deleteCookie(String cookieName) async {
  await GlobalStorage.secureStorage.delete(key: cookieName);
}
