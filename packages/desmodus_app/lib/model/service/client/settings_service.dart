// import 'package:desmodus_app/util/storage.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class SettingsService {
//   static final SharedPreferences _localStorage = GlobalStorage.prefs;
//   static final SettingsService _instance = SettingsService._internal();

//   SettingsService._internal();

//   factory SettingsService() {
//     return _instance;
//   }

//   Map<String, dynamic> loadSettings() {
//     final settings = _defaultSettings();
//     settings.forEach((key, value) {
//       settings[key] = _localStorage.getString(key) ?? value;
//     });
//     return settings;
//   }

//   Future<void> updateSettings(Map<String, dynamic> newSettings) async {
//     for (var entry in newSettings.entries) {
//       await _localStorage.setString(
//           'settings.${entry.key}', entry.value.toString());
//     }
//   }

//   Map<String, dynamic> _defaultSettings() {
//     return {
//       'settings.email_notifications': true,
//       'settings.whatsapp_notifications': true,
//     };
//   }
// }
