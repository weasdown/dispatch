import '../../../domain/models/event.dart';
import '../../../utils/result.dart';
import '../../services/local_data_service.dart';
import 'event_repository.dart';

/// Local implementation of EventRepository
class EventRepositoryLocal implements EventRepository {
  EventRepositoryLocal({required LocalDataService localDataService})
    : _localDataService = localDataService;

  // Only create default booking once
  bool _isInitialized = false;
  // Used to generate IDs for bookings
  int _sequentialId = 0;

  final _events = List<Event>.empty(growable: true);

  final LocalDataService _localDataService;

  // TODO implement allEvents getter (may need to be a List<Event> from a provider rather than a Stream)
  // /// Get a continuous stream of all the events.
  // Stream<Event> get allEvents;

  @override
  Future<Result<List<Event>>> getByID(String id) {
    // TODO: implement getByID
    throw UnimplementedError();
  }
}
