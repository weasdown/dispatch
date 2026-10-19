import 'package:latlong2/latlong.dart';

import '../../../domain/models/event/event.dart';
import '../../../domain/models/event/remark.dart';
import '../../../domain/models/event/status.dart';
import '../../../domain/models/person/patient.dart';
import '../../../utils/result.dart';
import '../../services/local_data_service.dart';
import 'event_repository.dart';

/// Local implementation of EventRepository
class EventRepositoryLocal extends EventRepository {
  EventRepositoryLocal({required this._localDataService}) : _currentIDNum = 100;

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

  bool _isInitialized = false; // Only create default event once.

  int _sequentialId = 0; // Used to generate IDs for events.

  final _events = List<Event>.empty(growable: true);
  final LocalDataService _localDataService;

  @override
  Future<Result<List<Event>>> get allEvents => eventsList;

  // TODO implement allEvents getter (may need to be a List<Event> from a provider rather than a Stream)
  // /// Get a continuous stream of all the events.
  // Stream<Event> get allEvents;

  Future<Result<List<Event>>> get eventsList async {
    // Initialize the repository with default events.
    if (!_isInitialized) {
      _events.addAll(_localDataService.events);
      _isInitialized = true;
    }

    return Result.ok(_events);
  }

  Future<void> createEvent({
    required String address,
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

  @override
  Future<Result<Event>> eventByID(EventID id) async {
    final event = _events.where((event) => event.id == id).firstOrNull;
    if (event == null) {
      return Result.error(Exception('Event not found'));
    }
    return Result.ok(event);
  }

  int _currentIDNum;

  @override
  int get nextIDNum {
    int newIDNum = _currentIDNum += 1;
    _currentIDNum = newIDNum;
    return newIDNum;
  }

  Event? _selectedEvent;

  /// Gets a [Result.ok] holding a random event from `_events`.
  @override
  Future<Result<Event?>> get selectedEvent async {
    _selectedEvent =
        _events.first; // _events[Random().nextInt(_events.length)];
    return Result.ok(_selectedEvent);
  }

  @override
  Future<Result<bool>> setEvent(Event event) async {
    _selectedEvent = event;
    return const Result.ok(true);
  }

  @override
  Future<Result<void>> updatePatientForEvent(Patient patient) async {
    if (_selectedEvent == null) {
      // TODO test how this branch would be handled
      return Result.error(NoSelectedEventException());
    }

    try {
      final int currentPatientIndex = _selectedEvent!.patients.indexWhere(
        (Patient p) => p.id == patient.id,
      );
      _selectedEvent!.updatePatient(currentPatientIndex, patient);
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
}

class NoSelectedEventException implements Exception {
  final Error? error;

  final String message;

  const NoSelectedEventException([this.error])
    : message = 'No event is selected';

  @override
  String toString() {
    final String base = 'no event is selected';
    final String optional = (error == null)
        ? ''
        : ', which caused the following error: ${error.toString()}';
    return base + optional;
  }
}
