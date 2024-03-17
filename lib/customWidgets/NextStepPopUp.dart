import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ez_maps/customWidgets/CustomButton.dart';

import 'PopUpImage.dart';

class NextStepPopUp extends StatelessWidget {
  final String pointName;
  final String imageURL;
  final bool isFarFromPoint;
  final VoidCallback continueRoute;

  NextStepPopUp(this.pointName, this.imageURL, this.isFarFromPoint,
      this.continueRoute);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return Dialog(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: isFarFromPoint
                    ? FarFromPointWidget(pointName, imageURL)
                    : NearFromPointWidget(pointName, imageURL, continueRoute),
              ),
            );
          },
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: const Color(0xFF4791DB),
        ),
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            'CONTINUAR',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

class FarFromPointWidget extends StatelessWidget {
  final String pointName;
  final String imageURL;

  FarFromPointWidget(this.pointName, this.imageURL);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Estás lejos de ",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
            softWrap: true,
          ),
          const SizedBox(height: 20.0),
          Text(
            pointName,
            style: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
            softWrap: true,
          ),
          const SizedBox(height: 20.0),
          SizedBox(
            height: 300,
            child: PopUpImage(imageURL),
          ),
          const SizedBox(height: 20.0),
          CustomButton("VOLVER", () {
            Navigator.of(context).pop();
          }, false)
        ],
      ),
    );
  }
}

class NearFromPointWidget extends StatelessWidget {
  final String pointName;
  final String imageURL;
  final VoidCallback continueRoute;

  NearFromPointWidget(this.pointName, this.imageURL, this.continueRoute);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "¿Has llegado?",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
            softWrap: true,
          ),
          const SizedBox(height: 20.0),
          Text(
            pointName,
            style: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
            softWrap: true,
          ),
          const SizedBox(height: 20.0),
          SizedBox(
            height: 300,
            child: PopUpImage(imageURL),
          ),
          const SizedBox(height: 20.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomButton("SALIR", () {
                Navigator.of(context).pop();
              }, false),
              CustomButton("CONTINUAR", () {
                Navigator.of(context).pop();
                continueRoute();
              },
                  true),
            ],
          ),
        ],
      ),
    );
  }
}

