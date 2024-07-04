import 'package:flutter/material.dart';
import 'package:game_tracker/pages/library/location_page.dart';

class LocationField extends StatefulWidget {
  const LocationField({super.key});

  @override
  State<LocationField> createState() => LocationFieldState();
}

class LocationFieldState extends State<LocationField> {

  void onButtonPress() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const LocationPage())
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      child: Row(
        children: <Widget>[
          const Expanded(
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Dove hai completato il gioco?',
                border: OutlineInputBorder(),
              ),
              readOnly: true,
            ),
          ),
          const SizedBox(width: 10),
          IconButton(
            icon: const Icon(Icons.location_on),
            onPressed: onButtonPress,
          ),
        ],
      ),
    );
  }
}