import 'package:flutter_map/flutter_map.dart';
import 'package:material_ui/material_ui.dart';

import '../../../domain/models/event/event.dart';
import '../../../domain/models/location/scas_locations.dart';
import '../../../domain/models/unit/unit.dart';
import '../../../ui/map/view_models/map_view_model.dart';
import '../../core/error_display.dart';
import '../../core/loading_widget.dart';
import 'map.dart';

class FlutterMapPage extends StatefulWidget {
  const FlutterMapPage({
    super.key,
    required this.viewModel,
    required this.events,
    required this.units,
    required this.showAmbulanceStations,
    required this.showEOCs,
    required this.contextMenuController,
  });

  final ContextMenuController contextMenuController;

  /// The [Event]s that will be displayed on the map.
  final List<Event> events;

  final MapViewModel viewModel;

  /// The [Unit]s that are currently in the SCAS fleet.
  final List<Unit> units;

  final bool showAmbulanceStations;

  final bool showEOCs;

  @override
  State<FlutterMapPage> createState() => _FlutterMapPageState();
}

class _FlutterMapPageState extends State<FlutterMapPage> {
  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.viewModel.loadMarkers,
      builder: (BuildContext context, Widget? child) {
        if (widget.viewModel.loadMarkers.running) {
          return LoadingWidget();
        }

        if (widget.viewModel.loadMarkers.error) {
          return ErrorDisplay(
            title: 'Error while loading map!',
            label: 'Try again',
            onPressed: () => widget.viewModel.loadMarkers.execute(
              context,
              widget.contextMenuController,
            ),
          );
        }

        return child!;
      },
      child: ListenableBuilder(
        listenable: widget.viewModel,
        builder: (BuildContext context, _) {
          return FlutterMap(
            options: MapOptions(
              initialCenter: MapPage.neocwCentre,
              initialZoom: 10,
              onTap: (tapPosition, point) {
                widget.contextMenuController.remove();
              },
            ),
            children: <Widget>[
              // Base layer
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png', // For demonstration only
                userAgentPackageName: 'com.weasdown.dispatch',
              ),

              // Units layer
              MarkerLayer(
                markers: widget.viewModel.buildUnitMarkers(context: context),
              ),

              // Events layer
              ListenableBuilder(
                // Rebuild marker when its event has been updated
                listenable: widget.viewModel.rebuildMarkerForEventWithID,
                builder: (BuildContext context, Widget? child) {
                  while (widget.viewModel.rebuildMarkerForEventWithID.running) {
                    // Wait for new marker to be ready.
                  }

                  return MarkerLayer(markers: widget.viewModel.eventMarkers);
                },
              ),

              // EOCs layer
              MarkerLayer(
                markers: widget.showEOCs
                    ? EmergencyOperationsCentre.values
                          .map((EmergencyOperationsCentre eoc) => eoc.marker)
                          .toList()
                    : [],
              ),

              // Ambulance Stations layer
              MarkerLayer(
                markers: widget.showAmbulanceStations
                    ? AmbulanceStation.values
                          .map((AmbulanceStation station) => station.marker)
                          .toList()
                    : [],
              ),
            ],
          );
        },
      ),
    );
  }
}
