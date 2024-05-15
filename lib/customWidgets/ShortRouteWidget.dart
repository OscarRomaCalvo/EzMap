import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../models/ShortRoute.dart';
import 'InitRoutePopUp.dart';
import 'PopUpMarker.dart';

class ShortRouteWidget extends StatelessWidget {
  final ShortRoute shortRoute;
  Position iniLocation;

  ShortRouteWidget(
      {super.key, required this.shortRoute, required this.iniLocation});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(10),
      ),
      child: GestureDetector(
        onTap: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return Dialog(
                child: InitRoutePopUp(
                  shortRoute: shortRoute,
                  iniLocation: iniLocation,
                ),
              );
            },
          );
        },
        child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Column(children: [
                    PopUpMarker(
                        imageURL: shortRoute.origin.pointImage, size: 25),
                    Text(
                      shortRoute.origin.name,
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                      softWrap: true,
                    )
                  ]),
                ),
                const Icon(Icons.arrow_right_alt,
                    color: Color(0xFF4791DB), size: 70),
                Expanded(
                  flex: 1,
                  child: Column(children: [
                    PopUpMarker(
                        imageURL: shortRoute.destination.pointImage, size: 25),
                    Text(
                      shortRoute.destination.name,
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                      softWrap: true,
                    )
                  ]),
                ),
              ],
            )),
      ),
    );
  }
}
