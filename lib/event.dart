import 'package:latlong2/latlong.dart';

/// An emergency event that the ambulance service has become aware of.
class Event {
  Event({required this.location});

  /// The latitude and longitude of the emergency.
  final LatLng location;
}
