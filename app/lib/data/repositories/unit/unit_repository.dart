import '../../../domain/models/unit/unit.dart';
import '../../../utils/result.dart';

/// Data source for units.
abstract class UnitRepository {
  Future<Result<List<Unit>>> get allUnits;

  /// Get a unit by its callsign.
  Future<Result<Unit>> unitByCallsign(String callsign);
}
