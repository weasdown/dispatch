import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';

import '../../../data/repositories/unit/unit_repository.dart';
import '../../../domain/models/unit/unit.dart';
import '../../../utils/command.dart';
import '../../../utils/result.dart';

final class UnitsViewModel extends ChangeNotifier {
  UnitsViewModel({required this._unitRepository}) {
    loadUnits = Command0(_loadUnits)..execute();
  }

  late final Command0<void> loadUnits;
  Future<Result<List<Unit>?>> _loadUnits() async {
    try {
      final unitResult = await _unitRepository.allUnits;

      switch (unitResult) {
        case Ok<List<Unit>> _:
          _units = unitResult.value;
          _log.fine('Loaded ${_units.length} units');
          return Result.ok(_units);
        case Error<List<Unit>>():
          _log.severe('Failed to load units', unitResult.error);
          return unitResult;
      }
    } finally {
      notifyListeners();
    }
  }

  final Logger _log = Logger('UnitsViewModel')..level = Level.ALL;

  // TODO use UnitsViewModel.standdownUnit() when standing down a unit from the AllUnitsScreen
  Future<Result<void>> standdownUnit(Unit unit) async {
    _log.fine('Standing down ${unit.callsign}');
    final result = await _unitRepository.standdownUnit(unit);
    switch (result) {
      case Ok<void>():
        _log.info('Successfully stood down ${unit.callsign}');
      case Error<void>():
        _log.severe('Failed to stand down ${unit.callsign}: ${result.error}');
    }

    notifyListeners();
    return result;
  }

  List<Unit> get units => _units;
  List<Unit> _units = [];

  final UnitRepository _unitRepository;
}
