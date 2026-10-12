import 'package:dispatch/ui/single_event_screen/view_models/single_event_screen_viewmodel.dart';
import 'package:gap/gap.dart';
import 'package:material_ui/material_ui.dart';
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
  bool showEOCs = true;
  bool showBases = true;

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
              ), // Show Events switch
              Gap(8),
              Row(
                children: [
                  Text('Show Units? '),
                  _ShowUnitsSwitch(
                    showUnits: showUnits,
                    onToggle: (bool value) => setState(() => showUnits = value),
                  ),
                ],
              ), // Show Units switch
              Gap(8),
              Row(
                children: [
                  Text('Show EOCs? '),
                  _ShowEOCsSwitch(
                    showEOCs: showEOCs,
                    onToggle: (bool value) => setState(() => showEOCs = value),
                  ),
                ],
              ), // Show EOCs switch
              Gap(8),
              Row(
                children: [
                  Text('Show bases? '),
                  _ShowAmbulanceStationsSwitch(
                    showBases: showBases,
                    onToggle: (bool value) => setState(() => showBases = value),
                  ),
                ],
              ), // Show EOCs switch
            ],
          ),
        ],
      ),
      // endDrawer: NavigationDrawer(children: [Text('Event details')]),

      body: FlutterMapPage(
        events: showEvents ? widget.events : [],
        units: showUnits ? widget.units : [],
        singleEventScreenViewModel: widget.singleEventScreenViewModel,
        showAmbulanceStations: showBases,
        showEOCs: showEOCs,
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

class _ShowEOCsSwitch extends StatelessWidget {
  const _ShowEOCsSwitch({required this.showEOCs, required this.onToggle});

  final ValueChanged<bool>? onToggle;
  final bool showEOCs;

  @override
  Widget build(BuildContext context) {
    return Switch(
      value: showEOCs,
      activeThumbColor: Colors.green,
      onChanged: onToggle,
    );
  }
}

class _ShowAmbulanceStationsSwitch extends StatelessWidget {
  const _ShowAmbulanceStationsSwitch({
    required this.showBases,
    required this.onToggle,
  });

  final ValueChanged<bool>? onToggle;
  final bool showBases;

  @override
  Widget build(BuildContext context) {
    return Switch(
      value: showBases,
      activeThumbColor: Colors.green,
      onChanged: onToggle,
    );
  }
}
