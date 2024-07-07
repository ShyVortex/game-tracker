import 'dart:io';

import 'package:flutter/material.dart';

class SquareAvatar extends StatelessWidget {
  final String imageUrl;
  final double size;
  final bool isNetworkImage;
  
  const SquareAvatar({super.key, required this.imageUrl, required this.size, required this.isNetworkImage});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.rectangle, // Makes the avatar square
        image: isNetworkImage? DecorationImage(
          image: NetworkImage(imageUrl),
          fit: BoxFit.cover,
        ): DecorationImage(
              image: FileImage(File(imageUrl)),
              fit: BoxFit.cover,
            ),
      ),
    );
  }
}