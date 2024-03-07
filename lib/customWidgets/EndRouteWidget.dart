import 'package:flutter/material.dart';
import 'package:prueba_ezmaps_estatica/customWidgets/CustomButton.dart';
import 'package:prueba_ezmaps_estatica/customWidgets/PopUpImage.dart';

class EndRouteWidget extends StatelessWidget {
  final destination;

  EndRouteWidget(this.destination);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Center(
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Has llegado",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                      softWrap: true,
                    ),
                    const SizedBox(height: 20),
                    PopUpImage(destination["image"]),
                    const SizedBox(height: 20),
                    Text(
                      destination["pointName"],
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                      softWrap: true,
                    ),
                    const SizedBox(height: 20),
                    CustomButton("TERMINAR", () {}, true)
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );

  }
}
