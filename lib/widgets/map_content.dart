import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:game_tracker/main.dart';
import 'package:latlong2/latlong.dart';

class MapContent extends StatefulWidget {
  MapContent({super.key});

  final GlobalKey<MapContentState> accessKey = GlobalKey<MapContentState>();

  @override
  MapContentState createState() => MapContentState();
}

class MapContentState extends State<MapContent> {
  final List<Marker> markers = [];
  final MapController mapController = MapController();
  final Completer<void> _mapReadyCompleter = Completer<void>();

  Future<void> moveToLocation(double latitude, double longitude) async {
    await _mapReadyCompleter.future;
    mapController.move(
        LatLng(latitude, longitude), mapController.camera.zoom
    );
    //addMarker(latitude, longitude);
  }

  void addMarker(double latitude, double longitude) {
    LatLng location = LatLng(latitude, longitude);

    Marker marker = Marker(
      point: location,
      width: 40,
      height: 40,
      alignment: Alignment.center,
      child: GestureDetector(
        onTap: () {},
        child: const Icon(
          Icons.location_pin,
          size: 40,
          color: Colors.red,
        ),
      ),
    );

    setState(() {
      markers.add(marker);
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isLightTheme =
        GameTracker.isLightOrDark(context) == "Light" ? true : false;

    return FlutterMap(
      mapController: mapController,
      options: MapOptions(
          initialCenter: const LatLng(41.5972, 14.2345), // Isernia
          initialZoom: 14,
          interactionOptions: const InteractionOptions(flags: ~InteractiveFlag.doubleTapZoom),
          onMapReady: () {
            _mapReadyCompleter.complete();
          }
      ),
      children: [
        isLightTheme ? lightTileLayer : darkTileLayer,
        MarkerLayer(markers: markers),
      ],
    );
  }
}

TileLayer get lightTileLayer => TileLayer(
  urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
  subdomains: const ['a', 'b', 'c'],
  userAgentPackageName: 'dev.fleaflet.flutter_map_example',
);

TileLayer get darkTileLayer => TileLayer(
  urlTemplate: 'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}.png',
  subdomains: const ['a', 'b', 'c'],
  userAgentPackageName: 'dev.fleaflet.flutter_map_example',
);