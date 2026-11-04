import '../../../domain/models/event/event.dart';
import '../../../domain/models/event/remark.dart';
import '../../../domain/models/person/patient.dart';
import '../../../domain/models/unit/unit.dart';
import '../../../utils/result.dart';

/// Data source for events.
abstract class EventRepository {
  Future<Result<List<Event>>> get allEvents;

  Future<Result<void>> addPatientToEvent(EventID eventID, Patient patient);

  Future<Result<void>> addRemark(Remark remark);

  Future<Result<void>> dispatchUnit(Unit unit);

  /// Get an event by its ID.
  Future<Result<Event>> eventByID(EventID id);

  Event? eventForUnit(Unit unit);

  int get nextIDNum;

  Event? _selectedEvent;

  Future<Result<Event?>> get selectedEvent async => Result.ok(_selectedEvent);

  Future<Result<void>> setEvent(Event event);

  Future<Result<void>> standdownUnit(Unit unit);

  Future<Result<void>> updatePatientForEvent(Patient patient);
}

final class EventNotFoundException implements Exception {
  const EventNotFoundException({required this.eventID, this.error});

  final Error? error;
  final EventID eventID;

  @override
  String toString() {
    final String optional = (error == null)
        ? ''
        : ', which caused the following error: ${error.toString()}';
    return 'Event $eventID not found in event repository$optional';
  }
}

final class NoSelectedEventException implements Exception {
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
