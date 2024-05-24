class WrongMetroInstructionException implements Exception {
  final String routeName;
  final int index;

  WrongMetroInstructionException(this.routeName,this.index);

  @override
  String toString() {
    return "Error en la definición del paso en metro $index en la ruta $routeName";
  }
}