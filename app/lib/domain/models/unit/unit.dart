import 'package:latlng/latlng.dart';

import '../../../data/defaults.dart';
import '../../../data/services/api/api_client.dart';
import '../event/event.dart';
import 'unit_status.dart';
import 'vehicle_type.dart';

/// An ambulance vehicle, air ambulance or other resource.
class Unit {
  Unit({
    required this.callsign,
    required this.location,
    this.vehicleType = VehicleType.dca,
    UnitStatus? status,
  }) : _status = status ?? UnitStatus.pd;

  factory Unit.fromJson(Map<String, dynamic> json) => switch (json) {
    {
      'callsign': String callsign,
      'location': [double latitude, double longitude],
      'vehicleType': String vehicleType,
      'status': String status,
    } =>
      () {
        VehicleType unitVehicleType = VehicleType.values
            .where(
              (VehicleType vehicleTypeOption) =>
                  vehicleTypeOption.name == vehicleType,
            )
            .first;
        UnitStatus unitStatus = UnitStatus.values
            .where((UnitStatus statusOption) => statusOption.name == status)
            .first;

        return Unit(
          callsign: callsign,
          location: LatLng(Angle.degree(latitude), Angle.degree(longitude)),
          vehicleType: unitVehicleType,
          status: unitStatus,
        );
      }(),
    _ => throw const FormatException('Failed to load unit.'),
  };

  /// A unique identifier for this resource.
  final String callsign;

  void dispatchTo(Event event) {
    _assignedEvent = event;
    _status = UnitStatus.dp;

    // Add this to the Event's assignedUnits if not already in there.
    if (!event.assignedCallsigns.contains(callsign)) {
      event.addUnit(this);
    }
  }

  Event? _assignedEvent;

  Event? get assignedEvent => _assignedEvent;

  /// The current latitude and longitude of this unit.
  LatLng location;

  UnitStatus _status;

  UnitStatus get status => _status;

  Map<String, dynamic> toJson() => {
    'callsign': callsign,
    'location': [location.latitude.degrees, location.longitude.degrees],
    'vehicleType': vehicleType.name,
    'status': status.name,
  };

  @override
  String toString() => callsign;

  /// The type of vehicle that this is.
  final VehicleType vehicleType;
}
