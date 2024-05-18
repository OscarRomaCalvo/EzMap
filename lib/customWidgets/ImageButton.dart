import 'package:flutter/material.dart';

class ImageButton extends StatelessWidget {
  final String imagePath;
  final VoidCallback onPressed;
  final double size;
  final Color backgroundColor;

  ImageButton({required this.imagePath, required this.onPressed, this.size=30, this.backgroundColor=Colors.white});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: size,
        height: size,
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          color: backgroundColor,
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.black,
            width: 3,
          ),
        ),
        child: CircleAvatar(
          backgroundColor: Colors.transparent,
          radius: size - 4,
          backgroundImage: AssetImage(imagePath),
        ),
      ),
    );
  }
}