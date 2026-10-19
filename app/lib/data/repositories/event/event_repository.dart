import '../../../domain/models/event/event.dart';
import '../../../domain/models/event/remark.dart';
import '../../../domain/models/person/patient.dart';
import '../../../utils/result.dart';

/// Data source for events.
abstract class EventRepository {
  Future<Result<List<Event>>> get allEvents;

  Future<Result<void>> addPatientToEvent(EventID eventID, Patient patient);

  Future<Result<void>> addRemark(Remark remark);

  /// Get an event by its ID.
  Future<Result<Event>> eventByID(EventID id);

  int get nextIDNum;

  Event? _selectedEvent;

  Future<Result<Event?>> get selectedEvent async => Result.ok(_selectedEvent);

  Future<Result<void>> setEvent(Event event);

  Future<Result<void>> updatePatientForEvent(Patient patient);
}
