import 'package:flutter/foundation.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:logging/logging.dart';

import '../../../data/repositories/event/event_repository.dart';
import '../../../data/repositories/unit/unit_repository.dart';
import '../../../domain/models/event/event.dart';
import '../../../domain/models/unit/unit.dart';
import '../../../ui/map/widgets/event_map_marker.dart';
import '../../../utils/command.dart';
import '../../../utils/result.dart';

// TODO finish implementing MapViewModel
class MapViewModel extends ChangeNotifier {
  MapViewModel({required this._eventRepository, required this._unitRepository})
    : _eventEdited = false {
    selectEvent = Command0<void>(_selectEvent);
    loadMarkers = Command0(_load)..execute();
  }

  Future<Result<void>> dispatchUnit(Unit unit) async {
    if (_event == null) {
      return Result<void>.error(const NoSelectedEventException());
    }

    _log.fine('Dispatching ${unit.callsign} to event ${_event!.idLastFour}');
    final result = _eventRepository.dispatchUnit(unit);
    notifyListeners();
    return result;
  }

  bool get eventEdited => _eventEdited;
  bool _eventEdited;
  void setEventEdited() {
    _log.finer('In setEventEdited');
    _eventEdited = true;
    // notifyListeners();
  }

  Event? get event => _event;
  Event? _event;

  List<Event> get events => _events;
  List<Event> _events = [];

  List<Marker> get eventMarkers => events
      .map(
        (Event event) =>
            EventMapMarker(event: event, viewModel: this).flutterMapMarker,
      )
      .toList();

  final EventRepository _eventRepository;

  final UnitRepository _unitRepository;

  Future<Result<void>> _load() async {
    final List<Exception> errors = [];

    final Result<Event?> selectedEventResult =
        await _eventRepository.selectedEvent;
    switch (selectedEventResult) {
      case Ok<Event?>():
        final selectedEventValue = selectedEventResult.value;
        _log.fine('Loaded selected event');
        _event = selectedEventValue;
        notifyListeners();
      case Error<Event?>():
        _log.warning('Failed to load selected event');
        errors.add(selectedEventResult.error);
    }

    final Result<List<Event>> eventsResult = await _eventRepository.allEvents;
    switch (eventsResult) {
      case Ok<List<Event>>():
        final eventsValue = eventsResult.value;
        _log.fine('Loaded ${eventsValue.length} events');
        _events = eventsValue;
        notifyListeners();
      case Error<List<Event>>():
        _log.warning('Failed to load events');
        errors.add(eventsResult.error);
    }

    final Result<List<Unit>> unitsResult = await _unitRepository.allUnits;
    switch (unitsResult) {
      case Ok<List<Unit>>():
        final unitsValue = unitsResult.value;
        _log.fine('Loaded ${unitsValue.length} units');
        _units = unitsValue;
        notifyListeners();
      case Error<List<Unit>>():
        _log.warning('Failed to load units');
        errors.add(unitsResult.error);
    }

    if (errors.isNotEmpty) {
      return Result.error(Exception(errors));
    } else {
      return Result.ok(null);
    }
  }

  /// Loads map markers for events and units.
  late final Command0<void> loadMarkers;

  final _log = Logger('MapViewModel')..level = Level.ALL;

  late final Command0<void> selectEvent;
  Future<Result<void>> _selectEvent() async {
    _eventEdited = true;
    final result = await _eventRepository.setEvent(_event!);
    switch (result) {
      case Ok<void>():
        _log.fine('Event selected');
      case Error<void>():
        _log.warning('Failed to select Event', result.error);
    }
    notifyListeners();
    return result;
  }

  // final SingleEventScreenViewModel _singleEventScreenViewModel;

  List<Unit> get units => _units;
  List<Unit> _units = [];
}
