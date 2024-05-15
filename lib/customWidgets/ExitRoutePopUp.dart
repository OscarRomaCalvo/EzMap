import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ez_maps/customWidgets/CustomButton.dart';

import '../models/RoutePoint.dart';
import '../pages/RouteSelectionPage.dart';
import '../services/TextReader.dart';
import 'PopUpImage.dart';

class ExitRoutePopUp extends StatefulWidget {
  final RouteWaypoint destination;

  ExitRoutePopUp(this.destination);

  @override
  _ExitRoutePopUpState createState() => _ExitRoutePopUpState();
}

class _ExitRoutePopUpState extends State<ExitRoutePopUp> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            TextReader.speak("¿Quieres terminar la ruta con destino ${widget.destination.name}?");
            return Dialog(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "Cancelar ruta con destino ",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                        softWrap: true,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        widget.destination.name,
                        style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                        softWrap: true,
                      ),
                      const SizedBox(height: 20),
                      PopUpImage(widget.destination.pointImage),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomButton("SI", () {
                            TextReader.stop();
                            Navigator.pop(context);
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const RouteSelectionPage(),
                              ),
                            );
                          }, false),
                          CustomButton("NO", () {
                            TextReader.stop();
                            Navigator.of(context).pop();
                          }, true),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: const Color(0xFFD32F2F),
        ),
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            'TERMINAR',
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
