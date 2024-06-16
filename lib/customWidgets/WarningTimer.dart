import 'dart:async';

import 'package:circular_timer/circular_timer.dart';
import 'package:ez_maps/customWidgets/ImageButton.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class WarningTimer extends StatefulWidget {
  final Duration duration;
  final double radius;
  final EdgeInsets padding;

  const WarningTimer(
      {super.key,
      required this.duration,
      this.radius = 27,
      this.padding = EdgeInsets.zero});

  @override
  State<WarningTimer> createState() => _WarningTimerState();
}

class _WarningTimerState extends State<WarningTimer> {
  bool timerOn = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      timerOn = true;
    });
    Timer(widget.duration, () {
      _showDialog();
      setState(() {
        timerOn = false;
      });
    });
  }

  void _showDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
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
                      "ESTÁS TARDANDO MUCHO",
                      style: TextStyle(
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
                        print("LLAMANDO...");
                      },
                      showBorder: true,
                      backgroundColor: const Color(0xFF4791DB),
                      size: 150,
                    ),
                    const SizedBox(height: 50),
                    ImageButton(
                      imagePath: "assets/images/ARASAACPictograms/no.png",
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      size: 60,
                      showBorder: true,
                    )
                  ],
                )),
          ),
        );
      },
    );
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
    return timerOn
        ? Padding(
            padding: widget.padding,
            child: CircularTimer(
              duration: widget.duration,
              radius: widget.radius,
              color: const Color(0xFF4791DB),
              outline: true,
              outlinedPadding: 0,

            ),
          )
        : ImageButton(
            imagePath: "assets/images/ARASAACPictograms/phone.png",
            onPressed: _showDialog,
            size: 60,
            showBorder: true,
            backgroundColor: const Color(0xFF4791DB),
          );
  }
}
