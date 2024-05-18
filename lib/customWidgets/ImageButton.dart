import 'package:flutter/material.dart';

class ImageButton extends StatelessWidget {
  final String imagePath;
  final VoidCallback onPressed;
  final double size;
  final Color backgroundColor;
  final bool showBorder;

  ImageButton({required this.imagePath, required this.onPressed, this.size=30, this.backgroundColor=Colors.white, this.showBorder=false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: size,
        height: size,
        padding: showBorder ? EdgeInsets.all(3) : EdgeInsets.zero,
        decoration: BoxDecoration(
          color: backgroundColor,
          shape: BoxShape.circle,
          border: showBorder
              ? Border.all(
            color: Colors.black,
            width: 3,
          )
              : null,
        ),
        child: CircleAvatar(
          backgroundColor: Colors.transparent,
          radius: showBorder ? size - 3 : size,
          backgroundImage: AssetImage(imagePath),
        ),
      ),
    );
  }
}