import 'package:flutter/material.dart';
import '../../services/TextReader.dart';
import '../CustomButton.dart';
import '../ImageButton.dart';

class MetroEndWidget extends StatefulWidget {
  final String destination;
  final VoidCallback continueRoute;

  MetroEndWidget(this.destination, this.continueRoute);

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
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(10),
      ),
      width: double.infinity,
      height: double.infinity,
      child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "HAS LLEGADO A:",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
                softWrap: true,
              ),
              const SizedBox(height: 20),
              Text(
                widget.destination,
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
                softWrap: true,
              ),
              const SizedBox(height: 50),
              const Text(
                "SAL DE LA ESTACIÓN",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
                softWrap: true,
              ),
              const SizedBox(height: 20,),
              ImageButton(imagePath: "assets/images/ARASAACPictograms/nextButton.png", onPressed: widget.continueRoute, size: 100),
            ],
          )
      ),
    );
  }
}
