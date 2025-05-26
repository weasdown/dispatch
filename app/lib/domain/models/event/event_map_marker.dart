import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../map.dart';
import 'event.dart';

extension EventMapMarker on Event {
  // TODO vary the icon based on the category of event.
  /// Path to the image used as this [Event]'s icon.
  String? get _iconAsset =>
      throw UnimplementedError('Event._iconAsset is not yet implemented.');

  /// Latitude.
  double get lat => location.latitude.degrees;

  /// Longitude.
  double get lng => location.longitude.degrees;

  /// Gets a [Marker] for showing this [Event] on a map.
  Marker get mapMarker {
    final String id = this.id.toString();

    return Marker(
      markerId: MarkerId(id),
      position: LatLng(lat, lng),
      icon: (_iconAsset != null)
          ? markerIcon(_iconAsset!)
          : BitmapDescriptor.defaultMarker,
      infoWindow: InfoWindow(
        title: 'Event $id (cat ${category.number})',
        snippet: address,
      ),
    );
  }
}
