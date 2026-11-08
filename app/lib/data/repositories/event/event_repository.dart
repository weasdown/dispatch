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
  }

  Future<Result<List<Event>>> get allEvents;

  Future<Result<void>> addPatientToEvent(EventID eventID, Patient patient);

  Future<Result<void>> addEvent(Event event);

  Future<Result<void>> addRemark(Remark remark);

  Event get defaultC1;

  Future<Result<void>> dispatchUnit(Unit unit);

  /// Get an event by its ID.
  Future<Result<Event>> eventByID(EventID id);

  Event? eventForUnit(Unit unit);

  int get nextIDNum;

  final StreamController<Event> newEventStreamController =
      StreamController<Event>.broadcast();

  Stream<Event> get newEventStream => newEventStreamController.stream;

  final StreamController<Event> newC1StreamController =
      StreamController<Event>.broadcast();

  Stream<Event> get newC1Stream =>
      newEventStream.where((Event event) => event.priority == Priority.zero);

  void onAutoCat1();
  late final Timer autoCat1Timer;

  Future<Result<Event?>> get selectedEvent async => Result.ok(_selectedEvent);

  Event? _selectedEvent;

  Future<Result<void>> setEvent(Event event);

  Future<Result<void>> setNOC(EventID id, NOC noc);

  Future<Result<void>> standdownUnit(Unit unit);

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
