import 'package:ez_maps/customWidgets/ImageButton.dart';
import 'package:ez_maps/customWidgets/PopUpImage.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../models/ShortRoute.dart';
import '../pages/NavigationPage.dart';
import 'CustomButton.dart';

class InitRoutePopUp extends StatelessWidget {
  final ShortRoute shortRoute;
  Position iniLocation;

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
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "IR DE",
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
              "A",
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
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ImageButton(
                  imagePath: "assets/images/ARASAACPictograms/no.png",
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  showBorder: true,
                  size: 60,
                ),
                ImageButton(
                  imagePath: "assets/images/ARASAACPictograms/yes.png",
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => NavigationPage(
                              routeName: shortRoute.routeName,
                              iniLocation: iniLocation)),
                    );
                  },
                  showBorder: true,
                  size: 60,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
