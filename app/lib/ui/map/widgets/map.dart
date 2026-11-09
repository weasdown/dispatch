import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:latlong2/latlong.dart';
import 'package:material_ui/material_ui.dart';

import '../../../domain/models/event/event.dart';
import '../../../domain/models/unit/unit.dart';
import '../../../utils/result.dart';
import '../view_models/map_view_model.dart';
import 'flutter_map.dart';

/// A page that displays a Google Maps map.
class MapPage extends StatefulWidget {
  // TODO get events and units from a MapViewModel (will need to create MapViewModel)
  const MapPage({
    super.key,
    required this.mapViewModel,
    this.centre = MapPage.scasCentre,
    required this.events,
    required this.units,
    required this.contextMenuController,
  });

  final ContextMenuController contextMenuController;

  /// The point in the centre of the map when it is first opened.
  final LatLng centre;

  /// The [Event]s that will be displayed on the map.
  final List<Event> events;

  /// The [Unit]s that are currently in the SCAS fleet.
  final List<Unit> units;

  final MapViewModel mapViewModel;

  static const LatLng scasCentre = LatLng(
    51.453100204133726,
    -1.307710460160255,
  );

  static const LatLng neocwCentre = LatLng(
    51.672607328676335,
    -1.2721970494807033,
  );

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  List<Event> _events = [];
  List<Unit> _units = [];

  bool showEvents = true;
  bool showUnits = true;
  bool showEOCs = true;
  bool showBases = true;

  @override
  void initState() {
    super.initState();
    // On web, disable the browser's context menu to instead use a custom
    // Flutter-rendered context menu.
    if (kIsWeb) {
      BrowserContextMenu.disableContextMenu();
    }
  }

  @override
  void dispose() {
    if (kIsWeb) {
      BrowserContextMenu.enableContextMenu();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([
        widget.mapViewModel.loadMarkers,
        // widget.mapViewModel.loadEvents,
        // widget.mapViewModel.loadUnits,
      ]),
      builder: (BuildContext context, Widget? child) {
        // TODO neaten this collection of ifs

        // If either command is running, show progress indicator
        if (widget.mapViewModel.loadMarkers.running) {
          return const Center(child: CircularProgressIndicator());
        }
        // if (widget.mapViewModel.loadEvents.running ||
        //     widget.mapViewModel.loadUnits.running) {
        //   return const Center(child: CircularProgressIndicator());
        // }

        // If fails to load markers, tap to try again
        if (widget.mapViewModel.loadMarkers.error) {
          return Center(
            // TODO implement proper display of error that enables user to retry load
            child: ErrorWidget(
              (widget.mapViewModel.loadMarkers.result as Error<List<Event>>)
                  .error,
            ),
          );
        }

        // // TODO remove commented code
        // // If fails to load events, tap to try again
        // if (widget.mapViewModel.loadEvents.error) {
        //   return Center(
        //     // TODO implement proper display of error that enables user to retry load
        //     child: ErrorWidget(
        //       (widget.mapViewModel.loadEvents.result as Error<List<Event>>)
        //           .error,
        //     ),
        //   );
        // }
        //
        // // If fails to load units, tap to go /home
        // if (widget.mapViewModel.loadUnits.error) {
        //   return Center(
        //     // TODO implement proper display of error that enables user to retry load
        //     child: ErrorWidget(
        //       (widget.mapViewModel.loadUnits.result as Error<List<Unit>?>)
        //           .error,
        //     ),
        //   );
        // }

        // // TODO remove these two ifs - debugging only
        // if (widget.mapViewModel.loadEvents.completed) {
        //   _log.finer('loadEvents completed');
        //   _events = widget.mapViewModel.events;
        // }
        // if (widget.mapViewModel.loadUnits.completed) {
        //   _log.finer('loadUnits completed');
        //   _units = widget.mapViewModel.units;
        // }

        // FIXME map markers not being displayed until automatic C1 triggers
        if (widget.mapViewModel.loadMarkers.completed) {
          _events = widget.mapViewModel.events;
          _units = widget.mapViewModel.units;
          return child!;
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
      child: Scaffold(
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
                      onToggle: (bool value) =>
                          setState(() => showUnits = value),
                    ),
                  ],
                ), // Show Units switch
                Gap(8),
                Row(
                  children: [
                    Text('Show EOCs? '),
                    _ShowEOCsSwitch(
                      showEOCs: showEOCs,
                      onToggle: (bool value) =>
                          setState(() => showEOCs = value),
                    ),
                  ],
                ), // Show EOCs switch
                Gap(8),
                Row(
                  children: [
                    Text('Show bases? '),
                    _ShowAmbulanceStationsSwitch(
                      showBases: showBases,
                      onToggle: (bool value) =>
                          setState(() => showBases = value),
                    ),
                  ],
                ), // Show EOCs switch
              ],
            ),
          ],
        ),
        // endDrawer: NavigationDrawer(children: [Text('Event details')]),

        body: _MapBody(
          mapViewModel: widget.mapViewModel,
          events: _events,
          units: _units,
          showEvents: showEvents,
          showUnits: showUnits,
          showBases: showBases,
          showEOCs: showEOCs,
          contextMenuController: widget.contextMenuController,
        ),
        // body: GoogleMapsPage(
        //   singleEventScreenViewModel: widget.singleEventScreenViewModel,
        //   events: widget.events,
        //   units: widget.units,
        // ),
      ),
    );
  }
}

class _MapBody extends StatelessWidget {
  const _MapBody({
    required this.mapViewModel,
    required this._events,
    required this._units,
    required this.showEvents,
    required this.showUnits,
    required this.showBases,
    required this.showEOCs,
    required this.contextMenuController,
  });

  final ContextMenuController contextMenuController;

  final List<Event> _events;
  final List<Unit> _units;

  final MapViewModel mapViewModel;

  final bool showBases;
  final bool showEOCs;
  final bool showEvents;
  final bool showUnits;

  @override
  Widget build(BuildContext context) {
    return FlutterMapPage(
      viewModel: mapViewModel,
      events: showEvents ? _events : [],
      units: showUnits ? _units : [],
      showAmbulanceStations: showBases,
      showEOCs: showEOCs,
      contextMenuController: contextMenuController,
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
