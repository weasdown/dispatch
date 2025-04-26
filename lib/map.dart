import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'event.dart';
import 'unit.dart';

/// A page that displays a Google Maps map.
class MapPage extends StatefulWidget {
  const MapPage({
    super.key,
    this.centre = MapPage.scasCentre,
    required this.events,
    required this.units,
  });

  // Approximate geometric centre of the SCAS area.
  static const LatLng scasCentre = LatLng(
    51.453100204133726,
    -1.307710460160255,
  );

  /// The point in the centre of the map when it is first opened.
  final LatLng centre;

  /// The [Event]s that will be displayed on the map.
  final List<Event> events;

  /// The [Unit]s that are currently in the SCAS fleet.
  final List<Unit> units;

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late GoogleMapController mapController;

  final Set<Marker> _markers = {};

  Future<void> _onMapCreated(GoogleMapController controller) async {
    setState(() {
      _markers.clear();

      // Add event markers
      widget.events.asMap().forEach((int index, Event event) {
        String id = event.id.toString();
        _markers.add(
          Marker(
            markerId: MarkerId(id),
            position: LatLng(event.lat, event.lng),
            infoWindow: InfoWindow(title: id, snippet: event.address),
          ),
        );
      });

      // Add unit markers
      widget.units.asMap().forEach((int index, Unit unit) {
        _markers.add(
          Marker(
            markerId: MarkerId(unit.callsign),
            position: LatLng(unit.location.latitude, unit.location.longitude),
            flat: true,
            infoWindow: InfoWindow(
              title: unit.callsign,
              snippet: unit.location.toString(),
            ),
          ),
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Maps Sample App'), elevation: 2),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(target: widget.centre, zoom: 9),
        markers: _markers,
      ),
    );
  }
}
