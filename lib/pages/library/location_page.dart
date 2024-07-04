import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/map_content.dart';

class LocationPage extends StatefulWidget {
  const LocationPage({super.key});

  @override
  State<LocationPage> createState() => LocationPageState();
}

class LocationPageState extends State<LocationPage> {
  ThemeData themeData = AppTheme.buildThemeData();
  var mapKey = MapContent().accessKey;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight + 1),
        child: Column(
          children: [
            AppBar(
                title: const Text(
                  "Seleziona luogo",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 26,
                    fontFamily: 'Inter',
                  ),
                ),
                // Impedisce di cambiare colore quando il contenuto viene scrollato
                forceMaterialTransparency: true
            ),
            Divider(
              height: 1,
              thickness: 1,
              color: themeData.dividerColor.withOpacity(0.35),
            ),
          ],
        ),
      ),
      body: MapContent(),
    );
  }
}