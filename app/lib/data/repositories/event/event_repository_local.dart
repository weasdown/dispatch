import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../domain/models/event/event.dart';
import '../../../domain/models/event/remark.dart';
import '../../../domain/models/event/status.dart';
import '../../../utils/result.dart';
import '../../services/local_data_service.dart';
import 'event_repository.dart';

/// Local implementation of EventRepository
class EventRepositoryLocal extends EventRepository {
  EventRepositoryLocal({required this._localDataService}) : _currentIDNum = 100;

  @override
  void addRemark(Remark remark) {
    if (_selectedEvent == null) {
      throw Exception('Attempted to add remark to null event in $runtimeType.');
    }
    _selectedEvent!.addRemark(remark);
  }

  bool _isInitialized = false; // Only create default event once.

  int _sequentialId = 0; // Used to generate IDs for events.

  final _events = List<Event>.empty(growable: true);
  final LocalDataService _localDataService;

  @override
  Future<Result<List<Event>>> get allEvents => eventsList;

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

  Future<void> createEvent({
    required String address,
    required LatLng location,
    required NOC noc,
  }) async {
    _events.add(
      Event.withNOC(
        idNum: _sequentialId++,
        address: address,
        location: location,
        noc: noc,
      ),
    );
  }

  @override
  Future<Result<Event>> eventByID(String id) async {
    final event = _events.where((event) => event.id == id).firstOrNull;
    if (event == null) {
      return Result.error(Exception('Event not found'));
    }
    return Result.ok(event);
  }

  int _currentIDNum;

  @override
  int get nextIDNum {
    int newIDNum = _currentIDNum += 1;
    _currentIDNum = newIDNum;
    return newIDNum;
  }

  Event? _selectedEvent;

  /// Gets a [Result.ok] holding a random event from `_events`.
  @override
  Future<Result<Event?>> get selectedEvent async {
    _selectedEvent = _events[Random().nextInt(_events.length)];
    return Result.ok(_selectedEvent);
  }

  @override
  Future<Result<bool>> setEvent(Event event) async {
    _selectedEvent = event;
    return const Result.ok(true);
  }
}
