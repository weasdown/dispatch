import 'package:latlng/latlng.dart';

import '../event/event.dart';
import 'unit_status.dart';

/// An ambulance vehicle, air ambulance or other resource.
class Unit {
  Unit({
    required this.callsign,
    required this.location,
    this.vehicleType = VehicleType.dca,
    UnitStatus? status,
  }) : _status = status ?? UnitStatus.pd;

  /// A unique identifier for this resource.
  final String callsign;

  void dispatchTo(Event event) {
    _assignedEvent = event;
    _status = UnitStatus.dp;
  }

  Event? _assignedEvent;

  Event? get assignedEvent => _assignedEvent;

  /// The current latitude and longitude of this unit.
  LatLng location;

  UnitStatus _status;

  UnitStatus get status => _status;

  Map<String, dynamic> toJson() => {
    'callsign': callsign,
    'vehicleType': vehicleType.toString(),
    'location': [location.latitude.degrees, location.longitude.degrees],
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
