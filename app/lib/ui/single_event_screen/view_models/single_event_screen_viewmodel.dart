import 'package:logging/logging.dart';
import 'package:material_ui/material_ui.dart';

import '../../../data/repositories/event/event_mode_repository.dart';
import '../../../data/repositories/event/event_repository.dart';
import '../../../data/repositories/person/user_repository.dart';
import '../../../data/repositories/unit/unit_repository.dart';
import '../../../domain/models/event/event.dart';
import '../../../domain/models/event/remark.dart';
import '../../../domain/models/person/patient.dart';
import '../../../domain/models/person/user.dart';
import '../../../domain/models/unit/unit.dart';
import '../../../utils/command.dart';
import '../../../utils/result.dart';

class SingleEventScreenViewModel extends ChangeNotifier {
  SingleEventScreenViewModel({
    required this._eventRepository,
    required this._eventModeRepository,
    required this._unitRepository,
  }) {
    getMode = Command0<EventMode>(_getMode);
    setMode = Command1<void, EventMode>(_setMode);
    updateEvent = Command0<void>(_updateEvent);
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
  final EventModeRepository _eventModeRepository;
  final UnitRepository _unitRepository;

  Event? get event => _event;
  Event? _event;

  Future<Result<List<Event>>> get events => _eventRepository.allEvents;

  EventMode? get eventMode => _eventMode;
  EventMode? _eventMode;

  late final Command0<EventMode> getMode;
  Future<Result<EventMode>> _getMode() async =>
      _eventModeRepository.getEventMode();

  late Command0 load;
  Future<Result<Event?>> _load() async {
    try {
      final eventResult = await _eventRepository.selectedEvent;
      final Result<EventMode> modeResult = await _eventModeRepository
          .getEventMode();

      switch (eventResult) {
        case Ok<Event?>():
          _event = eventResult.value;
          _log.fine('Loaded event');
        // return Result.ok(_event);
        case Error<Event?>():
          _log.warning('Failed to load event', eventResult.error);
        // return eventResult;
      }

      switch (modeResult) {
        case Ok<EventMode>():
          _eventMode = modeResult.value;
          _log.fine('Loaded eventMode');
          return Result.ok(_event);
        case Error<EventMode>():
          _log.warning('Failed to load eventMode', modeResult.error);
          return eventResult;
      }
    } finally {
      notifyListeners();
    }
  }

  final Logger _log = Logger('SingleEventScreenViewModel');

  // EventMode get mode => _mode;
  // EventMode _mode;

  late final Command1<void, EventMode> setMode;
  Future<Result<void>> _setMode(EventMode newMode) async =>
      _eventModeRepository.updateEventMode(newMode);

  Future<Result<List<Unit>>> get units => _unitRepository.allUnits;

  late final Command0<void> updateEvent;
  Future<Result<void>> _updateEvent() async {
    final result = await _eventRepository.setEvent(_event!);
    switch (result) {
      case Ok<void>():
        _log.fine('Event updated');
      case Error<void>():
        _log.warning('Failed to update Event', result.error);
    }
    return result;
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
}
