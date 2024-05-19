import 'package:ez_maps/customWidgets/ImageButton.dart';
import 'package:ez_maps/pages/RouteSelectionPage.dart';
import 'package:ez_maps/services/TextReader.dart';
import 'package:flutter/material.dart';
import 'package:ez_maps/customWidgets/PopUpImage.dart';

class EndRoutePage extends StatefulWidget {
  final String destinationImage;
  final String destinationName;

  EndRoutePage(this.destinationImage, this.destinationName);

  @override
  _EndRoutePageState createState() => _EndRoutePageState();
}

class _EndRoutePageState extends State<EndRoutePage> {
  @override
  void initState() {
    super.initState();
    TextReader.speak("Has llegado a tu destino: " + widget.destinationName);
  }

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
                      "HAS LLEGADO",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                      softWrap: true,
                    ),
                    const SizedBox(height: 20),
                    PopUpImage(imageURL:widget.destinationImage),
                    const SizedBox(height: 20),
                    Text(
                      widget.destinationName,
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                      softWrap: true,
                    ),
                    const SizedBox(height: 20),
                    ImageButton(
                      imagePath:
                          "assets/images/ARASAACPictograms/nextButton.png",
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RouteSelectionPage()),
                        );
                      },
                      size: 100,
                    ),
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
