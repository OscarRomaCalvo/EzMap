import 'package:flutter/material.dart';

import '../../services/TextReader.dart';
import '../CustomButton.dart';
import '../ImageButton.dart';

class EnterMetroWidget extends StatefulWidget {
  final String originStation;
  final VoidCallback startMetroNavigation;

  EnterMetroWidget(this.originStation, this.startMetroNavigation);

  @override
  _EnterMetroWidgetState createState() => _EnterMetroWidgetState();
}

class _EnterMetroWidgetState extends State<EnterMetroWidget> {
  @override
  void initState() {
    super.initState();
    TextReader.speak("Entra a la estación de metro " + widget.originStation + ". Pulsa el botón cuando estés dentro.");
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "ENTRA EN LA ESTACIÓN DE METRO",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
              softWrap: true,
            ),
            const SizedBox(height: 20),
            const Image(
              image: AssetImage("assets/images/metro/metro-logo.png"),
              width: double.infinity,
            ),
            const SizedBox(height: 20),
            Text(
              widget.originStation,
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
              softWrap: true,
            ),
            const SizedBox(height: 40),
            ImageButton(imagePath: "assets/images/ARASAACPictograms/nextButton.png", onPressed: widget.startMetroNavigation, size: 100,),
          ],
        ),
      ),
    );
  }
}
