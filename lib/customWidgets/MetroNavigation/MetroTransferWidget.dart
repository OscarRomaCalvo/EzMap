import 'package:flutter/material.dart';
import '../../services/TextReader.dart';
import '../CustomButton.dart';

class MetroTransferWidget extends StatefulWidget {
  final VoidCallback doTransfer;
  final String previousLine;
  final String previousDestination;
  final String nextLine;
  final String nextDirection;

  const MetroTransferWidget(this.doTransfer, this.previousLine,
      this.previousDestination, this.nextLine, this.nextDirection);

  @override
  _MetroTransferWidgetState createState() => _MetroTransferWidgetState();
}

class _MetroTransferWidgetState extends State<MetroTransferWidget> {
  @override
  void initState() {
    super.initState();
    TextReader.speak("Has llegado a tu parada. Pulsa el botón para iniciar el transbordo");
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Has llegado a",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
          softWrap: true,
        ),
        const SizedBox(height: 20),
        Text(
          widget.previousDestination,
          style: const TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
          softWrap: true,
        ),
        const SizedBox(height: 50),
        const Text(
          "Tienes que hacer transbordo a",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
          softWrap: true,
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(
              image: AssetImage("assets/images/metro/line${widget.nextLine}-metro.png"),
              height: 50,
            ),
            const SizedBox(
              width: 20,
            ),
            Text(
              "Línea ${widget.nextLine}",
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        RichText(
          textAlign: TextAlign.center,
          softWrap: true,
          text: TextSpan(
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            children: <TextSpan>[
              const TextSpan(
                text: "dirección: ",
              ),
              TextSpan(
                text: widget.nextDirection,
                style: const TextStyle(
                  fontSize: 30,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 50),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              const Text(
                "Pulsa para iniciar el transbordo",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
                softWrap: true,
              ),
              const SizedBox(height: 20),
              CustomButton("SIGUIENTE", widget.doTransfer, true),
            ],
          ),
        ),
      ],
    );
  }
}
