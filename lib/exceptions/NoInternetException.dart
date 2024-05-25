class NoInternetException implements Exception {

  NoInternetException();

  @override
  String toString() {
    return "Error en la conexión a internet";
  }
}