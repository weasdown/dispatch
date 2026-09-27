import 'package:latlng/latlng.dart';

import '../../../domain/models/unit/unit.dart';
import '../../../utils/result.dart';

/// Data source for units.
abstract class UnitRepository {
  Future<Result<List<Unit>>> get allUnits;

  Future<void> createUnit({required String callsign, required LatLng location});

  /// Get a unit by its callsign.
  Future<Result<Unit>> unitByCallsign(String callsign);

  Unit? _selectedUnit;

  Future<Result<Unit?>> get selectedUnit async => Result.ok(_selectedUnit);
}
