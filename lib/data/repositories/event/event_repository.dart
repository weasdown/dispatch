import '../../../domain/models/event.dart';
import '../../../utils/result.dart';

/// Data source for events.
abstract class EventRepository {
  /// Get events by ID.
  Future<Result<List<Event>>> getByID(String id);
}
