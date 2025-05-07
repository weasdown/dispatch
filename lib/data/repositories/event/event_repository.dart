import '../../../domain/models/event.dart';
import '../../../utils/result.dart';

/// Data source for events.
abstract class EventRepository {
  /// Get an event by its ID.
  Future<Result<Event>> eventByID(int id);
}
