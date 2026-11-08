import 'dart:async';

import '../../../domain/models/event/event.dart';
import '../../../domain/models/event/priority.dart';
import '../../../domain/models/event/remark.dart';
import '../../../domain/models/event/status.dart';
import '../../../domain/models/person/patient.dart';
import '../../../domain/models/unit/unit.dart';
import '../../../utils/result.dart';

/// Data source for events.
abstract class EventRepository {
  EventRepository() {
    autoCat1Timer = Timer(Duration(seconds: 5), onAutoCat1);

    // When an event is updated, detect whether it has been upgraded to C1/L1. If so, add it to the newC1L1Stream.
    updatedEventStream.listen(
      (Event event) => event.priority == Priority.zero
          ? newC1StreamController.sink.add(event)
          : null,
    );
  }

  Future<Result<void>> addPatientToEvent(EventID eventID, Patient patient);

  Future<Result<void>> addEvent(Event event);

  Future<Result<void>> addRemark(Remark remark);

  Future<Result<List<Event>>> get allEvents;

  late final Timer autoCat1Timer;

  Event get defaultC1;

  Future<Result<void>> dispatchUnit(Unit unit);

  /// Get an event by its ID.
  Future<Result<Event>> eventByID(EventID id);

  Event? eventForUnit(Unit unit);

  List<EventID> get eventIDs;

  int get nextIDNum;

  final StreamController<Event> newEventStreamController =
      StreamController<Event>.broadcast();

  Stream<Event> get newEventStream => newEventStreamController.stream;

  final StreamController<Event> newC1StreamController =
      StreamController<Event>.broadcast();

  Stream<EventID> get newC1Stream => newEventStream
      .where((Event event) => event.priority == Priority.zero)
      .map((Event event) => event.id);

  void onAutoCat1();

  Future<Result<Event?>> get selectedEvent async => Result.ok(_selectedEvent);

  Event? _selectedEvent;

  Future<Result<void>> selectEvent(Event event);

  Future<Result<void>> setNOC(EventID id, NOC noc);

  Future<Result<void>> standdownUnit(Unit unit);

  /// Triggers the eventUpdateStream to fire an [EventID] when the corresponding [Event] has been updated.
  final StreamController<Event> updatedEventStreamController =
      StreamController<Event>.broadcast();

  Stream<Event> get updatedEventStream => updatedEventStreamController.stream;

  Future<Result<void>> updateEvent(EventID id, Event newEvent);

  Future<Result<void>> updatePatientForEvent(Patient patient);
}

final class EventAlreadyExistsException implements Exception {
  const EventAlreadyExistsException({required this._eventID, this.error});

  final Error? error;
  final EventID _eventID;

  @override
  String toString() {
    final String optional = (error == null)
        ? ''
        : ', which caused the following error: ${error.toString()}';
    return 'Event $_eventID already exists in event repository$optional';
  }
}

final class EventNotFoundException implements Exception {
  const EventNotFoundException({required this._eventID, this.error});

  final Error? error;
  final EventID _eventID;

  @override
  String toString() {
    final String optional = (error == null)
        ? ''
        : ', which caused the following error: ${error.toString()}';
    return 'Event $_eventID not found in event repository$optional';
  }
}

final class NoSelectedEventException implements Exception {
  final Error? error;

  final String _message;

  const NoSelectedEventException([this.error])
    : _message = 'No event is selected';

  @override
  String toString() {
    final String optional = (error == null)
        ? ''
        : ', which caused the following error: ${error.toString()}';
    return _message + optional;
  }
}
