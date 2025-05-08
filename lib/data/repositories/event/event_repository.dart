import '../../../domain/models/event/event.dart';
import '../../../utils/result.dart';

/// Data source for events.
abstract class EventRepository {
  Future<Result<List<Event>>> get allEvents;

  /// Get an event by its ID.
  Future<Result<Event>> eventByID(int id);
}
