import 'package:dispatch/ui/unit/view_models/units_view_model.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:material_ui/material_ui.dart';

import '../../../domain/models/event/event.dart';
import '../../../domain/models/location/scas_locations.dart';
import '../../../domain/models/unit/unit.dart';
import '../../../ui/events/view_models/all_events_view_model.dart';
import '../../events/view_models/single_event_screen_viewmodel.dart';
import 'event_map_marker.dart';
import 'map.dart';
import 'unit_map_marker.dart';

class FlutterMapPage extends StatelessWidget {
  const FlutterMapPage({
    super.key,
    required this.events,
    required this.units,
    required this.eventsViewModel,
    required this.singleEventScreenViewModel,
    required this.unitsViewModel,
    required this.showAmbulanceStations,
    required this.showEOCs,
  });

  /// The [Event]s that will be displayed on the map.
  final List<Event> events;

  final AllEventsViewModel eventsViewModel;

  final SingleEventScreenViewModel singleEventScreenViewModel;

  /// The [Unit]s that are currently in the SCAS fleet.
  final List<Unit> units;

  List<Marker> get eventMarkers {
    final List<Event> nonNullLocations = events
        .where((Event event) => event.location != null)
        .toList();
    final List<Marker> markers = nonNullLocations.map((Event event) {
      return EventMapMarker(
        event: event,
        viewModel: singleEventScreenViewModel,
      ).flutterMapMarker;
    }).toList();
    return markers;
  }

  final bool showAmbulanceStations;

  final bool showEOCs;

  List<Marker> unitMarkers(BuildContext context) => units
      .map(
        (Unit unit) => UnitMapMarker(
          unit: unit,
          eventsViewModel: eventsViewModel,
          unitsViewModel: unitsViewModel,
        ).marker(context),
      )
      .toList();

  final UnitsViewModel unitsViewModel;

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: MapOptions(initialCenter: MapPage.scasCentre, initialZoom: 9),
      children: [
        // Base layer
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png', // For demonstration only
          userAgentPackageName: 'com.weasdown.dispatch',
        ),

        // Units layer
        MarkerLayer(markers: unitMarkers(context)),

        // Events layer
        MarkerLayer(markers: eventMarkers),

        // EOCs layer
        MarkerLayer(
          markers: showEOCs
              ? EmergencyOperationsCentre.values
                    .map((EmergencyOperationsCentre eoc) => eoc.marker)
                    .toList()
              : [],
        ),

        // Ambulance Stations layer
        MarkerLayer(
          markers: showAmbulanceStations
              ? AmbulanceStation.values
                    .map((AmbulanceStation station) => station.marker)
                    .toList()
              : [],
        ),
      ],
    );
  }
}
