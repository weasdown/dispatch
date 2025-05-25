// import 'package:google_maps_flutter/google_maps_flutter.dart' as maps;
import 'package:latlng/latlng.dart';

/// An ambulance vehicle, air ambulance or other resource.
class Unit {
  Unit({
    required this.callsign,
    required this.location,
    this.vehicleType = VehicleType.dca,
  });

  /// A unique identifier for this resource.
  final String callsign;

  // /// Path to the image used as this [Event]'s icon.
  // String get _iconAsset => switch (vehicleType) {
  //   VehicleType.dca => 'assets/images/dca.png',
  //   VehicleType.rrv => 'assets/images/rrv.png',
  //   VehicleType.helicopter => 'assets/images/tvaa.jpg',
  //   VehicleType.criticalCareCar => 'assets/images/hems-car.png',
  // };

  /// The current latitude and longitude of this unit.
  LatLng location;

  // /// Gets a [Marker] for showing this [Unit] on a map.
  // maps.Marker get mapMarker => maps.Marker(
  //   markerId: maps.MarkerId(callsign),
  //   position: maps.LatLng(
  //     location.latitude.degrees,
  //     location.longitude.degrees,
  //   ),
  //   icon: markerIcon(_iconAsset),
  //   infoWindow: maps.InfoWindow(
  //     title: '$callsign (${vehicleType.name})',
  //     snippet: location.toString(),
  //   ),
  // );

  /// The type of vehicle that this is.
  final VehicleType vehicleType;
}

enum VehicleType {
  dca('Double-Crewed Ambulance'),
  rrv('Rapid Response Vehicle'),
  helicopter('Air Ambulance Helicopter'),
  criticalCareCar('Critical Care Car');

  const VehicleType(this.name);

  final String name;
}
