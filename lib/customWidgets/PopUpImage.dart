import 'package:flutter/material.dart';

class PopUpImage extends StatelessWidget {
  final String imageURL;
  final BoxFit imageFit;
  final String placeholderAsset;

  PopUpImage({
    required this.imageURL,
    this.imageFit = BoxFit.cover,
    this.placeholderAsset = 'assets/images/placehoderImage.png',
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return Dialog(
              child: _buildImage(),
            );
          },
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: _buildImage(),
      ),
    );
  }

  Widget _buildImage() {
    return Image.network(
      imageURL,
      fit: imageFit,
      width: double.infinity,
      errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
        return Image.asset(
          placeholderAsset,
          fit: imageFit,
          width: double.infinity,
        );
      },
      loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
        if (loadingProgress == null) {
          return child;
        } else {
          return Image.asset(
            placeholderAsset,
            fit: imageFit,
            width: double.infinity,
          );
        }
      },
    );
  }
}
