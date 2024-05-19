import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ez_maps/customWidgets/PopUpImage.dart';

import '../services/TextReader.dart';

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

class OneInstructionWidget extends StatefulWidget {
  final step;

  OneInstructionWidget(this.step);

  @override
  _OneInstructionWidgetState createState() => _OneInstructionWidgetState();
}

class _OneInstructionWidgetState extends State<OneInstructionWidget> {
  @override
  void initState() {
    super.initState();
    TextReader.speak(widget.step['step1']['text']);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          widget.step['step1']['text'],
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
          softWrap: true,
        ),
        const SizedBox(height: 20.0),
        Flexible(child: PopUpImage(imageURL:widget.step['step1']['image'])),
      ],
    );
  }
}

class TwoInstructionWidget extends StatefulWidget {
  final step;

  TwoInstructionWidget(this.step);

  @override
  _TwoInstructionWidgetState createState() => _TwoInstructionWidgetState();
}

class _TwoInstructionWidgetState extends State<TwoInstructionWidget> {
  @override
  void initState() {
    super.initState();
    TextReader.speak(widget.step['step1']['text'] + ' ' + widget.step['step2']['text']);
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          widget.step['step1']['text'],
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
          softWrap: true,
        ),
        const SizedBox(height: 20.0),
        Flexible(
          child: PopUpImage(imageURL:widget.step['step1']['image']),
        ),
        const SizedBox(height: 20.0),
        Text(
          widget.step['step2']['text'],
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
          softWrap: true,
        ),
        const SizedBox(height: 20.0),
        Flexible(
          child: PopUpImage(imageURL:widget.step['step2']['image']),
        ),
      ],
    );
  }
}

