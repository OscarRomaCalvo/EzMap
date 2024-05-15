import 'package:flutter/material.dart';
import '../../services/TextReader.dart';
import '../CustomButton.dart';

class MetroEndWidget extends StatefulWidget {
  final String previousDestination;
  final VoidCallback continueRoute;

  MetroEndWidget(this.previousDestination, this.continueRoute);

  @override
  _MetroEndWidgetState createState() => _MetroEndWidgetState();
}

class _MetroEndWidgetState extends State<MetroEndWidget> {
  @override
  void initState() {
    super.initState();
    TextReader.speak("Sal de la estación. Pulsa el botón cuando estés fuera de la estación.");
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Has llegado a",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
          softWrap: true,
        ),
        const SizedBox(height: 20),
        Text(
          widget.previousDestination,
          style: const TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
          softWrap: true,
        ),
        const SizedBox(height: 50),
        const Text(
          "Sal de la estación",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
          softWrap: true,
        ),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              const Text(
                "Pulsa al salir de la estación",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
                softWrap: true,
              ),
              const SizedBox(height: 20),
              CustomButton("SIGUIENTE", widget.continueRoute, true),
            ],
          ),
        ),
      ],
    );
  }
}
