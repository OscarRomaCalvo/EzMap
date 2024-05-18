import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ez_maps/customWidgets/CustomButton.dart';

import '../pages/EndRoutePage.dart';
import '../services/TextReader.dart';
import 'ImageButton.dart';
import 'PopUpImage.dart';

class NextStepPopUp extends StatelessWidget {
  final String pointName;
  final String imageURL;
  final String pointType;
  final bool isFarFromPoint;
  final VoidCallback continueRoute;

  NextStepPopUp(this.pointName, this.imageURL, this.pointType,
      this.isFarFromPoint, this.continueRoute);

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
                    : NearFromPointWidget(
                        pointName, imageURL, pointType, continueRoute),
              ),
            );
          },
        );
      },
      child: Container(
        width: 60,
        height: 60,
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        child: const CircleAvatar(
          backgroundColor: Colors.transparent,
          radius: 60,
          backgroundImage:
              AssetImage("assets/images/ARASAACPictograms/nextButton.png"),
        ),
      ),
    );
  }
}

class FarFromPointWidget extends StatefulWidget {
  final String pointName;
  final String imageURL;

  FarFromPointWidget(this.pointName, this.imageURL);

  @override
  _FarFromPointWidgetState createState() => _FarFromPointWidgetState();
}

class _FarFromPointWidgetState extends State<FarFromPointWidget> {
  @override
  initState() {
    TextReader.speak(
        "Estas lejos de ${widget.pointName}. Pulsa el botón y continua con el guiado");
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "ESTÁS LEJOS DE ",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
            softWrap: true,
          ),
          const SizedBox(height: 20.0),
          Text(
            widget.pointName,
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
            child: PopUpImage(widget.imageURL),
          ),
          const SizedBox(height: 20.0),
          ImageButton(
              imagePath: "assets/images/ARASAACPictograms/backButton.png",
              size: 60,
              onPressed: () {
                TextReader.stop();
                Navigator.of(context).pop();
              },
          ),
        ],
      ),
    );
  }
}

class NearFromPointWidget extends StatefulWidget {
  final String pointName;
  final String imageURL;
  final String pointType;
  final VoidCallback continueRoute;

  NearFromPointWidget(
      this.pointName, this.imageURL, this.pointType, this.continueRoute);

  @override
  _NearFromPointWidgetState createState() => _NearFromPointWidgetState();
}

class _NearFromPointWidgetState extends State<NearFromPointWidget> {
  @override
  initState() {
    TextReader.speak("¿Has llegado a ${widget.pointName}?");
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "¿HAS LLEGADO?",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
            softWrap: true,
          ),
          const SizedBox(height: 20.0),
          Text(
            widget.pointName,
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
            child: PopUpImage(widget.imageURL),
          ),
          const SizedBox(height: 20.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ImageButton(
                imagePath: "assets/images/ARASAACPictograms/no.png",
                onPressed: () {
                  TextReader.stop();
                  Navigator.of(context).pop();
                },
                showBorder: true,
                size: 60,
              ),
              ImageButton(
                imagePath: "assets/images/ARASAACPictograms/yes.png",
                onPressed: () {
                  TextReader.stop();
                  Navigator.of(context).pop();
                  widget.continueRoute();
                },
                showBorder: true,
                size: 60,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
