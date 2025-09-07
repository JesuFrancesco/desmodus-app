// import 'package:flutter/services.dart';
// import 'package:desmodus_app/util/storage.dart';

// class DetectorService {
//   final _localStorage = GlobalStorage.prefs;

//   void setPreferredThreshold(double threshold) {
//     _localStorage.setDouble('preferredThreshold', threshold);
//   }

//   double? getPreferredThreshold() {
//     return _localStorage.getDouble('preferredThreshold');
//   }

//   void setPreferredModel(String model) {
//     _localStorage.setString('preferredModel', model);
//   }

//   String? getPreferredModel() {
//     return _localStorage.getString('preferredModel');
//   }

//   Future<List<String>> getLocalModels() async {
//     final allAssets = await AssetManifest.loadFromAssetBundle(rootBundle);

//     return allAssets
//         .listAssets()
//         .where((key) =>
//             key.startsWith('assets/models/') && !key.endsWith('README.md'))
//         .map((key) => key.replaceFirst('assets/models/', ''))
//         .map((key) => key.split('/').first)
//         .toSet()
//         .toList();
//   }
// }
