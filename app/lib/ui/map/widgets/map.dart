import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../domain/models/event/event.dart';
import '../../domain/models/unit/unit.dart';
import '../event/event_map_marker.dart';
import '../unit/unit_map_marker.dart';

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
  late Key _mapKey;
  late String _currentMapId;
  CameraPosition _lastKnownPosition = const CameraPosition(
    target: MapPage.scasCentre,
    zoom: 9,
  );

  @override
  void initState() {
    super.initState();
    _currentMapId = 'light_map_id';
    _mapKey = UniqueKey();
  }

  bool showEvents = true;
  bool showUnits = true;

  Set<AdvancedMarker> get _markers => {
    ...(showEvents)
        ? widget.events.map(
            (Event event) => event.advancedMapMarker(
              onTap: () {
                debugPrint(
                  'Triggered event map marker onTap for event ${event.idLastFour}',
                );
                widget.viewModel.setSelectedEvent(event);
              },
            ),
          )
        : {},
    ...(showUnits)
        ? widget.units.map((Unit unit) => unit.advancedMapMarker)
        : {},
  };

  @override
  Widget build(BuildContext context) {
    final Switch showEventsSwitch = Switch(
      value: showEvents,
      activeThumbColor: Colors.green,
      onChanged: (bool value) {
        setState(() => showEvents = value);
      },
    );

    final Switch showUnitsSwitch = Switch(
      value: showUnits,
      activeThumbColor: Colors.green,
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
        key: _mapKey,
        mapId: _currentMapId,
        markerType: GoogleMapMarkerType.advancedMarker,
        initialCameraPosition: _lastKnownPosition,
        markers: _markers,
        onCameraMove: (position) {
          // Cache the position so the new map starts exactly here
          _lastKnownPosition = position;
        },
        // // FIXME fix event caller uncertainty circles
        // // circles:
        // //     (showEvents)
        // //         ? widget.events
        // //             .map((Event event) => event.callerLocationCircle)
        // //             .toSet()
        // //         : {},
      ),
    );
  }
}
