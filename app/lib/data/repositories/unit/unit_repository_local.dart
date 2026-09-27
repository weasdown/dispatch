import 'dart:math';

import 'package:latlng/latlng.dart';

import '../../../domain/models/unit/unit.dart';
import '../../../utils/result.dart';
import '../../services/local_data_service.dart';
import 'unit_repository.dart';

/// Local implementation of UnitRepository
class UnitRepositoryLocal implements UnitRepository {
  UnitRepositoryLocal({required this._localDataService});

  // Only create default unit once.
  bool _isInitialized = false;

  final _units = List<Unit>.empty(growable: true);
  final LocalDataService _localDataService;

  @override
  Future<Result<List<Unit>>> get allUnits => unitsList;

  @override
  Future<void> createUnit({
    required String callsign,
    required LatLng location,
  }) async {
    _units.add(Unit(callsign: 'NA421', location: LatLng.degree(51.8, 1.2)));
  }

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
