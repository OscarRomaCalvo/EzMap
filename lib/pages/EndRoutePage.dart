import 'package:ez_maps/pages/RouteSelectionPage.dart';
import 'package:flutter/material.dart';
import 'package:ez_maps/customWidgets/CustomButton.dart';
import 'package:ez_maps/customWidgets/PopUpImage.dart';

import '../models/RoutePoint.dart';

class EndRoutePage extends StatelessWidget {
  final String destinationImage;
  final String destinationName;

  EndRoutePage(this.destinationImage, this.destinationName);

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
                    PopUpImage(destinationImage),
                    const SizedBox(height: 20),
                    Text(
                      destinationName,
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                      softWrap: true,
                    ),
                    const SizedBox(height: 20),
                    CustomButton("TERMINAR", () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RouteSelectionPage()),
                      );
                    }, true)
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
