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
  }) : _eventMode = EventMode.select {
    getMode = Command0<EventMode>(_getMode);
    setMode = Command1<void, EventMode>(_setMode);
    // setMode = Command1<void, EventMode>(_setMode);

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
  // final EventModeRepository _eventModeRepository;
  final UnitRepository _unitRepository;

  Event? get event => _event;
  Event? _event;

  bool get eventEdited => _eventEdited;
  bool _eventEdited;
  void setEventEdited() {
    _eventEdited = true;
    notifyListeners();
  }

  EventMode get eventMode => _eventMode;
  EventMode _eventMode;

  Future<Result<List<Event>>> get events => _eventRepository.allEvents;

  // EventModeModel get eventModeModel => _eventModeModel;
  // final EventModeModel _eventModeModel;

  late final Command0<EventMode> getMode;
  Future<Result<EventMode>> _getMode() async => Result.ok(_eventMode);

  late Command0 load;
  Future<Result<Event?>> _load(
    // BuildContext context
  ) async {
    // _eventMode = .select;
    try {
      final eventResult = await _eventRepository.selectedEvent;
      // final Result<EventMode> modeResult = await _getMode(context);

      switch (eventResult) {
        case Ok<Event?>():
          _event = eventResult.value;
          _log.fine('Loaded event');
          return Result.ok(_event);
        case Error<Event?>():
          _log.warning('Failed to load event', eventResult.error);
          return eventResult;
      }

      // TODO remove commented chunk
      // switch (modeResult) {
      //   case Ok<EventMode>():
      //     _eventMode = modeResult.value;
      //     _log.fine('Loaded eventMode');
      //     return Result.ok(_event);
      //   case Error<EventMode>():
      //     _log.warning('Failed to load eventMode', modeResult.error);
      //     return eventResult;
      // }
    } finally {
      notifyListeners();
    }
  }

  final Logger _log = Logger('SingleEventScreenViewModel')..level = Level.ALL;

  // EventMode get mode => _mode;
  // EventMode _mode;

  // late final Command1<void, EventMode> setMode;
  // Future<Result<void>> _setMode(EventMode newMode) async =>
  //     _eventModeRepository.updateEventMode(newMode);

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

  // late final Command1<void, EventMode> updateEventMode;
  // Future<Result<void>> _updateEventMode(EventMode newMode) async {
  //   _log.fine('Updating event mode from $_eventMode to $newMode');
  //   final result = await _eventModeModel.updateMode(newMode);
  //   switch (result) {
  //     case Error<void>():
  //       _log.warning(
  //         'Failed to update Event mode: ${result.error}',
  //         result.error,
  //       );
  //       return result;
  //     case Ok<void>():
  //       _log.fine('Event mode updated');
  //   }
  //   return result;
  // }

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

  @override
  toString() => name.capitalise();
}

class EventModeModel extends ChangeNotifier {
  bool get isEditing => _isEditing;
  bool _isEditing = false;

  final Logger _log = Logger('EventModeModel');

  EventMode get mode {
    _log.fine('Getting mode $_mode from EventModeModel');
    return _mode;
  }

  EventMode _mode = .select;

  Future<Result<void>> startEditing() async {
    _isEditing = true;
    notifyListeners();
    return Result.ok(null);
  }

  Future<Result<void>> stopEditing() async {
    _isEditing = false;
    notifyListeners();
    return Result.ok(null);
  }

  Future<Result<void>> updateMode(EventMode newMode) async {
    final oldMode = _mode;
    _mode = newMode;
    _log.fine('Changed _mode from $oldMode to $_mode');
    notifyListeners();
    return Result.ok(null);
  }
}
