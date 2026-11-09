import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';

import '../../../data/repositories/event/event_repository.dart';
import '../../../data/repositories/unit/unit_repository.dart';
import '../../../domain/models/event/event.dart';
import '../../../domain/models/unit/unit.dart';
import '../../../utils/command.dart';
import '../../../utils/result.dart';

final class UnitsViewModel extends ChangeNotifier {
  UnitsViewModel({
    required this._unitRepository,
    required this._eventRepository,
  }) {
    dispatchUnit = Command2<void, Unit, Event>(_dispatchUnit);
    standdownUnit = Command1<void, Unit>(_standdownUnit);

    loadUnits = Command0<void>(_loadUnits)..execute();
  }

  /// Triggers a refresh after a dispatch unit should have auto-mobilised.
  Future<Result<Timer>> _autoMobiliseUnit() async =>
      // Automatically update once the unit should have automatically gone mobile.
      Result.ok(
        Timer(
          Unit.autoMobiliseDuration + Duration(milliseconds: 200),
          notifyListeners,
        ),
      );

  late final Command2<void, Unit, Event> dispatchUnit;
  Future<Result<void>> _dispatchUnit(Unit unit, Event event) async {
    if (_event == null) {
      return Result<void>.error(const NoSelectedEventException());
    }

    _log.fine('Dispatching ${unit.callsign} to event ${_event!.idLastFour}');
    final dispatchResult = await _eventRepository.dispatchUnit(unit);
    switch (dispatchResult) {
      case Ok<Timer>():
        _log.info(
          'Successfully dispatched ${unit.callsign} to event ${_event!.idLastFour}',
        );
        notifyListeners();
      case Error<Timer>():
        _log.severe(
          'Failed to dispatch ${unit.callsign} to event ${_event!.idLastFour}: ${dispatchResult.error}',
        );
    }

    // Automatically mobilise the unit a short time after dispatch.
    final Result<Timer> autoMobiliseResult = await _autoMobiliseUnit();
    switch (autoMobiliseResult) {
      case Ok<Timer>():
        _log.info(
          'Successfully triggered auto-mobilising of ${unit.callsign} to event ${event.idLastFour}',
        );

      case Error<Timer>():
        _log.severe(
          'Failed to auto-mobilise ${unit.callsign} to event ${event.idLastFour}: ${autoMobiliseResult.error}',
        );
        return autoMobiliseResult;
    }

    return dispatchResult;
  }

  Event? _event;

  final EventRepository _eventRepository;

  late final Command0<void> loadUnits;
  Future<Result<List<Unit>>> _loadUnits() async {
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

  late final Command1<void, Unit> standdownUnit;
  Future<Result<void>> _standdownUnit(Unit unit) async {
    _log.fine('Standing down ${unit.callsign}');
    final result = await _unitRepository.standdownUnit(unit);
    switch (result) {
      case Ok<void>():
        _log.info('Successfully stood down ${unit.callsign}');
        notifyListeners();
      case Error<void>():
        _log.severe('Failed to stand down ${unit.callsign}: ${result.error}');
    }

    return result;
  }

  List<Unit> get units => _units;
  List<Unit> _units = [];

  final UnitRepository _unitRepository;
}
