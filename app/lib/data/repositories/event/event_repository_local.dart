import '../../../domain/models/event/event.dart';
import '../../../domain/models/status.dart';
import '../../../utils/result.dart';
import '../../services/local_data_service.dart';
import '../repository.dart';
import 'event_repository.dart';

/// Local implementation of EventRepository
class EventRepositoryLocal extends EventRepository with LocalRepository {
  EventRepositoryLocal({required LocalDataService localDataService})
    : _localDataService = localDataService;

  @override
  Future<Result<List<Event>>> get allEvents => eventsList;

  // TODO implement allEvents getter (may need to be a List<Event> from a provider rather than a Stream)
  // /// Get a continuous stream of all the events.
  // Stream<Event> get allEvents;

  Future<void> createEvent({required String address, required NOC noc}) async {
    _events.add(Event.withNOC(id: _sequentialId++, address: address, noc: noc));
  }

  @override
  Future<Result<Event>> eventByID(int id) async {
    final event = _events.where((event) => event.id == id).firstOrNull;
    if (event == null) {
      return Result.error(Exception('Booking not found'));
    }
    return Result.ok(event);
  }

  final _events = List<Event>.empty(growable: true);

  Future<Result<List<Event>>> get eventsList async {
    // Initialize the repository with a default event.
    if (!_isInitialized) {
      _events.addAll(localDataService.events);
      _isInitialized = true;
    }

    return Result.ok(_events);
  }

  // Only create default event once.
  bool _isInitialized = false;

  final LocalDataService _localDataService;

  @override
  LocalDataService get localDataService => _localDataService;

  // Used to generate IDs for events.
  int _sequentialId = 0;
}
