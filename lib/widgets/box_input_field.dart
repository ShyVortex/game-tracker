import 'package:flutter/material.dart';

class BoxInputField extends StatelessWidget {
  final String text;

  const BoxInputField({
    super.key,
    required this.text
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 325,
      child: TextField(
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: text,
        ),
      ),
    );
  }
}