import 'package:flutter/material.dart';
import 'package:game_tracker/pages/library/map_page.dart';

class LocationField extends StatefulWidget {
  const LocationField({super.key});

  @override
  State<LocationField> createState() => LocationFieldState();
}

class LocationFieldState extends State<LocationField> {
  final TextEditingController placeController = TextEditingController();

  Future<void> onButtonPress() async {
    String location = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => const MapPage())
    );

    setState(() {
      placeController.text = location;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: placeController,
              decoration: const InputDecoration(
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