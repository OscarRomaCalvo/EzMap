class WrongWalkingInstructionException implements Exception {
  final String routeName;
  final int index;

  WrongWalkingInstructionException(this.routeName,this.index);

  @override
  String toString() {
    return "Error en la definición de la instrucción a pie $index en la ruta $routeName";
  }
}