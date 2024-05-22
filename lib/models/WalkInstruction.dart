import 'Instruction.dart';

class WalkInstruction implements Instruction {
  WalkStep firstStep;
  WalkStep? secondStep;

  WalkInstruction(this.firstStep, [this.secondStep]);
}

class WalkStep{
  String image;
  String text;

  WalkStep(this.image, this.text);
}