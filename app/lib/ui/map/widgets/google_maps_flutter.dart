import 'package:material_ui/material_ui.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_marker_widgets/google_maps_marker_widgets.dart';

import '../../../domain/models/event/event.dart';
import '../../../domain/models/unit/unit.dart';
import '../../single_event_screen/view_models/single_event_screen_viewmodel.dart';
import 'event_map_marker.dart';
import 'unit_map_marker.dart';

// TODO remove this file entirely
/// A page that displays a Google Maps map.
@Deprecated('Use FlutterMap instead')
class GoogleMapsPage extends StatefulWidget {
  // TODO get events and units from a MapViewModel (will need to create MapViewModel)
  const GoogleMapsPage({
    super.key,
    // required this.viewModel,
    required this.singleEventScreenViewModel,
    this.centre = GoogleMapsPage.scasCentre,
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

  // final MapViewModel viewModel;

  final SingleEventScreenViewModel singleEventScreenViewModel;

  @override
  State<GoogleMapsPage> createState() => _GoogleMapsPageState();
}

class _GoogleMapsPageState extends State<GoogleMapsPage> {
  late Key _mapKey;
  late String _currentMapId;
  CameraPosition _lastKnownPosition = const CameraPosition(
    target: GoogleMapsPage.scasCentre,
    zoom: 9,
  );

  final _markerWidgetsController = MarkerWidgetsController();

  @override
  void initState() {
    super.initState();
    _currentMapId = 'light_map_id';
    _mapKey = UniqueKey();

    setMarkers(context);
  }

  bool showEvents = true;
  bool showUnits = true;

  Iterable<({Marker marker, MarkerWidget markerWidget})> eventMarkers() {
    Iterable<EventGoogleMapsMarker> eventMarkers = widget.events.map(
      (Event event) => EventGoogleMapsMarker(
        viewModel: widget.singleEventScreenViewModel,
        event: event,
      ),
    );

    Iterable<({Marker marker, MarkerWidget markerWidget})> eventMapMarkers =
        eventMarkers.map(
          (EventGoogleMapsMarker eventMarker) => (
            marker: eventMarker.advancedMapMarker,
            markerWidget: eventMarker.markerWidget,
          ),
        );

    return eventMapMarkers;
  }

  Iterable<({Marker marker, MarkerWidget markerWidget})> unitMarkers(
    BuildContext context,
  ) {
    Iterable<UnitGoogleMapsMarker> unitMarkers = widget.units.map(
      (Unit unit) => UnitGoogleMapsMarker(
        // viewModel: widget.singleEventScreenViewModel,
        unit: unit,
      ),
    );

    Iterable<({Marker marker, MarkerWidget markerWidget})> unitMapMarkers =
        unitMarkers.map(
          (UnitGoogleMapsMarker unitMarker) => (
            marker: unitMarker.advancedMapMarker,
            markerWidget: unitMarker.markerWidget(context),
          ),
        );

    return unitMapMarkers;
  }

  void setMarkers(BuildContext context) {
    _markerWidgetsController.bulkAddMarkerWidget(eventMarkers());

    _markerWidgetsController.bulkAddMarkerWidget(unitMarkers(context));
  }

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

      // Version with GoogleMap
      body: MarkerWidgets(
        markerWidgetsController: _markerWidgetsController,
        builder: (context, markers) => GoogleMap(
          key: _mapKey,
          mapId: _currentMapId,
          markerType: GoogleMapMarkerType.advancedMarker,
          initialCameraPosition: _lastKnownPosition,
          markers: markers,
          onCameraMove: (position) {
            // Cache the position so the new map starts exactly here
            _lastKnownPosition = position;
          },
          onTap: (LatLng latlng) => debugPrint('Tapped the map at $latlng'),
          onLongPress: (LatLng latlng) =>
              debugPrint('Long pressed / right clicked the map at $latlng'),
          // // FIXME fix event caller uncertainty circles
          // // circles:
          // //     (showEvents)
          // //         ? widget.events
          // //             .map((Event event) => event.callerLocationCircle)
          // //             .toSet()
          // //         : {},
        ),
      ),
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
