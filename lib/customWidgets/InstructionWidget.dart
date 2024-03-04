import 'package:flutter/material.dart';
import 'package:prueba_ezmaps_estatica/customWidgets/PopUpImage.dart';

class InstructionWidget extends StatelessWidget {
  final step;

  InstructionWidget(this.step);

  @override
  Widget build(BuildContext context) {
    return step['step2'] != null
        ? TwoInstructionWidget(step)
        : OneInstructionWidget(step);
  }
}

class OneInstructionWidget extends StatelessWidget {
  final step;

  OneInstructionWidget(this.step);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          step['step1']['text'],
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
          softWrap: true,
        ),
        const SizedBox(height: 20.0),
        Flexible(child: PopUpImage(step['step1']['image'])),
      ],
    );
  }
}

class TwoInstructionWidget extends StatelessWidget {
  final step;

  TwoInstructionWidget(this.step);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          step['step1']['text'],
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
          softWrap: true,
        ),
        const SizedBox(height: 20.0),
        Flexible(
          child: PopUpImage(step['step1']['image']),
        ),
        const SizedBox(height: 20.0),
        Text(
          step['step2']['text'],
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
          softWrap: true,
        ),
        const SizedBox(height: 20.0),
        Flexible(
          child: PopUpImage(step['step2']['image']),
        ),
      ],
    );
  }
}
