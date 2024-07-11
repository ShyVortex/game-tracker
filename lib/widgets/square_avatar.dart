import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class SquareAvatar extends StatefulWidget {
  String imageUrl;
  final double size;
  final bool isNetworkImage;
  void Function(String value)? updateParentState;
  final bool isTouchable;
   SquareAvatar({
    super.key,
    required this.imageUrl,
    required this.size,
    required this.isNetworkImage,
    required this.isTouchable,
    this.updateParentState
  });

  @override
  _SquareAvatarState createState() => _SquareAvatarState();
}

class _SquareAvatarState extends State<SquareAvatar> {


  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    
    return widget.isTouchable? GestureDetector(
      onTap: (){
          _pickImageFromGallery();
      } ,
      child:  Container(
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          shape: BoxShape.rectangle, 
          image: widget.isNetworkImage
              ? DecorationImage(
                  image: NetworkImage(widget.imageUrl),
                  fit: BoxFit.cover,
                )
              : DecorationImage(
                  image: FileImage(File(widget.imageUrl)),
                  fit: BoxFit.cover,
                ),
        ),
      ),
    ) : Container(
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          shape: BoxShape.rectangle, 
          image: widget.isNetworkImage
              ? DecorationImage(
                  image: NetworkImage(widget.imageUrl),
                  fit: BoxFit.cover,
                )
              : DecorationImage(
                  image: FileImage(File(widget.imageUrl)),
                  fit: BoxFit.cover,
                ),
        ),
      );
  }

  Future<void> _pickImageFromGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        widget.imageUrl = pickedFile.path;
      });
      // Notifica il widget padre con il nuovo URL dell'immagine
      if (widget.updateParentState != null) {
        widget.updateParentState!(widget.imageUrl);
      }
    } else {
      // Handle the case when no image is picked
    }
  }
   
  }