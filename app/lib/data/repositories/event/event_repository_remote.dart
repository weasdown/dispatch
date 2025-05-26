import 'package:dispatch/data/services/api/api_client.dart';

import '../../../domain/models/event/event.dart';
import '../../../domain/models/status.dart';
import '../../../utils/result.dart';
import '../../defaults.dart';
import '../repository.dart';
import 'event_repository.dart';

/// Local implementation of EventRepository
class EventRepositoryRemote extends EventRepository with RemoteRepository {
  EventRepositoryRemote({required ApiClient apiClient})
    : _apiClient = apiClient;

  @override
  Future<Result<List<Event>>> get allEvents => eventsList;

  final ApiClient _apiClient;

  @override
  ApiClient get apiClient => _apiClient;

  Future<void> createEvent({required String address, required NOC noc}) async {
    _events.add(Event.withNOC(id: _sequentialId++, address: address, noc: noc));
  }

  @override
  Future<Result<Event>> eventByID(int id) async {
    // // TODO get events from apiClient and use the result to update _events.
    // apiClient.requestEvents;

    final event = _events.where((event) => event.id == id).firstOrNull;
    if (event == null) {
      return Result.error(Exception('Booking not found'));
    }
    return Result.ok(event);
  }

  final _events = List<Event>.empty(growable: true);

  Future<Result<List<Event>>> get eventsList async {
    // Initialize the repository default events.
    if (!_isInitialized) {
      _events.addAll(Defaults.events);
      _isInitialized = true;
    }

    return Result.ok(_events);
  }

  // Only create default event once.
  bool _isInitialized = false;

  // Used to generate IDs for events.
  int _sequentialId = 0;
}
