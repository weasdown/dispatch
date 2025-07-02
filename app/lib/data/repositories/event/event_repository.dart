import '../../../domain/models/event/event.dart';
import '../../../utils/result.dart';
import '../repository.dart';

/// Data source for events.
abstract class EventRepository extends Repository {
  Future<Result<List<Event>>> get allEvents;

  /// Get an event by its ID.
  Future<Result<Event>> eventByID(String id);
}
