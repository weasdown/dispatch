import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'domain/models/event/event.dart';
import 'domain/models/unit/unit.dart';

/// A page that displays a Google Maps map.
class MapPage extends StatefulWidget {
  const MapPage({
    super.key,
    this.centre = MapPage.scasCentre,
    required this.events,
    required this.units,
  });

  /// Approximate geometric centre of the SCAS area.
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

  bool showEvents = true;
  bool showUnits = true;

  Set<Marker> get _markers => {
    // FIXME fix event markers
    // ...(showEvents) ? widget.events.map((Event event) => event.mapMarker) : {},
    ...(showUnits) ? widget.units.map((Unit unit) => unit.mapMarker) : {},
  };

  Future<void> _onMapCreated(GoogleMapController controller) async {
    setState(() {
      _markers.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final Switch showEventsSwitch = Switch(
      value: showEvents,
      activeColor: Colors.green,
      onChanged: (bool value) {
        setState(() => showEvents = value);
      },
    );

    final Switch showUnitsSwitch = Switch(
      value: showUnits,
      activeColor: Colors.green,
      onChanged: (bool value) {
        setState(() => showUnits = value);
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('New CAD'),
        elevation: 2,
        actions: [
          Row(
            children: [
              Row(children: [Text('Show Events? '), showEventsSwitch]),
              SizedBox(width: 8),
              Row(children: [Text('Show Units? '), showUnitsSwitch]),
            ],
          ),
        ],
      ),
      // endDrawer: NavigationDrawer(children: [Text('Event details')]),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(target: widget.centre, zoom: 9),
        markers: _markers,
        // FIXME fix event caller uncertainty circles
        // circles:
        //     (showEvents)
        //         ? widget.events
        //             .map((Event event) => event.callerLocationCircle)
        //             .toSet()
        //         : {},
      ),
    );
  }
}

AssetMapBitmap markerIcon(String asset) => AssetMapBitmap(asset, height: 40);
