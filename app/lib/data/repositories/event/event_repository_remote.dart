import 'dart:async';

import 'package:collection/collection.dart';

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
  Future<Result<List<Event>>> allEvents() async {
    // throw UnimplementedError();
    // throw UnimplementedError();

    // Result<List<Event>> success(Ok<List<Event>> eventsResult) {
    //   print('\t- In success()');
    //
    //   List<Event> apiEvents = eventsResult.value;
    //   print('\t\t- Got apiEvents: $apiEvents');
    //
    //   // 3. If _events != apiEvents, set _events to the new list.
    //   if (!ListEquality().equals(_events, apiEvents)) {
    //     print(
    //       '\t\t- _events != apiEvents\n'
    //       '\t\t\t_events: $_events,\n'
    //       '\t\t\tapiEvents: $apiEvents',
    //     );
    //     // If an event is in _events but not apiEvents, remove it from _events.
    //     for (Event currentEvent in List.from(_events)) {
    //       if (!apiEvents.contains(currentEvent)) {
    //         _events.remove(currentEvent);
    //       }
    //     }
    //
    //     // If an event is in apiEvents but not _events, add it to _events.
    //     for (Event apiEvent in apiEvents) {
    //       if (!_events.contains(apiEvent)) {
    //         _events.add(apiEvent);
    //       }
    //     }
    //   } else {
    //     print('\t\t- _events == apiEvents');
    //   }
    //
    //   print('\t\t- Set repository _events to $_events');
    //
    //   return Result.ok(_events);
    // }

    print('\nIn EventRepositoryRemote.allEvents');

    // 1. If not already initialised, initialise the repository to default events.
    if (!_isInitialised) {
      _events.addAll(Defaults.events);
      _isInitialised = true;
    }

    print('Getting events');
    // // 2. Get the latest event list from the _apiClient.
    Result<List<Event>> eventsResult;
    try {
      eventsResult = await _apiClient.requestEvents;
    } on Exception catch (e) {
      print('\n!! Caught exception when calling _apiClient.requestEvents: $e');
      eventsResult = Result.error(e);
    }
    // Result<List<Event>> eventsResult = await _apiClient.events(
    //   // onUpdate: (List<Event> newEvents) => updateEvents(newEvents),
    //   onUpdate: (List<Event> newEvents) => updateEvents,
    //   eventsCallback: eventsList,
    // );
    // print('eventsResult in EventRepositoryRemote.allEvents: $eventsResult');
    // print(
    //   '- Returned to EventRepositoryRemote.allEvents: got eventsResult (${eventsResult.runtimeType})',
    // );

    // switch (eventsResult) {
    //   case Ok<List<Event>> _:
    //     return eventsResult;
    //   // return success(eventsResult);
    //   // List<Event> events = eventsResult.value;
    //   // for (Event event in events) {
    //   //   if (!_events.contains(event)) {
    //   //     _events.add(event);
    //   //   }
    //   // }
    //   //
    //   // print('_events: $_events');
    //   // // return Result.ok(_events);
    //   // return eventsResult;
    //
    //   case Error<List<Event>> _:
    //     return eventsResult;
    // }
    //
    //// // TODO remove commented code
    return eventsResult;

    // // _events.addAll(iterable);
    // // return events;
    // // return Result.ok(_events);

    // return eventsResult;
    // return Result.ok(_events);
  }

  final ApiClient _apiClient;

  Future<void> createEvent({required String address, required NOC noc}) async {
    // FIXME add call to _apiClient to add the new event on the remote end.
    _events.add(Event.withNOC(id: _sequentialId++, address: address, noc: noc));
  }

  @override
  Future<Result<Event>> eventByID(int id) async {
    // // TODO get events from apiClient and use the result to update _events.
    _apiClient.requestEvents;

    final event = _events.where((event) => event.id == id).firstOrNull;
    if (event == null) {
      return Result.error(Exception('Booking not found'));
    }
    return Result.ok(event);
  }

  final _events = List<Event>.empty(growable: true);

  // Future<Result<List<Event>>> get events async {
  //   print('\nIn EventRepositoryRemote.events');
  //
  //   // 1. If not already initialised, initialise the repository to default events.
  //   if (!_isInitialised) {
  //     _events.addAll(Defaults.events);
  //     _isInitialised = true;
  //   }
  //
  //   // 2. Get the latest event list from the _apiClient.
  //   Result<List<Event>> eventsResult = await _apiClient.events;
  //   print(
  //     '- Returned to EventRepositoryRemote.allEvents: got eventsResult (${eventsResult.runtimeType})',
  //   );
  //
  //   return eventsResult;
  // }

  List<Event> get events => _events;

  // /// Sets the events list to a list of events from an API.
  // set events(List<Event> apiEvents) {
  //   // If _events != apiEvents, set _events to the new list.
  //   if (!ListEquality().equals(_events, apiEvents)) {
  //     print(
  //       '\t\t- _events != apiEvents\n'
  //       '\t\t\t_events: $_events,\n'
  //       '\t\t\tapiEvents: $apiEvents',
  //     );
  //     // If an event is in _events but not apiEvents, remove it from _events.
  //     for (Event currentEvent in List.from(_events)) {
  //       if (!apiEvents.contains(currentEvent)) {
  //         _events.remove(currentEvent);
  //       }
  //     }
  //
  //     // If an event is in apiEvents but not _events, add it to _events.
  //     for (Event apiEvent in apiEvents) {
  //       if (!_events.contains(apiEvent)) {
  //         _events.add(apiEvent);
  //       }
  //     }
  //
  //     print('- EventRepositoryRemote._events set to $_events by setter.');
  //   } else {
  //     print('\t\t- _events == apiEvents');
  //   }
  // }

  List<Event> eventsList() => _events;

  // /// Gets the `Event`s from the [apiClient] as a `Stream<Event>`.
  // Stream<Event> get eventsStream {
  //   return _apiClient.stream.cast<Event>();
  //
  //   // // TODO remove broken StreamTransformer
  //   // StreamTransformer<Object, Event> streamTransformer =
  //   //     StreamTransformer<Object, Event>(
  //   //       (Stream<Object> objectStream, bool cancelOnError) =>
  //   //           // objectStream.listen((Object object) {
  //   //           //       if (object is Event) {
  //   //           //         return object as Event;
  //   //           //       } else {}
  //   //           //     })
  //   //           //     as StreamSubscription<Event>,
  //   //           objectStream
  //   //               .where((Object object) => object is Event)
  //   //               .cast<Event>()
  //   //               .listen((Event event) => _events.add(event)),
  //   //     );
  //   // return streamTransformer.bind(_apiClient.stream);
  // }

  // Only create default event once.
  bool _isInitialised = false;

  // Used to generate IDs for events.
  int _sequentialId = 0;

  @override
  EventUpdateCallback updateEvents(List<Event> apiEvents) => (apiEvents) {
    print('Running updateEvents (onUpdate callback) with apiEvents');

    // If _events != apiEvents, set _events to the new list.
    if (!ListEquality().equals(_events, apiEvents)) {
      print(
        '\t\t- _events != apiEvents\n'
        '\t\t\t_events: $_events,\n'
        '\t\t\tapiEvents: $apiEvents',
      );
      // If an event is in _events but not apiEvents, remove it from _events.
      for (Event currentEvent in List.from(_events)) {
        if (!apiEvents.contains(currentEvent)) {
          _events.remove(currentEvent);
        }
      }

      // If an event is in apiEvents but not _events, add it to _events.
      for (Event apiEvent in apiEvents) {
        if (!_events.contains(apiEvent)) {
          _events.add(apiEvent);
        }
      }
    } else {
      print('\t\t- _events == apiEvents');
    }

    print('EventRepositoryRemote._events after updateEvents: $_events');
  };
}
