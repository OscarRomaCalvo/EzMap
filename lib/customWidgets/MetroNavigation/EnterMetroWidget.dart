import 'package:flutter/material.dart';

import '../../services/TextReader.dart';
import '../CustomButton.dart';

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
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Entra a la estación de metro",
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
        const SizedBox(height: 20),
        CustomButton("SIGUIENTE", widget.startMetroNavigation, true),
      ],
    );
  }
}
