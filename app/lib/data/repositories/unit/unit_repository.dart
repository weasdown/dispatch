import 'dart:async';

import 'package:logging/logging.dart';

import '../../../domain/models/unit/unit.dart';
import '../../../utils/result.dart';

/// Data source for units.
abstract class UnitRepository {
  Future<Result<List<Unit>>> get allUnits;

  Logger get log {
    final Logger log = Logger(runtimeType.toString());
    log.level = Level.ALL;
    return log;
  }

  Future<Result<Unit?>> get selectedUnit async => Result.ok(_selectedUnit);

  Unit? _selectedUnit;

  Future<Result<void>> standdownUnit(Unit unit);

  /// Get a unit by its callsign.
  Future<Result<Unit>> unitByCallsign(String callsign);

  Map<String, List<LatLng>> unitRoutes();

  Map<String, Duration> unitTravelTimes();

  /// Triggers the unitUpdateStream to fire a [Unit] when the unit has been updated.
  final StreamController<Unit> updatedUnitStreamController =
      StreamController<Unit>.broadcast();

  Future<Result<void>> updateUnit(String callsign, Unit newUnit);
}

final class UnitNotFoundException implements Exception {
  const UnitNotFoundException({required this.callsign, this.error});

  final Error? error;
  final String callsign;

  @override
  String toString() {
    final String optional = (error == null)
        ? ''
        : ', which caused the following error: ${error.toString()}';
    return 'Unit $callsign not found$optional';
  }
}
