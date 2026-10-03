import 'package:google_maps_flutter/google_maps_flutter.dart';

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
    'location': [location.latitude, location.longitude],
  };

  @override
  String toString() => callsign;

  // TODO add a separate unitType attribute, or make subclasses of Unit (and make Unit sealed), for storing type, e.g. OpsComm, as opposed to the vehicle they happen to be in.
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
