import 'package:latlong2/latlong.dart';

/// An emergency event that the ambulance service has become aware of.
class Event {
  Event({required this.address}) : location = _locationFromAddress(address);

  /// The street address of the emergency.
  final String address;

  /// The latitude and longitude of the emergency.
  final LatLng location;

  /// Returns the latitude and longitude of a given street [address].
  static LatLng _locationFromAddress(String address) {
    // TODO: implement _locationFromAddress
    return LatLng(0, 0);
  }
}
