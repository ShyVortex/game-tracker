import 'dart:io';

import 'package:flutter/material.dart';

class ImagesList extends StatefulWidget {
  final List<String> imagesPaths;
  final VoidCallback? notifyParent;
  const ImagesList({super.key, required this.imagesPaths,this.notifyParent});

  @override
  _ImagesListState createState() => _ImagesListState();
}

class _ImagesListState extends State<ImagesList> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      width: 400,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: widget.imagesPaths.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onLongPress: () {
              setState(() {
                widget.imagesPaths.removeAt(index);
                if(widget.notifyParent!=null) {
                  widget.notifyParent!();
                }
              });
            },
            child: Container(
              width: 200, // Larghezza di ogni immagine
              margin: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: Colors.grey[200],
                image: DecorationImage(
                  image: FileImage(File(widget.imagesPaths[index])),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}