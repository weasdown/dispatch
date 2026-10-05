import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_marker_widgets/google_maps_marker_widgets.dart';

import '../../domain/models/event/event.dart';
import '../../domain/models/event/priority_colour.dart';
import '../map/view_models/map_view_model.dart';

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

  final MapViewModel _viewModel;

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
  AdvancedMarker advancedMapMarker(
    // {void Function()? onTap}
  ) {
    // onTap =
    //     onTap ??
    //     () {
    //       debugPrint(
    //         'Triggered event map marker onTap for event ${_event.idLastFour}',
    //       );
    //       _viewModel.setSelectedEvent(_event);
    //     };

    final AdvancedMarker marker = AdvancedMarker(
      markerId: MarkerId(_event.id),
      position: LatLng(lat, lng),
      // icon:
      //     // TODO if possible, set shape of marker to rectangle
      //     PinConfig(
      //       backgroundColor: _event.priority.colour,
      //       borderColor: _event.priority.colour,
      //       glyph: TextGlyph(text: _event.idLastFour),
      //     ),
      // infoWindow: InfoWindow(
      //   title: _event.noc?.description ?? _event.status.description,
      //   snippet: _event.address,
      //   // onTap: onTap,
      // ),
    );

    // final GestureDetector detector = GestureDetector(onDoubleTap: onDoubleTap);

    return marker;
  }

  Widget get _body => Container(
    color: _event.priority.colour,
    height: 24,
    width: 36,
    child: GestureDetector(
      onDoubleTap: onDoubleTap,
      child: Text(
        _event.idLastFour,
        style: TextStyle(fontSize: 12),
        textAlign: TextAlign.center,
      ),
    ),
  );
  //     Icon(
  //   IconData(0x00f803, fontFamily: 'MaterialIcons'),
  //   color: Colors.green,
  //   size: 30,
  // );

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
