import 'package:flutter_map/flutter_map.dart';
import 'package:logging/logging.dart';
import 'package:material_ui/material_ui.dart';

import '../../../data/repositories/event/event_repository.dart';
import '../../../data/repositories/unit/unit_repository.dart';
import '../../../domain/models/event/event.dart';
import '../../../domain/models/unit/unit.dart';
import '../../../ui/map/widgets/event_map_marker.dart';
import '../../../utils/command.dart';
import '../../../utils/result.dart';
import '../widgets/unit_map_marker.dart';

// TODO finish implementing MapViewModel
class MapViewModel extends ChangeNotifier {
  MapViewModel({
    required this._eventRepository,
    required this._unitRepository,
    required BuildContext context,
    required ContextMenuController contextMenuController,
  }) : _eventEdited = false {
    selectEvent = Command0<void>(_selectEvent);

    dispatchUnit = Command1<void, Unit>(_dispatchUnit);
    standdownUnit = Command1<void, Unit>(_standdownUnit);

    // _loadEvents = Command0<void>(__loadEvents)..execute();
    // _loadUnits = Command0<void>(__loadUnits)..execute();
    loadMarkers = Command2<dynamic, BuildContext, ContextMenuController>(
      _loadMarkers,
    )..execute(context, contextMenuController);
  }

  List<Marker> buildEventMarkers() => _events
      .map(
        (Event event) =>
            EventMapMarker(event: event, mapViewModel: this).marker,
      )
      .toList();

  List<Marker> buildUnitMarkers({
    required ContextMenuController contextMenuController,
    required BuildContext context,
  }) => _units
      .map(
        (Unit unit) => UnitMapMarker(
          unit: unit,
          mapViewModel: this,
          contextMenuController: contextMenuController,
        ).marker(context),
      )
      .toList();

  late final Command1<void, Unit> dispatchUnit;
  Future<Result<void>> _dispatchUnit(Unit unit) async {
    if (_event == null) {
      return Result<void>.error(const NoSelectedEventException());
    }

    _log.fine('Dispatching ${unit.callsign} to event ${_event!.idLastFour}');
    final result = await _eventRepository.dispatchUnit(unit);
    switch (result) {
      case Ok<void>():
        _log.info(
          'Successfully dispatched ${unit.callsign} to event ${_event!.idLastFour}',
        );
        notifyListeners();
      case Error<void>():
        _log.severe(
          'Failed to dispatch ${unit.callsign} to event ${_event!.idLastFour}: ${result.error}',
        );
    }
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
            EventMapMarker(event: event, mapViewModel: this).marker,
      )
      .toList();

  final EventRepository _eventRepository;

  final UnitRepository _unitRepository;

  // FIXME this is being called too often - several times on startup, perhaps at least once per event (as evidenced by number of log entries for "Loaded n units").
  /// Loads map markers for events and units.
  late final Command2<dynamic, BuildContext, ContextMenuController> loadMarkers;
  Future<Result> _loadMarkers(
    BuildContext context,
    ContextMenuController contextMenuController,
  ) async {
    try {
      final Result<List<Event>> eventsResult = await _eventRepository.allEvents;
      switch (eventsResult) {
        case Ok<List<Event>>():
          final eventsValue = eventsResult.value;
          _events = eventsValue;
          _log.fine('Loaded ${eventsValue.length} events');
        case Error<List<Event>>():
          _log.warning('Failed to load events');
          return eventsResult;
      }

      final Result<List<Unit>> unitsResult = await _unitRepository.allUnits;
      switch (unitsResult) {
        case Ok<List<Unit>>():
          final unitsValue = unitsResult.value;
          _units = unitsValue;
          _log.fine('Loaded ${unitsValue.length} units');
        case Error<List<Unit>>():
          _log.warning('Failed to load units');
          return unitsResult;
      }

      // // TODO remove - believe no longer needed as EventMapMarker includes checking of isSelected in its build method
      // // Load the selected event so we can add highlighting to its map marker.
      // final Result<Event?> selectedEventResult =
      //     await _eventRepository.selectedEvent;
      // switch (selectedEventResult) {
      //   case Ok<Event?>():
      //     final selectedEventValue = selectedEventResult.value;
      //     _log.fine('Loaded selected event');
      //     _event = selectedEventValue;
      //     notifyListeners();
      //   case Error<Event?>():
      //     _log.warning('Failed to load selected event');
      //     errors.add(selectedEventResult.error);
      // }

      if (context.mounted) {
        _markers = [
          ...buildEventMarkers(),
          ...buildUnitMarkers(
            contextMenuController: contextMenuController,
            context: context,
          ),
        ];
      }

      return Result.ok(_markers);
    } finally {
      notifyListeners();
    }
  }

  // // TODO remove unused commands, including in constructor body
  // Future<Result<List<Event>>> __loadEvents() async {
  //   final allEventsResult = await _eventRepository.allEvents;
  //
  //   switch (allEventsResult) {
  //     case Ok<List<Event>> _:
  //       _events = allEventsResult.value;
  //       _log.fine('Loaded events');
  //       return Result.ok(_events);
  //
  //     case Error<List<Event>> _:
  //       _log.warning('Failed to load events', allEventsResult.error);
  //       return allEventsResult;
  //   }
  // }
  //
  // Future<Result<List<Unit>>> __loadUnits() async {
  //   final unitResult = await _unitRepository.allUnits;
  //
  //   switch (unitResult) {
  //     case Ok<List<Unit>> _:
  //       _units = unitResult.value;
  //       _log.fine('Loaded ${_units.length} units');
  //       return Result.ok(_units);
  //     case Error<List<Unit>>():
  //       _log.severe('Failed to load units', unitResult.error);
  //       return unitResult;
  //   }
  // }

  final _log = Logger('MapViewModel')..level = Level.ALL;

  List<Marker> get markers => _markers;
  List<Marker> _markers = [];

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

  Event? get selectedEvent => _selectedEvent;
  Event? _selectedEvent;

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
}
