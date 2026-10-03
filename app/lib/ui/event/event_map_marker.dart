import 'package:flutter/material.dart';
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';

import '../../domain/models/event/event.dart';
import '../../domain/models/event/priority_colour.dart';

class EventMapMarker extends StatelessWidget {
  const EventMapMarker({super.key, required this._event});

  final Event _event;

  /// Latitude.
  double get lat => _event.location.latitude.degrees;

  /// Longitude.
  double get lng => _event.location.longitude.degrees;

  /// Gets a [AdvancedMarker] for showing this [Event] on a map.
  AdvancedMarker advancedMapMarker({required void Function() onTap}) {
    final AdvancedMarker marker = AdvancedMarker(
      markerId: MarkerId(_event.id),
      position: LatLng(lat, lng),
      icon:
          // TODO if possible, set shape of marker to rectangle
          PinConfig(
            backgroundColor: _event.priority.colour,
            borderColor: _event.priority.colour,
            glyph: TextGlyph(text: _event.idLastFour),
          ),
      infoWindow: InfoWindow(
        title: _event.noc?.description ?? _event.status.description,
        snippet: _event.address,
        onTap: onTap,
      ),
    );

    // final GestureDetector detector = GestureDetector(onDoubleTap: onDoubleTap);

    return marker;
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
