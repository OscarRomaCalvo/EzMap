class WrongBusInstructionException implements Exception {
  final String routeName;
  final int index;

  WrongBusInstructionException(this.routeName,this.index);

  @override
  String toString() {
    return "Error en la definición del paso en ml $index en la ruta $routeName";
  }
}