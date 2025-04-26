import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// A page that displays a Google Maps map.
class MapPage extends StatefulWidget {
  const MapPage({super.key, this.centre = MapPage.scasCentre});

  // Approximate geometric centre of the SCAS area.
  static const LatLng scasCentre = LatLng(
    51.453100204133726,
    -1.307710460160255,
  );

  /// The point in the centre of the map when it is first opened.
  final LatLng centre;

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late GoogleMapController mapController;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Maps Sample App'), elevation: 2),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(target: widget.centre, zoom: 9),
      ),
    );
  }
}
