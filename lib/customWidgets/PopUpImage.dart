import 'package:flutter/material.dart';

class PopUpImage extends StatelessWidget {
  final String imageURL;
  final BoxFit imageFit;
  PopUpImage({required this.imageURL, this.imageFit = BoxFit.cover});

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
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image(
          image: NetworkImage(imageURL),
          fit: imageFit,
          width: double.infinity,
        ),
      ),
    );
  }
}
