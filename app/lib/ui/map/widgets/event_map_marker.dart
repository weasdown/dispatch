import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart' as fm;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_marker_widgets/google_maps_marker_widgets.dart';
import 'package:latlong2/latlong.dart' as ll2;

import '../../../domain/models/event/event.dart';
import '../../event/priority_colour.dart';
import '../../single_event_screen/view_models/single_event_screen_viewmodel.dart';

class EventMapMarker extends StatelessWidget {
  const EventMapMarker({
    super.key,
    required this._event,
    required this._viewModel,
    // this.onDoubleTap,
  });

  final Event _event;

  fm.Marker get flutterMapMarker =>
      fm.Marker(point: ll2.LatLng(lat, lng), child: _body);

  /// Latitude.
  double get lat => _event.location.latitude;

  /// Longitude.
  double get lng => _event.location.longitude;

  final SingleEventScreenViewModel _viewModel;

  Widget get _body => GestureDetector(
    onTap: () => debugPrint('Tapped event ${_event.idLastFour}'),
    onDoubleTap: _onDoubleTap,
    onSecondaryTap: () =>
        debugPrint('Secondary tapped event ${_event.idLastFour}'),
    child: Container(
      color: _event.priority.backgroundColour,
      height: 24,
      width: 36,
      child: Center(
        child: Text(
          _event.idLastFour,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: _event.priority.textColour,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    ),
  );

  void _onDoubleTap() {
    debugPrint('Double tapped event ${_event.idLastFour}');
    debugPrint('Setting event to ${_event.idLastFour}');
    _viewModel.updateEvent(_event);
  }

  @override
  Widget build(BuildContext context) {
    // final markerWidget = MarkerWidget(
    //   markerId: markerId,
    //   child: Icon(Icons.park, color: Colors.green, size: 45),
    // );
    return _body;
  }
}

class EventGoogleMapsMarker extends EventMapMarker {
  EventGoogleMapsMarker({
    super.key,
    required super.event,
    required super.viewModel,
  }) : markerId = MarkerId(event.id);

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
    onTap: _onDoubleTap,

    // infoWindow: InfoWindow(
    //   title: _event.noc?.description ?? _event.status.description,
    //   snippet: _event.address,
    //   // onTap: onTap,
    // ),
  );

  final MarkerId markerId;

  MarkerWidget get markerWidget => MarkerWidget(
    markerId: markerId,
    child: GestureDetector(onDoubleTap: _onDoubleTap, child: _body),
  );

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
