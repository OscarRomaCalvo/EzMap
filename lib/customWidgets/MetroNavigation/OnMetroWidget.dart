import 'package:flutter/material.dart';

import '../../services/TextReader.dart';
import '../CustomButton.dart';

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
      TextReader.speak("Tu parada es " + widget.stopName + ". Pulsa el botón en cada parada.");
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
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Tu parada",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
          softWrap: true,
        ),
        const SizedBox(height: 20),
        Text(
          widget.stopName,
          style: const TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
          softWrap: true,
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
    return Column(
      children: [
        Container(
          height: 200,
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "BAJA EN LA SIGUIENTE PARADA",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
                textAlign: TextAlign.center,
                softWrap: true,
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              const Text(
                "Pulsa cuando haya una parada",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
                softWrap: true,
              ),
              SizedBox(height: 20),
              CustomButton("SIGUIENTE", widget.continueMetroNavigation, true),
            ],
          ),
        )
      ],
    );
  }
}

class MultipleStops extends StatelessWidget {
  final int stops;
  final VoidCallback reduceStops;

  MultipleStops(this.stops, this.reduceStops);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 200,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Quedan",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
                softWrap: true,
              ),
              SizedBox(height: 20),
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
                      text: "${stops}",
                      style: const TextStyle(color: Colors.red),
                    ),
                    const TextSpan(
                      text: ' paradas',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              const Text(
                "Pulsa cuando estés en el metro",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
                softWrap: true,
              ),
              SizedBox(height: 20),
              CustomButton("PARADA", reduceStops, true),
            ],
          ),
        )
      ],
    );
  }
}
