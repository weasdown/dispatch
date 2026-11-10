import 'dart:async';

import 'package:latlong2/latlong.dart';
import 'package:logging/logging.dart';

import '../event/event.dart';
import '../location/scas_locations.dart';
import '../person/crew_member.dart';
import 'meal_break_window.dart';
import 'unit_status.dart';

/// An ambulance vehicle, air ambulance or other resource.
class Unit {
  Unit({
    required this.callsign,
    required this._location,
    this._vehicleType = VehicleType.dca,
    required this._personnel,
  }) : assert(_personnel.isNotEmpty) {
    _history.add(
      UnitHistoryEntry(unit: this, status: UnitStatus.pd, time: DateTime.now()),
    );
  }

  @override
  bool operator ==(Object other) =>
      (other is Unit) && (other.callsign == callsign);

  // TODO add another attribute to handle when a unit is Dispatch Assigned to one or more other events at the same time as _assignedEvent being set.
  Event? get assignedEvent => _assignedEvent;
  Event? _assignedEvent;

  void assignToEvent({required Event event, required UnitStatus status}) {
    _assignedEvent = event;
    // TODO remove this call (as could cause a stack overflow given that assignToEvent() is called by Event.addUnitHistory()) or preferably replace with alternative logic to handle adding of unit history to event.
    // event.addUnitHistory(unit: this, status: status);
    _history.add(
      UnitHistoryEntry(unit: this, status: status, time: DateTime.now()),
    );
  }

  /// Distance within which a location update will trigger the unit to auto-at scene.
  static double get autoAtSceneThresholdMiles => 0.25;

  void _autoAtScene() {
    if (assignedEvent == null) {
      throw NoAllocatedEventException(unit: this);
    }
    _log.fine(
      'Auto-at scening $callsign for event ${assignedEvent!.idLastFour}',
    );
    updateStatus(
      newStatus: UnitStatus.as,
      event: assignedEvent!,
      time: DateTime.now(),
    );
  }

  /// Automatically set the unit's status as mobile ([UnitStatus.mo]) a short time after dispatch.
  Timer _autoMobilise(Event event) {
    _log.fine(
      'Running _autoMobilise() for $callsign - will go mobile after ${autoMobiliseDuration.inSeconds} seconds',
    );
    final Timer autoMobiliseTimer = Timer(
      autoMobiliseDuration,
      () => updateStatus(newStatus: UnitStatus.mo, time: DateTime.now()),
    );
    // autoMobiliseTimer.cancel(); // Start cancelled so the timer can be triggered by the calling view model.
    return autoMobiliseTimer;
  }

  /// This amount of time after being dispatched, the unit will go mobile ([UnitStatus.mo]).
  ///
  /// See [_autoMobilise] for implementation.
  static final Duration autoMobiliseDuration = Duration(seconds: 5);

  AmbulanceStation? get base => _base;
  AmbulanceStation? _base;

  /// A unique identifier for this resource.
  final String callsign;

  Timer dispatchToEvent({required Event event}) {
    assignToEvent(event: event, status: UnitStatus.dp);

    // Automatically go mobile a short time after dispatch.
    // Return the timer so it can be cancelled if necessary
    // (e.g. if the unit is stood down or is manually set as mobile before the timer fires).
    return _autoMobilise(event);
  }

  DateTime? get endOfShift => shiftEnd;

  @override
  int get hashCode => Object.hashAll([callsign, vehicleType]);

  bool get isHEMSUnit => switch (vehicleType) {
    VehicleType.helicopter || VehicleType.criticalCareCar => true,
    _ => false,
  };

  /// The current latitude and longitude of this unit.
  LatLng get location => _location;
  LatLng _location;

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

  /// The number of crew members currently logged onto the unit.
  int get numberOfPersonnel => _personnel.length;

  List<CrewMember> get personnel => _personnel;
  final List<CrewMember> _personnel;

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

  final _log = Logger('Unit')..level = Level.ALL;

  List<UnitHistoryEntry> get history => _history;
  final List<UnitHistoryEntry> _history = List.empty(growable: true);

  void standdown() {
    final Event? currentEvent = _assignedEvent;
    if (currentEvent == null) {
      throw NoAllocatedEventException(unit: this);
    }

    _assignedEvent = null;
    currentEvent.standdownUnit(this);
    updateStatus(newStatus: UnitStatus.am);
    _log.fine('Stood down $callsign from ${currentEvent.idLastFour}');
  }

  void updateBase(AmbulanceStation newBase) => _base = newBase;

  void updateLocation({required LatLng newLocation}) {
    _log.fine('Updating location for $callsign to ${newLocation.toString()}');
    _location = newLocation;

    // Check whether the new location is close to the unit's event.
    // If so, mark the unit as at scene.
    if (assignedEvent != null) {
      final Distance distance = Distance();
      final double distanceToEvent = distance.as(
        LengthUnit.Mile,
        assignedEvent!.location!,
        newLocation,
      );
      if (distanceToEvent < autoAtSceneThresholdMiles) {
        _autoAtScene();
      }
    }
  }

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

  void updateStatus({
    required UnitStatus newStatus,
    Event? event,
    DateTime? time,
  }) {
    final DateTime newTime = time ?? DateTime.now();

    if (event != null) {
      _assignedEvent = event;
    }

    _history.add(
      UnitHistoryEntry(unit: this, status: newStatus, time: newTime),
    );
    _log.fine('Updated status for $callsign to ${newStatus.name}');
  }

  // TODO add a separate unitType attribute, or make subclasses of Unit (and make Unit sealed), for storing type, e.g. OpsComm, as opposed to the vehicle they happen to be in.
  /// The type of vehicle that this is.
  VehicleType get vehicleType => _vehicleType;
  VehicleType _vehicleType = VehicleType.dca;
}

final class UnitHistoryEntry {
  const UnitHistoryEntry({
    required this.unit,
    this.event,
    required this.status,
    required this.time,
  });

  final Event? event;
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

extension ToSimpleString on LatLng {
  String toSimpleString([int decimalPlaces = 5]) =>
      '${latitude.toStringAsFixed(decimalPlaces)}, ${longitude.toStringAsFixed(decimalPlaces)}';
}

final class MoreThanOneAllocatedEventException implements Exception {
  final Error? error;
  final String message;
  final int numAllocatedEvents;
  final Unit unit;

  MoreThanOneAllocatedEventException({
    required this.numAllocatedEvents,
    required this.unit,
    this.error,
  }) : message =
           'Unit ${unit.callsign} is assigned to $numAllocatedEvents events  but should only be allocated to zero or one';

  @override
  String toString() {
    final String optional = (error == null)
        ? ''
        : ', which caused the following error: ${error.toString()}';
    return message + optional;
  }
}

final class NoAllocatedEventException implements Exception {
  final Error? error;
  final String message;
  final Unit unit;

  NoAllocatedEventException({required this.unit, this.error})
    : message = 'Unit ${unit.callsign} is not assigned to any events';

  @override
  String toString() {
    final String optional = (error == null)
        ? ''
        : ', which caused the following error: ${error.toString()}';
    return message + optional;
  }
}
