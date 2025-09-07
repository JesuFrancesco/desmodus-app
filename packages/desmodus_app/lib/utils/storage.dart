import 'package:flutter_secure_storage/flutter_secure_storage.dart'
    show FlutterSecureStorage;
import 'package:shared_preferences/shared_preferences.dart'
    show SharedPreferences;

class GlobalStorage {
  static final GlobalStorage _instance = GlobalStorage._internal();

  static SharedPreferences? _sharedPreferences;
  static FlutterSecureStorage? _secureStorage;

  GlobalStorage._internal();

  factory GlobalStorage() => _instance;

  static Future<void> init() async {
    _sharedPreferences ??= await SharedPreferences.getInstance();
    _secureStorage ??= const FlutterSecureStorage();
  }

  static SharedPreferences get prefs {
    if (_sharedPreferences == null) {
      throw Exception(
          'SharedPreferences not initialized. Call GlobalApp.init() first.');
    }
    return _sharedPreferences!;
  }

  static FlutterSecureStorage get secureStorage {
    if (_secureStorage == null) {
      throw Exception(
          'SecureStorage not initialized. Call GlobalApp.init() first.');
    }
    return _secureStorage!;
  }
}
