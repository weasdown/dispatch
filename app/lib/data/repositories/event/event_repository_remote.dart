import 'dart:async';

import '../../../domain/models/event/event.dart';
import '../../../domain/models/status.dart';
import '../../../utils/result.dart';
import '../../defaults.dart';
import '../../services/api/api_client.dart';
import 'event_repository.dart';

/// Local implementation of EventRepository
class EventRepositoryRemote extends EventRepository {
  EventRepositoryRemote({required ApiClient apiClient})
    : _apiClient = apiClient;

  @override
  Future<Result<List<Event>>> get allEvents => eventsList;

  final ApiClient _apiClient;

  Future<void> createEvent({required String address, required NOC noc}) async {
    _events.add(
      Event.withNOC(
        id: (_sequentialId++).toString(),
        address: address,
        noc: noc,
      ),
    );
  }

  @override
  Future<Result<Event>> eventByID(String id) async {
    // // TODO get events from apiClient and use the result to update _events.
    // apiClient.requestEvents;

    final event = _events.where((event) => event.id == id).firstOrNull;
    if (event == null) {
      return Result.error(Exception('Booking not found'));
    }
    return Result.ok(event);
  }

  final _events = List<Event>.empty(growable: true);

  /// Gets the `Event`s from the [apiClient] as a
  Stream<Event> get eventsStream {
    return _apiClient.stream.cast<Event>();

    // // TODO remove broken StreamTransformer
    // StreamTransformer<Object, Event> streamTransformer =
    //     StreamTransformer<Object, Event>(
    //       (Stream<Object> objectStream, bool cancelOnError) =>
    //           // objectStream.listen((Object object) {
    //           //       if (object is Event) {
    //           //         return object as Event;
    //           //       } else {}
    //           //     })
    //           //     as StreamSubscription<Event>,
    //           objectStream
    //               .where((Object object) => object is Event)
    //               .cast<Event>()
    //               .listen((Event event) => _events.add(event)),
    //     );
    // return streamTransformer.bind(_apiClient.stream);
  }

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
