import 'Instruction.dart';

class MLInstruction implements Instruction {
  List<MLStep> mlSteps;

  MLInstruction(this.mlSteps);
}

class MLStep{
  String destination;
  String direction;
  String line;
  int stops;

  MLStep(this.destination, this.direction, this.line, this.stops);
}