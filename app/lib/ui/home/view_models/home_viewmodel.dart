/// @docImport '../../../ui/map/widgets/map.dart';
library;

import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';

import '../../../data/repositories/event/event_repository.dart';
import '../../../data/repositories/unit/unit_repository.dart';
import '../../../domain/models/event/event.dart';
import '../../../domain/models/event/status.dart';
import '../../../domain/models/unit/unit.dart';
import '../../../utils/command.dart';
import '../../../utils/result.dart';

// TODO move commands/methods that are used by many widgets (e.g. getEvent, updateEvent) to a new top-level ViewModel class that this will extend.
class HomeViewModel extends ChangeNotifier {
  HomeViewModel({
    required this._eventRepository,
    required this._unitRepository,
  }) {
    viewNewC1L1 = Command0<void>(_viewNewC1L1);

    getEvent = Command1<void, EventID>(_getEvent);
    selectEvent = Command1<void, Event>(_selectEvent);
    updateEvent = Command2<void, EventID, Event>(_updateEvent);
    setNOC = Command2<void, EventID, NOC>(_setNOC);
    getUpdatedEvent = Command1<Event, EventID>(_getUpdatedEvent);

    triggerRefresh = Command0<void>(_triggerRefresh);

    load = Command0(_load)..execute();
  }

  final EventRepository _eventRepository;

  List<Event> get events => _events;
  List<Event> _events = [];

  late final Command1<void, EventID> getEvent;
  Future<Result<Event?>> _getEvent(EventID id) async {
    final Result<Event> eventResult = await _eventRepository.eventByID(id);
    return switch (eventResult) {
      Ok<Event>() => Result.ok(eventResult.value),
      Error<Event>() => Result.error(eventResult.error),
    };
  }

  int _getEventIndex(EventID id) =>
      _events.indexWhere((Event event) => event.id == id);

  late final Command1<Event, EventID> getUpdatedEvent;
  Future<Result<Event>> _getUpdatedEvent(EventID id) async {
    final Result<Event> updatedEventResult = await _eventRepository.eventByID(
      id,
    );
    switch (updatedEventResult) {
      case Ok<Event>():
        _log.finer('Retrieved updated event $id');
      case Error<Event>():
        _log.severe('Failed to get updated event $id');
    }
    return updatedEventResult;
  }

  late final Command0<void> load;
  Future<Result<void>> _load() async {
    try {
      // Load events
      final eventsResult = await _eventRepository.allEvents;
      switch (eventsResult) {
        case Ok<List<Event>>():
          _events = eventsResult.value;
        case Error<List<Event>>():
          return eventsResult;
      }
      _selectedEvent = _events.first;

      // Load units
      final unitsResult = await _unitRepository.allUnits;
      switch (unitsResult) {
        case Ok<List<Unit>>():
          _units = unitsResult.value;
        case Error<List<Unit>>():
          return eventsResult;
      }

      // Listen to the EventRepository's stream for new events.
      newEventStream.listen(_onNewEvent);

      return Result.ok(null);
    } finally {
      // Listen for event updates.
      _eventRepository.updatedEventStream.listen(_onEventUpdate);

      notifyListeners();
      // TODO confirm whether it'd be better to use this rather than the HomeScreen's StreamBuilder
      // // Listen to the stream for new C1/L1 events.
      // _eventRepository.newC1Stream.listen(onNewC1);
    }
  }

  final _log = Logger('HomeViewModel')..level = Level.ALL;

  bool get newC1Viewed => _newC1Viewed;
  bool _newC1Viewed = true;

  // TODO implement use of newC1L1sNotifier
  // final NewC1L1Notifier newC1L1sNotifier = NewC1L1Notifier([]);

  Stream<Event> get newC1L1Stream => _eventRepository.newC1Stream;

  Stream<Event> get newEventStream => _eventRepository.newEventStream;

  late final Command0<void> triggerRefresh;
  Future<Result<void>> _triggerRefresh() async => Result.ok(notifyListeners());

  /// `_onNewEvent` triggers any listeners to rebuild when a new event is received from the [EventRepository].
  ///
  /// This allows screens like the [MapPage] and AllEventsScreen to stay up to date with the latest [Event]s.
  void _onNewEvent(Event newEvent) async {
    _log.finer('Calling _onNewEvent');
    _events.add(newEvent);
    notifyListeners();
  }

  late final Command1<void, Event> selectEvent;
  Future<Result<void>> _selectEvent(Event event) async {
    _log.fine('Selecting event ${event.idLastFour}');
    _selectedEvent = event;
    notifyListeners();
    return Result.ok(null);
  }

  Event? get selectedEvent => _selectedEvent;
  Event? _selectedEvent;

  late final Command2<void, EventID, NOC> setNOC;
  Future<Result<void>> _setNOC(EventID id, NOC noc) async =>
      _eventRepository.setNOC(id, noc);

  final UnitRepository _unitRepository;

  List<Unit> get units => _units;
  List<Unit> _units = [];

  void _onEventUpdate(Event updatedEvent) async {
    _log.finer('Event ${updatedEvent.idLastFour} has an update');

    try {
      if (!_events.contains(updatedEvent)) {
        _log.severe(
          'Trying to update event ${updatedEvent.idLastFour} but it is not already in HomeViewModel._events',
        );
      }

      _events[_getEventIndex(updatedEvent.id)] = updatedEvent;
    } finally {
      notifyListeners();
    }
  }

  late final Command2<void, EventID, Event> updateEvent;
  Future<Result<void>> _updateEvent(EventID id, Event newEvent) async {
    _log.fine('Updating event $id');
    _eventRepository.updateEvent(id, newEvent);
    notifyListeners();
    return Result.ok(null);
  }

  late final Command0<void> viewNewC1L1;
  Future<Result<void>> _viewNewC1L1() async {
    _newC1Viewed = true;
    // TODO implement call to newC1L1sNotifier.markAsViewed()
    // newC1L1sNotifier.markAsViewed();
    notifyListeners();
    return Result.ok(null);
  }
}

// TODO add to HomeViewModel so widgets just have to listen to that rather than subscribing to a stream.
class NewC1L1Notifier extends ValueNotifier<List<Event>> {
  NewC1L1Notifier(super.value);

  List<Event> get newC1L1s => _newC1L1s;
  final List<Event> _newC1L1s = [];

  void markAsViewed(Event event) {
    _newC1L1s.remove(event);
    notifyListeners();
  }
}
