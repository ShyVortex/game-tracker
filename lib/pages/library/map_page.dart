import 'package:flutter/material.dart';
import 'package:game_tracker/pages/library/search_place_page.dart';
import 'package:osm_nominatim/osm_nominatim.dart';
import '../../main.dart';
import '../../theme/app_theme.dart';
import '../../widgets/map_content.dart';
import 'package:geolocator/geolocator.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => MapPageState();
}

class MapPageState extends State<MapPage> {
  ThemeData themeData = AppTheme.buildThemeData();
  var mapKey = MapContent().accessKey;
  final TextEditingController searchController = TextEditingController();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    Position position;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    /* Passati tutti i controlli possiamo procedere con l'acquisizione
       della posizione */
    position = await Geolocator.getCurrentPosition();

    // Ottieni nome luogo con Nominatim
    final place = await Nominatim.reverseSearch(
      lat: position.latitude,
      lon: position.longitude,
      addressDetails: false,
      extraTags: true,
      nameDetails: true,
    );

    setState(() {
      searchController.text = place.displayName;
      mapKey.currentState?.moveToLocation(
          place.lat, place.lon
      );
    });
  }

  Future<void> onSearchTap() async {
    final result = await Navigator.push(context,
    MaterialPageRoute(builder: (context) => const SearchPlacePage()
      )
    );

    if (result != null) {
      setState(() {
        searchController.text = result.displayName;
        mapKey.currentState?.moveToLocation(
            result.lat, result.lon
        );
      });
    }
  }

  void confirmLocation() {
    Navigator.pop(context, searchController.text);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
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
                    forceMaterialTransparency: true,
                  ),
                  Divider(
                    height: 1,
                    thickness: 1,
                    color: themeData.dividerColor.withOpacity(0.35),
                  ),
                ],
              ),
            ),
            body: Stack(
              children: [
                MapContent(key: mapKey),
                Positioned(
                  top: 16,
                  left: 16,
                  right: 16,
                  child: Card.outlined(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                      side: BorderSide(
                        color: Colors.black.withOpacity(0.35),
                        width: 2,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      child: TextField(
                          controller: searchController,
                          decoration: InputDecoration(
                            hintText: 'Cerca luogo...',
                            hintStyle: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Inter',
                                color: GameTracker.isLightOrDark(context) == "Light"
                                    ? Colors.grey
                                    : Colors.grey[400]
                            ),
                            border: InputBorder.none,
                            prefixIcon: const Icon(Icons.search),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 14),
                          ),
                          readOnly: true,
                          onTap: onSearchTap
                    ),
                  ),
                ),
                )
              ],
            ),
            floatingActionButton: Stack(
                children: <Widget>[
                  Positioned(
                    bottom: 100.0,
                    right: 4.0,
                    child: FloatingActionButton(
                      shape: const CircleBorder(),
                      backgroundColor: Colors.purple,
                      onPressed: determinePosition,
                      child: const Icon(Icons.my_location, color: Colors.white, size: 30),
                    ),
                  ),
                  if (searchController.text.isNotEmpty)
                    Positioned(
                        bottom: 26.0,
                        right: 4.0,
                        child: FloatingActionButton(
                          shape: const CircleBorder(),
                          backgroundColor: Colors.green,
                          onPressed: confirmLocation,
                          child: const Icon(Icons.check, color: Colors.white, size: 30),
                        )
                    )
                ]
            )
        )
    );
  }
}