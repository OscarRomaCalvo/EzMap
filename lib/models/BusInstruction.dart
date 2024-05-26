import 'Instruction.dart';

class BusInstruction implements Instruction {
  List<BusStep> busSteps;

  BusInstruction(this.busSteps);
}

class BusStep{
  String text;
  String? image;

  BusStep(this.text,this.image);
}