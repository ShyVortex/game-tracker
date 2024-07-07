import 'package:flutter/material.dart';
import 'package:game_tracker/pages/library/map_page.dart';

class LocationField extends StatefulWidget {
  const LocationField({super.key, required this.placeController});

  final TextEditingController placeController;

  @override
  State<LocationField> createState() => LocationFieldState();
}

class LocationFieldState extends State<LocationField> {
  

  Future<void> onButtonPress() async {
    String location = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => const MapPage())
    );

    setState(() {
      widget.placeController.text = location;
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
              controller: widget.placeController,
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