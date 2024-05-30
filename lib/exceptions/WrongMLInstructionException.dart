class WrongMLInstructionException implements Exception {
  final String routeName;
  final int index;

  WrongMLInstructionException(this.routeName,this.index);

  @override
  String toString() {
    return "Error en la definición de la instrucción en ml $index en la ruta $routeName";
  }
}