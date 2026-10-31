import 'package:latlong2/latlong.dart';

import '../location/scas_locations.dart';
import 'meal_break_window.dart';
import 'unit_status.dart';

/// An ambulance vehicle, air ambulance or other resource.
class Unit {
  Unit({
    required this.callsign,
    required this.location,
    this.vehicleType = VehicleType.dca,
  }) {
    _timeInStatus.start();
  }

  AmbulanceStation? get base => _base;
  AmbulanceStation? _base;

  /// A unique identifier for this resource.
  final String callsign;

  bool get isHEMSUnit => switch (vehicleType) {
    VehicleType.helicopter || VehicleType.criticalCareCar => true,
    _ => false,
  };

  /// The current latitude and longitude of this unit.
  LatLng location;

  MealBreakWindow? get mealBreakWindow => _mealBreakWindow;
  MealBreakWindow? _mealBreakWindow;

  DateTime? shiftStart;
  DateTime? shiftEnd;

  UnitStatus _status = UnitStatus.pd;

  UnitStatus get status => _status;

  void updateStatus(UnitStatus status) => _status = status;

  Duration get timeInStatus => _timeInStatus.elapsed;
  // TODO instead of directly storing duration, store time of last status update then recalculate duration since then on each tick. This will enable the times in status to be set differently for each unit on startup.
  final Stopwatch _timeInStatus = Stopwatch();

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
  dca('Double-Crewed Ambulance', 'DCA'),
  rrv('Rapid Response Vehicle', 'RRV'),
  helicopter('Air Ambulance Helicopter', 'Heli'),
  criticalCareCar('Critical Care Car', 'HCar'),
  communityFirstResponder('Community First Responder', 'CFR'),
  coResponder('Community First Responder', 'CoResp');

  const VehicleType(this.name, this.abbreviation);

  final String abbreviation;

  final String name;
}
