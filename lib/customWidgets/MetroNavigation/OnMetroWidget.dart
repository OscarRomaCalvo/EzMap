import 'package:flutter/material.dart';

import '../../services/TextReader.dart';
import '../CustomButton.dart';
import '../ImageButton.dart';

class OnMetroWidget extends StatefulWidget {
  int stops;
  final String stopName;
  final VoidCallback continueMetroNavigation;

  OnMetroWidget(this.stops, this.stopName, this.continueMetroNavigation);

  @override
  State<OnMetroWidget> createState() => _OnMetroWidgetState();
}

class _OnMetroWidgetState extends State<OnMetroWidget> {
  @override
  void initState() {
    super.initState();
    if (widget.stops > 1) {
      TextReader.speak("Tu parada es " +
          widget.stopName +
          ". Pulsa el botón en cada parada.");
    }
  }

  void _reduceStops() {
    if (widget.stops > 1) {
      setState(() {
        widget.stops--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(10),
            ),
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "TU PARADA:",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                    softWrap: true,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    widget.stopName,
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                    softWrap: true,
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 25.0,
        ),
        (widget.stops > 1)
            ? MultipleStops(widget.stops, _reduceStops)
            : LastStop(widget.continueMetroNavigation),
      ],
    );
  }
}

class LastStop extends StatefulWidget {
  final VoidCallback continueMetroNavigation;

  LastStop(this.continueMetroNavigation);

  @override
  _LastStopState createState() => _LastStopState();
}

class _LastStopState extends State<LastStop> {
  @override
  void initState() {
    super.initState();
    TextReader.speak("Baja en la siguiente parada.");
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(10),
        ),
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "BAJA EN LA SIGUIENTE PARADA",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
                textAlign: TextAlign.center,
                softWrap: true,
              ),
              const SizedBox(height: 20),
              const Text(
                "PULSA AL BAJAR:",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
                softWrap: true,
              ),
              ImageButton(
                imagePath: "assets/images/ARASAACPictograms/nextButton.png",
                onPressed: widget.continueMetroNavigation,
                size: 60,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MultipleStops extends StatelessWidget {
  final int stops;
  final VoidCallback reduceStops;

  MultipleStops(this.stops, this.reduceStops);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(10),
        ),
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "QUEDAN",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
                softWrap: true,
              ),
              const SizedBox(height: 10),
              RichText(
                textAlign: TextAlign.center,
                softWrap: true,
                text: TextSpan(
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: "$stops",
                      style: const TextStyle(color: Colors.red),
                    ),
                    const TextSpan(
                      text: ' paradas',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "PULSA EN CADA PARADA:",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
                softWrap: true,
              ),
              ImageButton(
                imagePath: "assets/images/ARASAACPictograms/stopButton.png",
                onPressed: reduceStops,
                size: 60,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
