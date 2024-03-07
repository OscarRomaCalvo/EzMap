import 'package:flutter/material.dart';

import '../CustomButton.dart';

class EnterMetroWidget extends StatelessWidget {
  final String originStation;
  final VoidCallback startMetroNavigation;

  EnterMetroWidget(this.originStation, this.startMetroNavigation);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Entra al metro",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
          softWrap: true,
        ),
        const SizedBox(height: 20),
        const Image(
          image: AssetImage("assets/images/metro_logo.png"),
          width: double.infinity,
        ),
        const SizedBox(height: 20),
        Text(
          originStation,
          style: const TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
          softWrap: true,
        ),
        const SizedBox(height: 20),
        CustomButton("SIGUIENTE", startMetroNavigation, true),
      ],
    );
  }
}
