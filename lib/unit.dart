import 'package:google_maps_flutter/google_maps_flutter.dart';

/// An ambulance vehicle, air ambulance or other resource.
class Unit {
  Unit({required this.callsign, required this.location});

  /// A unique identifier for this resource.
  final String callsign;

  /// The current latitude and longitude of this unit.
  LatLng location;

  /// Gets a [Marker] for showing this [Unit] on a map.
  Marker get mapMarker => Marker(
    markerId: MarkerId(callsign),
    position: LatLng(location.latitude, location.longitude),
    icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
    infoWindow: InfoWindow(title: callsign, snippet: location.toString()),
  );
}

final List<Unit> defaultUnits = [
  Unit(
    callsign: 'NA136',
    location: LatLng(51.607539604000266, -1.237806756282358),
  ),
  Unit(
    callsign: 'NA283',
    location: LatLng(51.616072911907786, -1.2536017723108663),
  ),
  Unit(
    callsign: 'NA072',
    location: LatLng(51.8296012219854, -1.3134667111590494),
  ),
  Unit(
    callsign: 'NR154',
    location: LatLng(51.89096056450592, -1.1499680791975175),
  ),
];
