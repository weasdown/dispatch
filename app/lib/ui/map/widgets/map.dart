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
  }

  bool showEvents = true;
  bool showUnits = true;

  // Set<AdvancedMarker> get _markers => {
  //   ...(showEvents)
  //       ? widget.events.map(
  //           (Event event) => EventMapMarker(event: event).advancedMapMarker(
  //             onTap: () {
  //               debugPrint(
  //                 'Triggered event map marker onTap for event ${event.idLastFour}',
  //               );
  //               widget.viewModel.setSelectedEvent(event);
  //             },
  //           ),
  //         )
  //       : {},
  //   ...(showUnits)
  //       ? widget.units.map((Unit unit) => unit.advancedMapMarker)
  //       : {},
  // };

  void setMarkers() {
    // onDoubleTap(Event event) {
    //   // debugPrint("Pressed!");
    //   debugPrint(
    //     'Triggered event map marker onTap for event ${event.idLastFour}',
    //   );
    //   widget.viewModel.setSelectedEvent(event);
    // }
    //
    // final Iterable<EventMapMarker> eventMarkers = widget.events.map(
    //   (Event event) => EventMapMarker(
    //     event: event,
    //     viewModel: widget.viewModel,
    //     onDoubleTap: () => onDoubleTap(event),
    //   ),
    // );

    // _markerWidgetsController.addMarkerWidget(
    //   markerWidget: eventMarkers.first.markerWidget(onDoubleTap: onDoubleTap),
    //   marker: eventMarkers.first.advancedMapMarker(),
    // );

    final flightMarkerId = MarkerId('flightMarker');
    _markerWidgetsController.addMarkerWidget(
      markerWidget: MarkerWidget(
        markerId: flightMarkerId,
        child: Text('some text'),
        // SizedBox(
        //   // onTap: () => print('Pressed once!'),
        //   // onDoubleTap: () => print('Pressed twice!'),
        //   height: 30,
        //   // color: Colors.blue,
        //   child: Text('some text'),
        // ),
      ),
      marker: AdvancedMarker(
        markerId: flightMarkerId,
        anchor: Offset(0.5, 0.5),
        // infoWindow: InfoWindow(
        //   title: 'Cleared for takeoff!',
        //   // onTap: () => print('InfoWindow pressed!'),
        // ),
        position: LatLng(
          widget.events.first.location.latitude,
          widget.events.first.location.longitude,
        ),
      ),
    );

    //   // // TODO re-enable adding of event markers.
    //   // // Iterable<({Marker marker, MarkerWidget markerWidget})> newMarkers
    //   // _markerWidgetsController.bulkAddMarkerWidget(
    //   //   eventMarkers.map((EventMapMarker eventMarker) {
    //   //     final Marker marker = eventMarker.advancedMapMarker();
    //   //     final MarkerWidget markerWidget = eventMarker.markerWidget;
    //   //
    //   //     return (marker: marker, markerWidget: markerWidget);
    //   //   }),
    //   // );
  }

  @override
  Widget build(BuildContext context) {
    // final treeMarkerId = MarkerId('treeMarker');
    // final treeMarkerWidget = MarkerWidget(
    //   markerId: treeMarkerId,
    //   child: Icon(Icons.park, color: Colors.green, size: 45),
    // );
    // final treeMarker = Marker(
    //   markerId: treeMarkerId,
    //   anchor: Offset(0.5, 0.5),
    //   position: LatLng(
    //     37,
    //     -108,
    //   ), // LatLng(51.73344408027582, -1.2396893772823594), // Iffley park
    // );

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

    // _markerWidgetsController.addMarkerWidget(
    //   markerWidget: treeMarkerWidget,
    //   marker: treeMarker,
    // );

    setMarkers();

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

        //     GoogleMap(
        //   initialCameraPosition: CameraPosition(
        //     target: LatLng(41.8, -99.65),
        //     zoom: 4,
        //   ),
        //   markers: markers,
        // ),
      ),
    );
  }
}
