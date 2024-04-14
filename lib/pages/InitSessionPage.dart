import 'package:ez_maps/customWidgets/CustomSignInGoogleButton.dart';
import 'package:flutter/material.dart';

class InitSessionPage extends StatefulWidget {
  @override
  _InitSessionPageState createState() => _InitSessionPageState();
}

class _InitSessionPageState extends State<InitSessionPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/fondo-loginPage.png"),
            fit: BoxFit.cover,

          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 140.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Image(
                  image: AssetImage("assets/images/EZMaps-logo.png"),
                  height: 150.0,
                ),
                CustomSignInGoogleButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
