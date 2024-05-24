import 'package:ez_maps/models/WalkInstruction.dart';
import 'package:flutter/material.dart';
import 'package:ez_maps/customWidgets/PopUpImage.dart';

import '../services/TextReader.dart';

class InstructionWidget extends StatelessWidget {
  final WalkInstruction instruction;

  InstructionWidget(this.instruction);

  @override
  Widget build(BuildContext context) {
    return instruction.secondStep != null
        ? TwoInstructionWidget(instruction)
        : OneInstructionWidget(instruction);
  }
}

class OneInstructionWidget extends StatefulWidget {
  final WalkInstruction instruction;

  OneInstructionWidget(this.instruction);

  @override
  _OneInstructionWidgetState createState() => _OneInstructionWidgetState();
}

class _OneInstructionWidgetState extends State<OneInstructionWidget> {
  @override
  void initState() {
    super.initState();
    TextReader.speak(widget.instruction.firstStep.text);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          widget.instruction.firstStep.text,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
          softWrap: true,
        ),
        const SizedBox(height: 20.0),
        Flexible(child: PopUpImage(imageURL:widget.instruction.firstStep.image)),
      ],
    );
  }
}

class TwoInstructionWidget extends StatefulWidget {
  final WalkInstruction instruction;

  TwoInstructionWidget(this.instruction);

  @override
  _TwoInstructionWidgetState createState() => _TwoInstructionWidgetState();
}

class _TwoInstructionWidgetState extends State<TwoInstructionWidget> {
  @override
  void initState() {
    super.initState();
    TextReader.speak('${widget.instruction.firstStep.text} ${widget.instruction.secondStep!.text}');
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          widget.instruction.firstStep.text,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
          softWrap: true,
        ),
        const SizedBox(height: 20.0),
        Flexible(
          child: PopUpImage(imageURL:widget.instruction.firstStep.image),
        ),
        const SizedBox(height: 20.0),
        Text(
          widget.instruction.secondStep!.text,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
          softWrap: true,
        ),
        const SizedBox(height: 20.0),
        Flexible(
          child: PopUpImage(imageURL:widget.instruction.secondStep!.image),
        ),
      ],
    );
  }
}

