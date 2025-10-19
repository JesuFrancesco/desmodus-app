class BajaConfianzaException implements Exception {
  final String message;
  BajaConfianzaException(this.message);

  @override
  String toString() {
    return "BajaConfianzaException: $message";
  }
}

class UbigeoNotFoundException implements Exception {
  final String message;
  UbigeoNotFoundException(this.message);

  @override
  String toString() => 'UbigeoNotFoundException: $message';
}
