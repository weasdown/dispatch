import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../map.dart';

/// An ambulance vehicle, air ambulance or other resource.
class Unit {
  Unit({
    required this.callsign,
    required this.location,
    this.vehicleType = VehicleType.dca,
  });

  /// A unique identifier for this resource.
  final String callsign;

  /// Path to the image used as this [Event]'s icon.
  String get _iconAsset => switch (vehicleType) {
    VehicleType.dca => 'assets/images/dca.png',
    VehicleType.rrv => 'assets/images/rrv.png',
    VehicleType.helicopter => 'assets/images/tvaa.jpg',
    VehicleType.criticalCareCar => 'assets/images/hems-car.png',
  };

  /// The current latitude and longitude of this unit.
  LatLng location;

  /// Gets a [Marker] for showing this [Unit] on a map.
  Marker get mapMarker => Marker(
    markerId: MarkerId(callsign),
    position: LatLng(location.latitude, location.longitude),
    icon: markerIcon(_iconAsset),
    infoWindow: InfoWindow(
      title: '$callsign (${vehicleType.name})',
      snippet: location.toString(),
    ),
  );

  /// The type of vehicle that this is.
  final VehicleType vehicleType;
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
    callsign: 'NT431',
    location: LatLng(51.397809576171085, -1.3230646597735394),
    vehicleType: VehicleType.rrv,
  ),
  Unit(
    callsign: 'NR154',
    location: LatLng(51.66706110914126, -1.3082872829130447),
    vehicleType: VehicleType.criticalCareCar,
  ),
  Unit(
    callsign: 'NH58',
    location: LatLng(51.61832936052779, -1.0854888181805424),
    vehicleType: VehicleType.helicopter,
  ),
];

enum VehicleType {
  dca('Double-Crewed Ambulance'),
  rrv('Rapid Response Vehicle'),
  helicopter('Air Ambulance Helicopter'),
  criticalCareCar('Critical Care Car');

  const VehicleType(this.name);

  final String name;
}
