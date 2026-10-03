import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';

import '../../domain/models/event/event.dart';
import '../../domain/models/event/priority_colour.dart';

extension EventMapMarker on Event {
  /// Latitude.
  double get lat => location!.latitude.degrees;

  /// Longitude.
  double get lng => location!.longitude.degrees;

  /// Gets a [AdvancedMarker] for showing this [Event] on a map.
  AdvancedMarker advancedMapMarker({required void Function() onTap}) {
    final AdvancedMarker marker = AdvancedMarker(
      markerId: MarkerId(id),
      position: LatLng(lat, lng),
      icon:
          // TODO if possible, set shape of marker to rectangle
          PinConfig(
            backgroundColor: priority.colour,
            borderColor: priority.colour,
            glyph: TextGlyph(text: idLastFour),
          ),
      infoWindow: InfoWindow(
        title: noc?.description ?? status.description,
        snippet: address,
        onTap: onTap,
      ),
    );

    // final GestureDetector detector = GestureDetector(onDoubleTap: onDoubleTap);

    return marker;
  }
}
