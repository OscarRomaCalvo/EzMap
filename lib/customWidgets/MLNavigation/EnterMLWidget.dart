import 'package:flutter/material.dart';

import '../CustomButton.dart';

class EnterMLWidget extends StatelessWidget {
  final String originStation;
  final VoidCallback startMLNavigation;

  EnterMLWidget(this.originStation, this.startMLNavigation);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Entra a la estación de metro ligero",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
          softWrap: true,
        ),
        const SizedBox(height: 20),
        const Image(
          image: AssetImage("assets/images/ml-logo.png"),
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
        CustomButton("SIGUIENTE", startMLNavigation, true),
      ],
    );
  }
}
