import 'package:flutter/material.dart';

class PopUpMarker extends StatelessWidget {
  final String imageURL;
  final double size;

  PopUpMarker({required this.imageURL, this.size=16});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return Dialog(
              child: Image.network(
                imageURL,
              ),
            );
          },
        );
      },
      child: Container(
        padding: const EdgeInsets.all(4.0),
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
        ),
        child: CircleAvatar(
          radius: size,
          backgroundColor: Colors.white,
          backgroundImage: NetworkImage(imageURL),
        ),
      ),
    );
  }
}
