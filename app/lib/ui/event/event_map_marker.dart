import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_marker_widgets/google_maps_marker_widgets.dart';

import '../../domain/models/event/event.dart';
import '../../domain/models/event/priority_colour.dart';
import '../single_event_screen/view_models/single_event_screen_viewmodel.dart';

class EventMapMarker extends StatelessWidget {
  EventMapMarker({
    super.key,
    required this._event,
    required this._viewModel,
    this.onDoubleTap,
  }) : markerId = MarkerId(_event.id);

  final Event _event;

  /// Latitude.
  double get lat => _event.location.latitude;

  /// Longitude.
  double get lng => _event.location.longitude;

  final MarkerId markerId;

  final SingleEventScreenViewModel _viewModel;

  void addToMap(MarkerWidgetsController markerWidgetsController) {
    markerWidgetsController.addMarkerWidget(
      markerWidget: MarkerWidget(markerId: markerId, child: this),
      marker: Marker(
        markerId: markerId,
        anchor: Offset(0.5, 0.5),
        position: LatLng(_event.location.latitude, _event.location.longitude),
      ),
    );
  }

  // TODO move onTap to markerWidget
  /// Gets a [AdvancedMarker] for showing this [Event] on a map.
  AdvancedMarker get advancedMapMarker => AdvancedMarker(
    markerId: markerId,
    position: LatLng(lat, lng),
    onTap: () {
      debugPrint('Setting event to ${_event.idLastFour}');
      _viewModel.updateEvent(_event);
    },

    // infoWindow: InfoWindow(
    //   title: _event.noc?.description ?? _event.status.description,
      //   snippet: _event.address,
      //   // onTap: onTap,
      // ),
    );


  Widget get _body => Container(
    color: _event.priority.colour,
    height: 24,
    width: 36,
    child: Center(
      child: Text(
        _event.idLastFour,
        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
    ),
  );

  MarkerWidget get markerWidget => MarkerWidget(
    markerId: markerId,
    child: GestureDetector(onDoubleTap: onDoubleTap, child: _body),
  );

  final void Function()? onDoubleTap;

  @override
  Widget build(BuildContext context) {
    // final markerWidget = MarkerWidget(
    //   markerId: markerId,
    //   child: Icon(Icons.park, color: Colors.green, size: 45),
    // );
    return _body;
  }
}
