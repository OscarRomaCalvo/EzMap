import 'package:flutter/material.dart';

import '../../models/BusInstruction.dart';
import '../../services/TextReader.dart';
import '../PopUpImage.dart';

class BusInstructionWidget extends StatefulWidget {
  final BusStep step;

  const BusInstructionWidget(this.step);

  @override
  State<BusInstructionWidget> createState() => _BusInstructionWidgetState();
}

class _BusInstructionWidgetState extends State<BusInstructionWidget> {
  @override
  void initState() {
    TextReader.speak(widget.step.text);
    super.initState();
  }

  Widget _showStepImage() {
    final stepImage = widget.step.image;
    return stepImage != null
        ? Flexible (child: PopUpImage(imageURL: stepImage))
        : const SizedBox();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              widget.step.text,
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
              softWrap: true,
            ),
            _showStepImage(),
          ],
        ),
      ),
    );
  }
}
