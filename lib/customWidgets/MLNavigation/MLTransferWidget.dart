import 'package:ez_maps/customWidgets/ImageButton.dart';
import 'package:flutter/material.dart';
import '../../services/TextReader.dart';

class MLTransferWidget extends StatefulWidget {
  final VoidCallback doTransfer;
  final String destination;


  const MLTransferWidget(this.doTransfer,
      this.destination);

  @override
  _MLTransferWidgetState createState() => _MLTransferWidgetState();
}

class _MLTransferWidgetState extends State<MLTransferWidget> {
  @override
  void initState() {
    super.initState();
    TextReader.speak("Has llegado a tu parada. Pulsa el botón para iniciar el transbordo.");
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(10),
      ),
      width: double.infinity,
      height: double.infinity,
      child: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "HAS LLEGADO A:",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
              softWrap: true,
            ),
            const SizedBox(height: 20),
            Text(
              widget.destination,
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
              softWrap: true,
            ),
            const SizedBox(height: 50),
            const Text(
              "PULSA EL BOTÓN PARA INICIAR EL TRANSBORDO",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
              softWrap: true,
            ),
            const SizedBox(height: 20,),
            ImageButton(imagePath: "assets/images/ARASAACPictograms/nextButton.png", onPressed: widget.doTransfer, size: 100),
          ],
        )
      ),
    );
  }
}
