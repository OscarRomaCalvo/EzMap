import 'package:flutter/material.dart';

import '../CustomButton.dart';

class InitStepWidget extends StatelessWidget {
  final step;
  final VoidCallback startOnMetroNavigation;

  InitStepWidget(this.step, this.startOnMetroNavigation);



  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Utiliza",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
          softWrap: true,
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(
              image: AssetImage("assets/images/line${step["line"]}-metro.png"),
              height: 50,
            ),
            SizedBox(
              width: 20,
            ),
            Text(
              "Línea ${step["line"]}",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),RichText(
          textAlign: TextAlign.center,
          softWrap: true,
          text: TextSpan(
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            children: <TextSpan>[
              const TextSpan(
                text: "dirección: ",
              ),
              TextSpan(
                text: step["direction"],
                style: const TextStyle(
                  fontSize: 30,
                ),
              ),
            ],
          ),
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
                "Pulsa cuando estés en el metro",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
                softWrap: true,
              ),
              const SizedBox(height: 20),
              CustomButton("SIGUIENTE", startOnMetroNavigation, true),
            ],
          )
        )
      ],
    );
  }
}


