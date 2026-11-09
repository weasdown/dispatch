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

  Future<Result<bool>> updateUnit(Unit newUnit) async {
    _selectedUnit = newUnit;
    return Result.ok(true);
  }
}

final class UnitNotFoundException implements Exception {
  const UnitNotFoundException({required this.unit, this.error});

  final Error? error;
  final Unit unit;

  @override
  String toString() {
    final String optional = (error == null)
        ? ''
        : ', which caused the following error: ${error.toString()}';
    return 'Unit ${unit.callsign} not found in unit repository$optional';
  }
}
