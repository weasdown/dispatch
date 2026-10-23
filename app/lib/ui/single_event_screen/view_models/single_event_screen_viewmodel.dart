import 'package:logging/logging.dart';
import 'package:material_ui/material_ui.dart';

import '../../../data/repositories/event/event_repository.dart';
import '../../../data/repositories/person/user_repository.dart';
import '../../../data/repositories/unit/unit_repository.dart';
import '../../../domain/models/event/event.dart';
import '../../../domain/models/event/remark.dart';
import '../../../domain/models/person/patient.dart';
import '../../../domain/models/person/user.dart';
import '../../../domain/models/unit/unit.dart';
import '../../../utils/capitalise.dart';
import '../../../utils/command.dart';
import '../../../utils/result.dart';

class SingleEventScreenViewModel extends ChangeNotifier {
  SingleEventScreenViewModel({
    required this._eventRepository,
    required this._unitRepository,
  }) : _eventEdited = false,
       _patientEdited = false,
       _eventMode = EventMode.select {
    getMode = Command0<EventMode>(_getMode);

    selectEvent = Command0<void>(_selectEvent);
    // FIXME swap ordering of Command1 type parameters - arg first, then return
    updateEvent = Command1<void, Event>(_updateEvent);

    createPatient = Command1<void, Patient>(_createPatient);
    updatePatient = Command1<void, Patient>(_updatePatient);

    load = Command0(_load)..execute();
  }

  Future<void> addRemark(UserRepository userRepository, String message) async {
    final Result<User> userResult = await userRepository.getUser();

    switch (userResult) {
      case Ok<User> _:
        final User user = userResult.value;
        _eventRepository.addRemark(Remark(author: user, message: message));
      case Error<User> _:
        throw userResult.error;
    }
  }

  late final Command1<void, Patient> createPatient;
  Future<Result<void>> _createPatient(Patient newPatient) async {
    final eventID = _event?.id;
    if (eventID == null) {
      return Result.error(ArgumentError.notNull('_event') as Exception);
    } else {
      return _eventRepository.addPatientToEvent(eventID, newPatient);
    }
  }

  final EventRepository _eventRepository;
  final UnitRepository _unitRepository;

  Event? get event => _event;
  Event? _event;

  // /// `_eventBeforeEdits` is set when the `SingleEventScreen`'s `eventMode` is changed from [EventMode.select] to [EventMode.update].
  // /// This stores the event's parameters as they were at the moment the `eventMode` was changed, so the user can revert back
  // /// to them by clicking back to [EventMode.select] (and after confirming with a dialog that all changes will be lost).
  // ///
  // /// This is initialised when the user first switches from [EventMode.select] to [EventMode.update].
  // late Event _eventBeforeEdits;

  bool get eventEdited => _eventEdited;
  bool _eventEdited;
  void setEventEdited() {
    _log.finer('In setEventEdited');
    _eventEdited = true;
    // notifyListeners();
  }

  void setPatientEdited() {
    _log.finer('In setPatientEdited');
    _patientEdited = true;
  }

  /// [True] if the event is in Update.
  bool get eventLocked => eventMode == .update;

  EventMode get eventMode => _eventMode;
  EventMode _eventMode;

  Future<Result<List<Event>>> get events => _eventRepository.allEvents;

  late final Command0<EventMode> getMode;
  Future<Result<EventMode>> _getMode() async => Result.ok(_eventMode);

  late Command0 load;
  Future<Result<Event?>> _load() async {
    try {
      final eventResult = await _eventRepository.selectedEvent;

      switch (eventResult) {
        case Ok<Event?>():
          _event = eventResult.value;
          _log.fine('Loaded event');
          return Result.ok(_event);
        case Error<Event?>():
          _log.warning('Failed to load event', eventResult.error);
          return eventResult;
      }
    } finally {
      notifyListeners();
    }
  }

  final Logger _log = Logger('SingleEventScreenViewModel')..level = Level.ALL;

  int get nextEventID => _eventRepository.nextIDNum;

  int? get numPatients => _event?.patients.length;

  bool get patientEdited => _patientEdited;
  bool _patientEdited;

  // /// Used when in [EventMode.update] and the user chooses to revert to [EventMode.select], abandoning any changes they have made.
  // /// The event stored in [_eventBeforeEdits] get restored.
  // late final Command0<Event> restorePreviousEvent;
  // Future<Result<Event>> _restorePreviousEvent() async {
  //   _event = _eventBeforeEdits;
  //   notifyListeners();
  //   return Result.ok(_event!);
  // }

  // late final Command1<void, EventMode> setMode;
  // Future<Result<void>> _setMode(EventMode newMode) async {
  //   _eventMode = newMode;
  //   notifyListeners();
  //   return Result.ok(null);
  // }
  //
  // late final Command0<void> setOldEventBeforeEditing;
  // Future<Result<void>> _setOldEventBeforeEditing() async {
  //   if (event != null) {
  //     _eventBeforeEdits = _event!;
  //     notifyListeners(); // TODO confirm if this notify is needed.
  //     return Result.ok(null);
  //   } else {
  //     return Result.error(NoSelectedEventException());
  //   }
  // }

  // Future<Result<void>> _setEvent(Event newEvent)async {}

  Future<Result<List<Unit>>> get units => _unitRepository.allUnits;

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

  late final Command1<void, Event> updateEvent;
  Future<Result<void>> _updateEvent(Event newEvent) async {
    _eventEdited = true;
    _event = newEvent;
    final result = await _eventRepository.setEvent(newEvent);
    switch (result) {
      case Ok<void>():
        _log.fine('Event selected');
      case Error<void>():
        _log.warning('Failed to select Event', result.error);
    }
    notifyListeners();
    return result;
  }

  void updateEventMode(EventMode newMode) {
    _eventMode = newMode;
    notifyListeners();
  }

  late final Command1<void, Patient> updatePatient;
  Future<Result<void>> _updatePatient(Patient patient) async {
    final result = await _eventRepository.updatePatientForEvent(patient);
    switch (result) {
      case Ok<void>():
        _log.fine('Patient updated for event ${_event!.idLastFour}');
      case Error<void>():
        _log.warning(
          'Failed to update patient for event ${_event!.idLastFour}: ${result.error}',
          result.error,
        );
    }
    notifyListeners();
    return result;
  }
}

enum EventMode {
  select,
  create,
  update;

  bool get isEditable => switch (this) {
    EventMode.select => false,
    EventMode.create || EventMode.update => true,
  };

  @override
  toString() => name.capitalise();
}

// class EventModeModel extends ChangeNotifier {
//   bool get isEditing => _isEditing;
//   bool _isEditing = false;
//
//   final Logger _log = Logger('EventModeModel');
//
//   EventMode get mode {
//     _log.fine('Getting mode $_mode from EventModeModel');
//     return _mode;
//   }
//
//   EventMode _mode = .select;
//
//   Future<Result<void>> startEditing() async {
//     _isEditing = true;
//     notifyListeners();
//     return Result.ok(null);
//   }
//
//   Future<Result<void>> stopEditing() async {
//     _isEditing = false;
//     notifyListeners();
//     return Result.ok(null);
//   }
//
//   Future<Result<void>> updateMode(EventMode newMode) async {
//     final oldMode = _mode;
//     _mode = newMode;
//     _log.fine('Changed _mode from $oldMode to $_mode');
//     notifyListeners();
//     return Result.ok(null);
//   }
// }
