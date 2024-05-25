import 'package:flutter/material.dart';

class PopUpImage extends StatelessWidget {
  final String imageURL;
  final BoxFit imageFit;
  final String placeholderAsset;

  PopUpImage({
    required this.imageURL,
    this.imageFit = BoxFit.cover,
    this.placeholderAsset = 'assets/loading_placeholder.png',
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return Dialog(
              child: FadeInImage(
                placeholder: AssetImage("assets/images/placehoderImage.png"),
                image: NetworkImage(imageURL),
                fit: BoxFit.contain,
              ),
            );
          },
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: FadeInImage(
          placeholder: AssetImage("assets/images/placehoderImage.png"),
          image: NetworkImage(imageURL),
          fit: imageFit,
          width: double.infinity,
        ),
      ),
    );
  }
}
