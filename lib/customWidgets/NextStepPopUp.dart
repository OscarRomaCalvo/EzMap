import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ez_maps/customWidgets/CustomButton.dart';

import '../pages/EndRoutePage.dart';
import '../services/TextReader.dart';
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

class FarFromPointWidget extends StatefulWidget {
  final String pointName;
  final String imageURL;

  FarFromPointWidget(this.pointName, this.imageURL);

  @override
  _FarFromPointWidgetState createState() => _FarFromPointWidgetState();
}

class _FarFromPointWidgetState extends State<FarFromPointWidget> {
  @override
  initState(){
    TextReader.speak("Estas lejos de ${widget.pointName}. Pulsa el botón y continua con el guiado");
  }
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
          CustomButton("VOLVER A LA RUTA", () {
            TextReader.stop();
            Navigator.of(context).pop();
          }, false)
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
  initState(){
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomButton("NO", () {
                TextReader.stop();
                Navigator.of(context).pop();
              }, false),
              CustomButton("SÍ", () {
                TextReader.stop();
                Navigator.of(context).pop();
                widget.continueRoute();
              }, true),
            ],
          ),
        ],
      ),
    );
  }
}
