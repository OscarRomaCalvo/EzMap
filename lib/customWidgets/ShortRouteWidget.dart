import 'dart:ffi';

import 'package:flutter/material.dart';

import '../models/ShortRoute.dart';
import 'InitRoutePopUp.dart';
import 'PopUpMarker.dart';

class ShortRouteWidget extends StatelessWidget {
  ShortRoute shortRoute;

  ShortRouteWidget(this.shortRoute);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(10),
      ),
      child: GestureDetector(
        onTap:() {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return Dialog(
                child: InitRoutePopUp(shortRoute: shortRoute,),
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
                    PopUpMarker(imageURL: shortRoute.origin.pointImage, size:25),
                    Text(
                      shortRoute.origin.name,
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ]),
                ),
                const Icon(Icons.arrow_right_alt, color: Color(0xFF4791DB), size: 70),
                Expanded(
                  flex: 1,
                  child: Column(children: [
                    PopUpMarker(imageURL: shortRoute.destination.pointImage, size:25),
                    Text(
                      shortRoute.destination.name,
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ]),
                ),
              ],
            )),
      ),
    );
  }
}
