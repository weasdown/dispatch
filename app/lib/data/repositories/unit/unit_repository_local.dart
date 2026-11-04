import 'dart:math' show Random;

import '../../../domain/models/event/event.dart';
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
      _units.where((Unit unit) => unit.callsign == callsign).firstOrNull;

  /// Gets a [Result.ok] holding a random unit from `_units`.
  @override
  Future<Result<Unit?>> get selectedUnit async =>
      Result.ok(_units[Random().nextInt(_units.length)]);

  @override
  Future<Result<void>> standdownUnit(Unit unit) async {
    final Unit? foundUnit = _getUnitByCallsign(unit.callsign);
    if (foundUnit == null) {
      return Result<void>.error(UnitNotFoundException(unit: unit));
    }

    final Event? assignedEvent = foundUnit.assignedEvent;
    if (assignedEvent == null) {
      return Result<void>.error(NoAllocatedEventException(unit: unit));
    }

    log.fine(
      'Standing down ${unit.callsign} from event ${assignedEvent.idLastFour}',
    );
    return Result<void>.ok(foundUnit.standdown());
  }

  @override
  Future<Result<Unit>> unitByCallsign(String callsign) async {
    final unit = _getUnitByCallsign(callsign);
    return (unit != null)
        ? Result.ok(unit)
        : Result.error(Exception('Unit not found'));
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
