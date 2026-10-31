import 'package:latlong2/latlong.dart';

import '../event/event.dart';
import '../location/scas_locations.dart';
import 'meal_break_window.dart';
import 'unit_status.dart';

/// An ambulance vehicle, air ambulance or other resource.
class Unit {
  Unit({
    required this.callsign,
    required this.location,
    this._vehicleType = VehicleType.dca,
  }) {
    _history.add(
      UnitHistoryEntry(unit: this, status: UnitStatus.pd, time: DateTime.now()),
    );
  }

  // TODO add another attribute to handle when a unit is Dispatch Assigned to one or more other events at the same time as _assignedEvent being set.
  Event? get assignedEvent => _assignedEvent;
  Event? _assignedEvent;

  void dispatchToEvent({required Event event, required UnitStatus status}) {
    event.dispatchUnit(unit: this);
    _history.add(
      UnitHistoryEntry(unit: this, status: UnitStatus.dp, time: DateTime.now()),
    );
  }

  AmbulanceStation? get base => _base;
  AmbulanceStation? _base;

  /// A unique identifier for this resource.
  final String callsign;

  DateTime? get endOfShift => shiftEnd;

  bool get isHEMSUnit => switch (vehicleType) {
    VehicleType.helicopter || VehicleType.criticalCareCar => true,
    _ => false,
  };

  /// The current latitude and longitude of this unit.
  LatLng location;

  Unit logon({
    required DateTime shiftStart,
    required DateTime shiftEnd,
    required AmbulanceStation base,
    required VehicleType vehicleType,
  }) {
    _shiftStart = shiftStart;
    _shiftEnd = shiftEnd;
    _mealBreakWindow = MealBreakWindow.forShift(
      shiftStart: shiftStart,
      shiftEnd: shiftEnd,
    );

    _base = base;

    _vehicleType = vehicleType;

    updateStatus(newStatus: UnitStatus.pd);

    return this;
  }

  MealBreakWindow? get mealBreakWindow => _mealBreakWindow;
  MealBreakWindow? _mealBreakWindow;

  DateTime? get shiftStart => _shiftStart;
  DateTime? _shiftStart;
  DateTime? get shiftEnd => _shiftEnd;
  DateTime? _shiftEnd;

  UnitStatus get status => _latestHistoryEntry.status;

  Duration get timeInStatus =>
      DateTime.now().difference(_latestHistoryEntry.time);

  Map<String, dynamic> toJson() => {
    'callsign': callsign,
    'vehicleType': vehicleType.toString(),
    'location': [location.latitude, location.longitude],
  };

  @override
  String toString() => callsign;

  UnitHistoryEntry get _latestHistoryEntry => _history.last;

  List<UnitHistoryEntry> get history => _history;
  final List<UnitHistoryEntry> _history = List.empty(growable: true);

  void updateBase(AmbulanceStation newBase) => _base = newBase;

  void updateShiftTimes({
    required DateTime shiftStart,
    required DateTime shiftEnd,
  }) {
    _shiftStart = shiftStart;
    _shiftEnd = shiftEnd;

    _mealBreakWindow = MealBreakWindow.forShift(
      shiftStart: shiftStart,
      shiftEnd: shiftEnd,
    );
  }

  void updateStatus({required UnitStatus newStatus, DateTime? time}) {
    final DateTime newTime = time ?? DateTime.now();

    _history.add(
      UnitHistoryEntry(unit: this, status: newStatus, time: newTime),
    );
  }

  // TODO add a separate unitType attribute, or make subclasses of Unit (and make Unit sealed), for storing type, e.g. OpsComm, as opposed to the vehicle they happen to be in.
  /// The type of vehicle that this is.
  VehicleType get vehicleType => _vehicleType;
  VehicleType _vehicleType = VehicleType.dca;
}

final class UnitHistoryEntry {
  const UnitHistoryEntry({
    required this.unit,
    required this.status,
    required this.time,
  });

  final UnitStatus status;
  final DateTime time;
  final Unit unit;
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

extension ToHM on DateTime {
  String toHM() =>
      '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
}

extension ToHMS on Duration {
  String toHMS() {
    final String hours = inHours.toString().padLeft(2, '0');
    final String minutes = inMinutes.remainder(60).toString().padLeft(2, '0');
    final String seconds = (inSeconds.remainder(60)).toString().padLeft(2, '0');
    return '$hours:$minutes:$seconds';
  }
}
