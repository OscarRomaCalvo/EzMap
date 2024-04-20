import 'package:ez_maps/customWidgets/PopUpImage.dart';
import 'package:ez_maps/services/AuthService.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';

import '../models/ShortRoute.dart';
import '../pages/NavigationPage.dart';
import 'CustomButton.dart';

class InitRoutePopUp extends StatelessWidget {
  final ShortRoute shortRoute;
  LocationData iniLocation;

  InitRoutePopUp(
      {super.key, required this.shortRoute, required this.iniLocation});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Ir de",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Text(
              shortRoute.origin.name,
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            Flexible(
              child: PopUpImage(shortRoute.origin.pointImage),
            ),
            const SizedBox(
              height: 15,
            ),
            const Text(
              "a",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Text(
              shortRoute.destination.name,
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            Flexible(
              child: PopUpImage(shortRoute.destination.pointImage),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomButton("SALIR", () {
                  Navigator.of(context).pop();
                  var a = AuthService();
                  a.signOut();
                }, false),
                CustomButton("EMPEZAR", () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => NavigationPage(
                            routeName: shortRoute.routeName,
                            iniLocation: iniLocation)),
                  );
                }, true),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
