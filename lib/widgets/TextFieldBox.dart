import 'package:flutter/material.dart';

class TextFieldBox extends StatefulWidget {
  final String placeholder;
  const TextFieldBox({super.key, required this.placeholder});

  @override
  _Textfieldbox createState() => _Textfieldbox();
}
class _Textfieldbox extends State<TextFieldBox> {
  
  @override
  Widget build(BuildContext context){
    return  const Padding(
          padding: EdgeInsets.all(16.0),
          child: TextField(
            textAlign: TextAlign.start,
            decoration: InputDecoration(
              hintText: 'Password',
              border: OutlineInputBorder(),
            ),
          ),
        );
  }
}