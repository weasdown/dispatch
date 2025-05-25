import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../map.dart';

/// An ambulance vehicle, air ambulance or other resource.
class Unit {
  Unit({
    required this.callsign,
    required this.location,
    this.vehicleType = VehicleType.dca,
  });

  factory Unit.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'callsign': String callsign,
        'location': List<double> location,
        'vehicleType': Map<String, String> vehicleType,
      } =>
        Unit(
          callsign: callsign,
          location: LatLng(location[0], location[1]),
          vehicleType:
              VehicleType.values
                  .where(
                    (VehicleType type) =>
                        type.name == vehicleType['vehicleType'],
                  )
                  .first,
        ),
      _ => throw const FormatException('Failed to load unit.'),
    };
  }

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

enum VehicleType {
  dca('Double-Crewed Ambulance'),
  rrv('Rapid Response Vehicle'),
  helicopter('Air Ambulance Helicopter'),
  criticalCareCar('Critical Care Car');

  const VehicleType(this.name);

  final String name;

  Map<String, dynamic> get toJson => {'vehicleType': name};
}
