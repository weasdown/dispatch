import 'dart:math';

import '../../../domain/models/unit/unit.dart';
import '../../../utils/result.dart';
import '../../services/local_data_service.dart';
import 'unit_repository.dart';

/// Local implementation of UnitRepository
class UnitRepositoryLocal extends UnitRepository {
  UnitRepositoryLocal({required this._localDataService});

  // Only create default unit once.
  bool _isInitialized = false;

  final _units = List<Unit>.empty(growable: true);
  final LocalDataService _localDataService;

  @override
  Future<Result<List<Unit>>> get allUnits => unitsList;

  Unit? _getUnitByCallsign(String callsign) =>
      _units.where((unit) => unit.callsign == callsign).firstOrNull;

  /// Gets a [Result.ok] holding a random unit from `_units`.
  @override
  Future<Result<Unit?>> get selectedUnit async =>
      Result.ok(_units[Random().nextInt(_units.length)]);

  @override
  Future<Result<Unit>> unitByCallsign(String callsign) async {
    final unit = _units.where((unit) => unit.callsign == callsign).firstOrNull;
    if (unit == null) {
      return Result.error(Exception('Unit not found'));
    }
    return Result.ok(unit);
  }

  Future<Result<List<Unit>>> get unitsList async {
    // Initialize the repository with a default unit.
    if (!_isInitialized) {
      _units.addAll(_localDataService.units);
      _isInitialized = true;
    }

    return Result.ok(_units);
  }
}
