import 'package:geocoding/geocoding.dart';

Future<List<Placemark>> getPlacemarksFromLatLong(
    double latitude, double longitude) async {
  try {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(latitude, longitude);

    if (placemarks.isEmpty) {
      throw Exception(
        'No se encontraron placemarks para las coordenadas: $latitude, $longitude',
      );
    }

    return placemarks;
  } catch (error) {
    print("Error al obtener los placemarks: $error");
    return [];
  }
}
