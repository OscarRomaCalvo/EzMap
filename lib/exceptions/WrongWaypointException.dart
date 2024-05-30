class WrongWaypointException implements Exception {
  final String routeName;
  final int index;

  WrongWaypointException(this.routeName,this.index);

  @override
  String toString() {
    return "Error en la definición del puntoMapa $index en la ruta $routeName";
  }
}