import 'package:ez_maps/customWidgets/ImageButton.dart';
import 'package:ez_maps/customWidgets/PopUpImage.dart';
import 'package:flutter/material.dart';
import '../../services/TextReader.dart';
import '../CustomButton.dart';

class InitStepWidget extends StatefulWidget {
  final step;
  final VoidCallback startOnMLNavigation;

  InitStepWidget(this.step, this.startOnMLNavigation);

  @override
  _InitStepWidgetState createState() => _InitStepWidgetState();
}

class _InitStepWidgetState extends State<InitStepWidget> {
  void initState() {
    super.initState();
    TextReader.speak("Utiliza la línea " +
        widget.step["line"] +
        "en dirección " +
        widget.step["direction"] +
        ". Pulsa el botón cuando estés en el metro ligero.");
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(10),
            ),
            width: double.infinity,
            height: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "UTILIZA",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                    softWrap: true,
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image(
                        image: AssetImage(
                            "assets/images/metroLigero/line${widget.step["line"]}-ml.png"),
                        height: 50,
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Text(
                        "Línea ${widget.step["line"]}",
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
                          text: "DIRECCIÓN: ",
                        ),
                        TextSpan(
                          text: widget.step["direction"],
                          style: const TextStyle(
                            fontSize: 30,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 25),
        Expanded(
          flex:2,
          child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(10),
              ),
              width: double.infinity,
              height: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: PopUpImage(
                  imageURL:
                      "https://static.eldiario.es/clip/9e7db40a-bc86-4b51-afa8-09ce8fef4168_source-aspect-ratio_default_0.jpg",
                  imageFit: BoxFit.fitHeight,
                ),
              )),
        ),
        const SizedBox(height: 25),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ImageButton(
                imagePath: "assets/images/ARASAACPictograms/nextButton.png",
                onPressed: widget.startOnMLNavigation,
                size: 60)
          ],
        ),
      ],
    );
  }
}
