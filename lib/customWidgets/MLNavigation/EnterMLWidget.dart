import 'package:ez_maps/customWidgets/ImageButton.dart';
import 'package:flutter/material.dart';
import '../../services/TextReader.dart';
import '../CustomButton.dart';

class EnterMLWidget extends StatefulWidget {
  final String originStation;
  final VoidCallback startMLNavigation;

  EnterMLWidget(this.originStation, this.startMLNavigation);

  @override
  _EnterMLWidgetState createState() => _EnterMLWidgetState();
}

class _EnterMLWidgetState extends State<EnterMLWidget> {
  @override
  void initState() {
    super.initState();
    TextReader.speak("Entra a la estación de metro ligero " + widget.originStation +". Pulsa el botón cuando estés dentro.");
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "ENTRA A LA ESTACIÓN DE METRO LIGERO",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
              softWrap: true,
            ),
            const SizedBox(height: 20),
            const Image(
              image: AssetImage("assets/images/metroLigero/ml-logo.png"),
              width: double.infinity,
            ),
            const SizedBox(height: 20),
            Text(
              widget.originStation,
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
              softWrap: true,
            ),
            const SizedBox(height: 40),
            ImageButton(imagePath: "assets/images/ARASAACPictograms/nextButton.png", onPressed: widget.startMLNavigation, size: 100,),
          ],
        ),
      ),
    );
  }
}
