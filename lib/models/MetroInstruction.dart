import 'Instruction.dart';

class MetroInstruction implements Instruction {
  List<MetroStep> metroSteps;

  MetroInstruction(this.metroSteps);
}

class MetroStep{
  String destination;
  String direction;
  String line;
  int stopNumber;
  String image;

  MetroStep(this.destination, this.direction, this.line, this.stopNumber, this.image);
}