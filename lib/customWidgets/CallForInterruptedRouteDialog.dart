import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../services/TextReader.dart';
import 'ImageButton.dart';

class CallForInterruptedRouteDialog extends StatefulWidget {
  final String route_name;

  const CallForInterruptedRouteDialog({super.key, required this.route_name});

  @override
  State<CallForInterruptedRouteDialog> createState() =>
      _CallForInterruptedRouteDialogState();
}

class _CallForInterruptedRouteDialogState
    extends State<CallForInterruptedRouteDialog> {
  @override
  void initState() {
    super.initState();
    TextReader.speak(
        "Se ha interrumpido tu ruta. Pulsa el botón si quieres llamar para recibir ayuda.");
  }

  void _launchPhoneApp() async {
    final Uri telUri = Uri(scheme: 'tel');
    try {
      launchUrl(telUri);
    } catch (e) {
      Navigator.of(context).pop();
      const snackBar = SnackBar(
        content: Text(
          'ERROR: NO SE PUEDE LLAMAR',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        duration: Duration(seconds: 20),
        backgroundColor: const Color(0xFFD32F2F),
        showCloseIcon: true,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "SE HA INTERRUMPIDO TU RUTA",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                  softWrap: true,
                ),
                Text(
                  widget.route_name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                  softWrap: true,
                ),
                const SizedBox(height: 50),
                const Text(
                  "¿NECESITAS AYUDA?",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                  softWrap: true,
                ),
                const SizedBox(height: 20),
                ImageButton(
                  imagePath: "assets/images/ARASAACPictograms/phone.png",
                  onPressed: () async {
                    _launchPhoneApp();
                  },
                  showBorder: true,
                  backgroundColor: const Color(0xFF4791DB),
                  size: 150,
                ),
                const SizedBox(height: 50),
                ImageButton(
                  imagePath: "assets/images/ARASAACPictograms/no.png",
                  onPressed: () {
                    TextReader.stop();
                    Navigator.of(context).pop();
                  },
                  size: 60,
                  showBorder: true,
                )
              ],
            )),
      ),
    );

  }
}
