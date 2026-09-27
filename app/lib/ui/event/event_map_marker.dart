import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';

import '../../domain/models/event/category.dart';
import '../../domain/models/event/event.dart';
import '../../domain/models/event/priority_colour.dart';

extension EventMapMarker on Event {
  /// Latitude.
  double get lat => location!.latitude.degrees;

  /// Longitude.
  double get lng => location!.longitude.degrees;

  /// Gets a [AdvancedMarker] for showing this [Event] on a map.
  AdvancedMarker get advancedMapMarker {
    String status = category != Category.none
        ? 'Cat ${category.number}'
        : this.status.description;
    return AdvancedMarker(
      markerId: MarkerId(id),
      position: LatLng(lat, lng),
      icon:
          // TODO if possible, set shape of marker to rectangle
          PinConfig(
            backgroundColor: priority.colour,
            borderColor: priority.colour,
            glyph: TextGlyph(text: idLastFour),
          ),
      infoWindow: InfoWindow(title: 'Event $id ($status)', snippet: address),
    );
  }
}
