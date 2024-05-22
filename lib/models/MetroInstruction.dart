import 'Instruction.dart';

class MetroInstruction implements Instruction {
  List<MetroStep> metroSteps;

  MetroInstruction(this.metroSteps);
}

class MetroStep{
  String destination;
  String direction;
  String line;
  int stops;

  MetroStep(this.destination, this.direction, this.line, this.stops);
}