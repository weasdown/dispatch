import 'package:dispatch/ui/single_event_screen/view_models/single_event_screen_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

import '../../../domain/models/event/event.dart';
import '../../../domain/models/unit/unit.dart';
import 'flutter_map.dart';

/// A page that displays a Google Maps map.
class MapPage extends StatefulWidget {
  // TODO get events and units from a MapViewModel (will need to create MapViewModel)
  const MapPage({
    super.key,
    // required this.viewModel,
    required this.singleEventScreenViewModel,
    this.centre = MapPage.scasCentre,
    required this.events,
    required this.units,
  });

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

  // final MapViewModel viewModel;

  final SingleEventScreenViewModel singleEventScreenViewModel;

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  bool showEvents = true;
  bool showUnits = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        actions: [
          Row(
            children: [
              Row(
                children: [
                  Text('Show Events? '),
                  _ShowEventsSwitch(
                    showEvents: showEvents,
                    onToggle: (bool value) =>
                        setState(() => showEvents = value),
                  ),
                ],
              ),
              SizedBox(width: 8),
              Row(
                children: [
                  Text('Show Units? '),
                  _ShowUnitsSwitch(
                    showUnits: showUnits,
                    onToggle: (bool value) => setState(() => showUnits = value),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      // endDrawer: NavigationDrawer(children: [Text('Event details')]),

      body: FlutterMapPage(
        events: showEvents ? widget.events : [],
        units: showUnits ? widget.units : [],
        singleEventScreenViewModel: widget.singleEventScreenViewModel,
      ),
      // body: GoogleMapsPage(
      //   singleEventScreenViewModel: widget.singleEventScreenViewModel,
      //   events: widget.events,
      //   units: widget.units,
      // ),
    );
  }
}

class _ShowEventsSwitch extends StatelessWidget {
  const _ShowEventsSwitch({required this.showEvents, required this.onToggle});

  final ValueChanged<bool>? onToggle;
  final bool showEvents;

  @override
  Widget build(BuildContext context) {
    return Switch(
      value: showEvents,
      activeThumbColor: Colors.green,
      onChanged: onToggle,
    );
  }
}

class _ShowUnitsSwitch extends StatelessWidget {
  const _ShowUnitsSwitch({required this.showUnits, required this.onToggle});

  final ValueChanged<bool>? onToggle;
  final bool showUnits;

  @override
  Widget build(BuildContext context) {
    return Switch(
      value: showUnits,
      activeThumbColor: Colors.green,
      onChanged: onToggle,
    );
  }
}
