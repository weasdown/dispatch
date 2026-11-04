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

  /// Get a unit by its callsign.
  Future<Result<Unit>> unitByCallsign(String callsign);

  Unit? _selectedUnit;

  Future<Result<Unit?>> get selectedUnit async => Result.ok(_selectedUnit);

  Future<Result<void>> standdownUnit(Unit unit);

  Future<Result<bool>> updateUnit(Unit newUnit) async {
    _selectedUnit = newUnit;
    return Result.ok(true);
  }
}
