import 'dart:math';

import '../../../domain/models/event/event.dart';
import '../../../domain/models/status.dart';
import '../../../utils/result.dart';
import '../../services/local_data_service.dart';
import 'event_repository.dart';

/// Local implementation of EventRepository
class EventRepositoryLocal implements EventRepository {
  EventRepositoryLocal({required LocalDataService localDataService})
    : _localDataService = localDataService;

  // Only create default event once.
  bool _isInitialized = false;
  // Used to generate IDs for events.
  int _sequentialId = 0;

  final _events = List<Event>.empty(growable: true);
  final LocalDataService _localDataService;

  // TODO implement allEvents getter (may need to be a List<Event> from a provider rather than a Stream)
  // /// Get a continuous stream of all the events.
  // Stream<Event> get allEvents;

  Future<Result<List<Event>>> get eventsList async {
    // Initialize the repository with a default event.
    if (!_isInitialized) {
      _events.addAll(_localDataService.events);
      _isInitialized = true;
    }

    return Result.ok(_events);
  }

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

  @override
  Future<Result<List<Event>>> get allEvents => eventsList;

  /// Gets a [Result.ok] holding a random event from `_events`.
  @override
  Future<Result<Event?>> get selectedEvent async =>
      Result.ok(_events[Random().nextInt(_events.length)]);
}
