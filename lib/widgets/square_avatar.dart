import 'package:flutter/material.dart';

class SquareAvatar extends StatelessWidget {
  final String imageUrl;
  final double size;

  const SquareAvatar({required this.imageUrl, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.rectangle, // Makes the avatar square
        image: DecorationImage(
          image: NetworkImage(imageUrl),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}