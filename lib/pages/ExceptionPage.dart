import 'package:ez_maps/customWidgets/ImageButton.dart';
import 'package:ez_maps/pages/RouteSelectionPage.dart';
import 'package:ez_maps/services/TextReader.dart';
import 'package:flutter/material.dart';
import 'package:ez_maps/customWidgets/PopUpImage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ExceptionPage extends StatefulWidget {
  Exception exception;
  ExceptionPage(this.exception);

  @override
  _ExceptionPageState createState() =>
      _ExceptionPageState();
}

class _ExceptionPageState extends State<ExceptionPage> {
  @override
  void initState() {
    super.initState();
    TextReader.speak(
        "Se ha producido un error. Pulsa el botón para volver a la pantalla de selección de rutas");
    _removeStartedRoute();
  }

  void _removeStartedRoute() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('startedRoute');
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      "SE HA PRODUCIDO UN ERROR",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                      softWrap: true,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    const Text(
                      "ERROR:",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFD32F2F),
                      ),
                      textAlign: TextAlign.center,
                      softWrap: true,
                    ),
                    Container(
                      height: 100,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEE1E1),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "${widget.exception}",
                            style: const TextStyle(
                              fontSize: 16.0,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    ImageButton(
                      imagePath:
                          "assets/images/ARASAACPictograms/backButton.png",
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
