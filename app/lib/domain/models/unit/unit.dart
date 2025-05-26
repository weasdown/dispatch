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

  /// The current latitude and longitude of this unit.
  LatLng location;

  Map<String, dynamic> toJson() => {
    'callsign': callsign,
    'vehicleType': vehicleType.toString(),
    'location': location.toString(),
  };

  @override
  String toString() => callsign;

  /// The type of vehicle that this is.
  final VehicleType vehicleType;
}

enum VehicleType {
  dca('Double-Crewed Ambulance'),
  rrv('Rapid Response Vehicle'),
  helicopter('Air Ambulance Helicopter'),
  criticalCareCar('Critical Care Car'),
  communityFirstResponder('Community First Responder');

  const VehicleType(this.name);

  final String name;
}
