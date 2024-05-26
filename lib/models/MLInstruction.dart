import 'Instruction.dart';

class MLInstruction implements Instruction {
  List<MLStep> mlSteps;

  MLInstruction(this.mlSteps);
}

class MLStep{
  String destination;
  String direction;
  String line;
  int stopNumber;
  String image;

  MLStep(this.destination, this.direction, this.line, this.stopNumber, this.image);
}