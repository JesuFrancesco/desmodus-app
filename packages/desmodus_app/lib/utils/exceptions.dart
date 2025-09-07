class BajaConfianzaException implements Exception {
  final String message;
  BajaConfianzaException(this.message);

  @override
  String toString() {
    return "BajaConfianzaException: $message";
  }
}
