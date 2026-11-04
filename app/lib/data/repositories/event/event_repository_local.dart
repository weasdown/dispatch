import 'package:latlong2/latlong.dart';
import 'package:logging/logging.dart';

import '../../../domain/models/event/event.dart';
import '../../../domain/models/event/priority.dart';
import '../../../domain/models/event/remark.dart';
import '../../../domain/models/event/status.dart';
import '../../../domain/models/location/address.dart';
import '../../../domain/models/person/patient.dart';
import '../../../domain/models/unit/unit.dart';
import '../../../utils/result.dart';
import '../../services/local_data_service.dart';
import 'event_repository.dart';

/// Local implementation of EventRepository
class EventRepositoryLocal extends EventRepository {
  EventRepositoryLocal({required this._localDataService}) : _currentIDNum = 100;

  @override
  Future<Result<void>> addEvent(Event event) async {
    if (!_events.contains(event)) {
      _events.add(event);

      // Trigger purple banner for new C1/L1.
      if (event.priority == Priority.zero) {
        newC1StreamController.sink.add(event);
      }

      return Result.ok(null);
    } else {
      return Result.error(EventAlreadyExistsException(eventID: event.id));
    }
  }

  @override
  Future<Result<void>> addPatientToEvent(
    EventID eventID,
    Patient patient,
  ) async => (_selectedEvent == null)
      ? Result.error(Exception('attempted to add patient to null event'))
      : Result.ok(_selectedEvent!.addPatient(patient));

  @override
  Future<Result<void>> addRemark(Remark remark) async =>
      (_selectedEvent == null)
      ? Result.error(Exception('Attempted to add remark to null event'))
      : Result.ok(_selectedEvent!.addRemark(remark));

  @override
  Future<Result<List<Event>>> get allEvents => eventsList;

  // TODO implement allEvents getter (may need to be a List<Event> from a provider rather than a Stream)
  // /// Get a continuous stream of all the events.
  // Stream<Event> get allEvents;

  Future<void> createEvent({
    required Address address,
    required LatLng location,
    required NOC noc,
  }) async {
    _events.add(
      Event.withNOC(
        idNum: _sequentialId++,
        address: address,
        location: location,
        noc: noc,
      ),
    );
  }

  int _currentIDNum;

  @override
  Event get defaultC1 => _localDataService.defaultC1;

  @override
  Future<Result<void>> dispatchUnit(Unit unit) async {
    if (_selectedEvent == null) {
      _log.warning('Cannot dispatch ${unit.callsign} as no event is selected');
      return Result<void>.error(const NoSelectedEventException());
    }

    _log.info(
      'Dispatching ${unit.callsign} to event ${_selectedEvent!.idLastFour}',
    );
    return Result<void>.ok(_selectedEvent!.dispatchUnit(unit));
  }

  @override
  Future<Result<Event>> eventByID(EventID id) async {
    final event = _events.where((event) => event.id == id).firstOrNull;
    if (event == null) {
      return Result<Event>.error(EventNotFoundException(eventID: id));
    }
    return Result<Event>.ok(event);
  }

  @override
  Event? eventForUnit(Unit unit) {
    final Iterable<Event> allocatedEvents = _events.where(
      (Event event) => event.assignedUnits.contains(unit),
    );

    final int numAllocatedEvents = allocatedEvents.length;
    if (numAllocatedEvents != 1) {
      _log.severe(
        MoreThanOneAllocatedEventException(
          numAllocatedEvents: numAllocatedEvents,
          unit: unit,
        ),
      );
      return null;
    } else {
      return allocatedEvents.first;
    }
  }

  final _events = List<Event>.empty(growable: true);

  Future<Result<List<Event>>> get eventsList async {
    // Initialize the repository with default events.
    if (!_isInitialized) {
      _events.addAll(_localDataService.events);
      _isInitialized = true;
    }

    return Result.ok(_events);
  }

  bool _isInitialized = false; // Only create default event once.

  final LocalDataService _localDataService;

  Logger get _log {
    final Logger log = Logger('EventRepositoryLocal');
    log.level = Level.ALL;
    return log;
  }

  @override
  int get nextIDNum {
    int newIDNum = _currentIDNum += 1;
    _currentIDNum = newIDNum;
    return newIDNum;
  }

  /// Gets a [Result.ok] holding a random event from `_events`.
  @override
  Future<Result<Event?>> get selectedEvent async {
    _selectedEvent =
        _events.first; // _events[Random().nextInt(_events.length)];
    return Result.ok(_selectedEvent);
  }

  Event? _selectedEvent;

  int _sequentialId = 0; // Used to generate IDs for events.

  @override
  Future<Result<bool>> setEvent(Event event) async {
    _selectedEvent = event;
    return const Result.ok(true);
  }

  @override
  Future<Result<void>> standdownUnit(Unit unit) async {
    final Event? allocatedEvent = eventForUnit(unit);
    if (allocatedEvent == null) {
      _log.warning(
        'Cannot stand down ${unit.callsign} as it is not allocated to an event',
      );
      return Result<void>.error(NoAllocatedEventException(unit: unit));
    }

    _log.info(
      'Standing down ${unit.callsign} from event ${allocatedEvent.idLastFour}',
    );
    return Result<void>.ok(unit.standdown());
  }

  @override
  Future<Result<void>> updatePatientForEvent(Patient patient) async {
    if (_selectedEvent == null) {
      // TODO test how this branch would be handled
      return Result.error(const NoSelectedEventException());
    }

    final Iterable<String> currentIDs = _selectedEvent!.patients.map(
      (Patient p) => p.id,
    );
    _log.finer(
      'IDs for current patients in event ${_selectedEvent!.idLastFour}: $currentIDs',
    );
    _log.finer("New patient's ID: ${patient.id}");

    try {
      final int currentPatientIndex = _selectedEvent!.patients.indexWhere(
        (Patient p) => p.id == patient.id,
      );
      _log.finer('Current patient index: $currentPatientIndex');

      // If patient is currently in _selectedEvent.patients
      if (currentPatientIndex != -1) {
        // // If currentPatient found
        // (patient != null)
        //     ?
        // We want to update the patient at currentPatientIndex
        _log.finer('Updating patient in event ${_selectedEvent!.idLastFour}');
        _selectedEvent!.updatePatient(currentPatientIndex, patient);
        // :
        //   // We want to remove the current patient
        //   _selectedEvent!.removePatient(currentPatientIndex);
      }
      // Patient is NOT currently in _selectedEvent.patients
      else {
        _log.finer('Adding patient to event ${_selectedEvent!.idLastFour}');
        _selectedEvent!.addPatient(patient);
      }
      return Result.ok(null);
    } on StateError {
      return Result.error(
        NoSelectedEventException(
          ArgumentError.value(
            patient,
            'patient',
            'was not found in _selectedEvent!.patients',
          ) as Error,
        ),
      );
    }
  }

  @override
  void onAutoCat1() {
    _log.fine('Sending new C1 to stream');

    final Event newC1 = _localDataService.defaultC1;

    addEvent(newC1);
    newC1StreamController.sink.add(newC1);
  }
}
