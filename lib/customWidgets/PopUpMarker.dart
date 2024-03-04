import 'package:flutter/material.dart';

class PopUpMarker extends StatelessWidget {
  final String imageURL;

  PopUpMarker(this.imageURL);

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
        padding: EdgeInsets.all(4.0),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
        ),
        child: CircleAvatar(
          radius: 16,
          backgroundColor: Colors.white,
          backgroundImage: NetworkImage(imageURL,),
        ),
      ),
    );
  }
}
