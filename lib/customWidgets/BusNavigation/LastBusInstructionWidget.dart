import 'package:ez_maps/services/TextReader.dart';
import 'package:flutter/material.dart';

import '../ImageButton.dart';

class LastBusInstructionWidget extends StatefulWidget {
  final VoidCallback continueRoute;

  const LastBusInstructionWidget(this.continueRoute);

  @override
  State<LastBusInstructionWidget> createState() => _LastBusInstructionWidgetState();
}

class _LastBusInstructionWidgetState extends State<LastBusInstructionWidget> {

  @override
  void initState() {
    TextReader.speak("BAJA EN LA SIGUIENTE PARADA");
    super.initState();
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
            const Text(
              "BAJA EN LA SIGUIENTE PARADA",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
              softWrap: true,
            ),
            ImageButton(
              imagePath: "assets/images/ARASAACPictograms/nextButton.png",
              onPressed: () {
                widget.continueRoute();
              },
              size: 100,
            ),
          ],
        ),
      ),
    );
  }
}
