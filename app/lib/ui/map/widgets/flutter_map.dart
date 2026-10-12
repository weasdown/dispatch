import 'package:dispatch/domain/models/scas_locations.dart';
import 'package:dispatch/ui/map/widgets/event_map_marker.dart';
import 'package:dispatch/ui/map/widgets/unit_map_marker.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:material_ui/material_ui.dart';

import '../../../domain/models/event/event.dart';
import '../../../domain/models/unit/unit.dart';
import '../../single_event_screen/view_models/single_event_screen_viewmodel.dart';
import 'map.dart';

class FlutterMapPage extends StatelessWidget {
  const FlutterMapPage({
    super.key,
    required this.events,
    required this.units,
    required this.singleEventScreenViewModel,
    required this.showAmbulanceStations,
    required this.showEOCs,
  });

  /// The [Event]s that will be displayed on the map.
  final List<Event> events;

  final SingleEventScreenViewModel singleEventScreenViewModel;

  /// The [Unit]s that are currently in the SCAS fleet.
  final List<Unit> units;

  List<Marker> get eventMarkers => events
      .map(
        (Event event) => EventMapMarker(
          event: event,
          viewModel: singleEventScreenViewModel,
        ).flutterMapMarker,
      )
      .toList();

  final bool showAmbulanceStations;

  final bool showEOCs;

  List<Marker> unitMarkers(BuildContext context) => units
      .map((Unit unit) => UnitMapMarker(unit: unit).flutterMapMarker(context))
      .toList();

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
