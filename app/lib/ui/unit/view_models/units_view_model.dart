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

    // TODO perhaps use timer as listenable in AllUnitsScreen
    Timer.periodic(const Duration(milliseconds: 100), (Timer timer) {
      notifyListeners();
    });
  }

  late final Command0<void> loadUnits;
  Future<Result<List<Unit>?>> _loadUnits() async {
    try {
      final unitResult = await _unitRepository.allUnits;

      switch (unitResult) {
        case Ok<List<Unit>> _:
          _units = unitResult.value;
          _log.fine('Loaded units');
          return Result.ok(_units);
        case Error<List<Unit>>():
          _log.warning('Failed to load units', unitResult.error);
          return unitResult;
      }
    } finally {
      notifyListeners();
    }
  }

  final Logger _log = Logger('UnitsViewModel')..level = Level.ALL;

  List<Unit>? get units => _units;
  List<Unit>? _units;

  final UnitRepository _unitRepository;

  // _updateTimeInStatus
}
