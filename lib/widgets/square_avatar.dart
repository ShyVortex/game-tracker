import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class SquareAvatar extends StatefulWidget {
  String imageUrl;
  final double size;
  final bool isNetworkImage;
  void Function(String value)? updateParentState;
   SquareAvatar({
    Key? key,
    required this.imageUrl,
    required this.size,
    required this.isNetworkImage,
    this.updateParentState
  }) : super(key: key);

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
    return GestureDetector(
      onTap: (){
          _pickImageFromGallery();
          widget.updateParentState!(widget.imageUrl);
      } ,
      child: Container(
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
    );
  }

  Future<void> _pickImageFromGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
       if (pickedFile != null) {
        final File imagesPath = File(pickedFile.path);
        widget.imageUrl = imagesPath.path;

    } else {

    }
    });

  }
}