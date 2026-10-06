import 'package:dispatch/ui/single_event_screen/view_models/single_event_screen_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_marker_widgets/google_maps_marker_widgets.dart';

import '../../../domain/models/event/event.dart';
import '../../../domain/models/unit/unit.dart';
import '../../event/event_map_marker.dart';
import '../../unit/unit_map_marker.dart';
import '../view_models/map_view_model.dart';

/// A page that displays a Google Maps map.
class MapPage extends StatefulWidget {
  // TODO get events and units from a MapViewModel (will need to create MapViewModel)
  const MapPage({
    super.key,
    required this.viewModel,
    required this.singleEventScreenViewModel,
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

  final MapViewModel viewModel;

  final SingleEventScreenViewModel singleEventScreenViewModel;

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

  final _markerWidgetsController = MarkerWidgetsController();

  @override
  void initState() {
    super.initState();
    _currentMapId = 'light_map_id';
    _mapKey = UniqueKey();

    setMarkers();
  }

  bool showEvents = true;
  bool showUnits = true;


  Iterable<({Marker marker, MarkerWidget markerWidget})> eventMarkers() {
    Iterable<EventMapMarker> eventMarkers = widget.events.map(
          (Event event) =>
          EventMapMarker(
              viewModel: widget.singleEventScreenViewModel, event: event),
    );

    Iterable<({Marker marker, MarkerWidget markerWidget})> eventMapMarkers =
    eventMarkers.map(
          (EventMapMarker eventMarker) =>
      (
      marker: eventMarker.advancedMapMarker,
      markerWidget: eventMarker.markerWidget,
      ),
    );

    return eventMapMarkers;
  }

  Iterable<({Marker marker, MarkerWidget markerWidget})> unitMarkers() {
    Iterable<UnitMapMarker> unitMarkers = widget.units.map(
          (Unit unit) => UnitMapMarker(viewModel: widget.viewModel, unit: unit),
    );

    Iterable<({Marker marker, MarkerWidget markerWidget})> unitMapMarkers =
    unitMarkers.map(
          (UnitMapMarker unitMarker) =>
      (
      marker: unitMarker.advancedMapMarker,
      markerWidget: unitMarker.markerWidget,
      ),
    );

    return unitMapMarkers;
  }

  void setMarkers() {
    _markerWidgetsController.bulkAddMarkerWidget(eventMarkers());

    _markerWidgetsController.bulkAddMarkerWidget(unitMarkers());
  }

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
