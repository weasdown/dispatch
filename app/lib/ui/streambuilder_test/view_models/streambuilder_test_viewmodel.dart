import 'package:flutter/material.dart';

import '../../../data/repositories/event/event_repository_remote.dart';
import '../../../domain/models/event/event.dart';
import '../../../utils/command.dart';
import '../../../utils/result.dart';

// TODO remove this file and streambuilder_test_screen.dart

class StreamBuilderTestViewModel extends ChangeNotifier {
  StreamBuilderTestViewModel({
    required EventRepositoryRemote eventRepository,
    required BuildContext context,
  }) : _events = [],
       _eventRepository = eventRepository {
    load = Command0(_load)..execute();
    // load = Command0<List<Event>>(_load)..execute();
    // _load(); // TODO remove commented line.
  }

  final EventRepositoryRemote _eventRepository;

  List<Event> _events;

  // Widget eventTile(Event singleEvent) => Card(
  //   color: singleEvent.category.colour,
  //   child: ListTile(
  //     leading: SelectableText(
  //       singleEvent.category.toString(),
  //       style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
  //     ),
  //     title: SelectableText('${singleEvent.id} - ${singleEvent.address}'),
  //     subtitle: SelectableText(singleEvent.status.toString()),
  //   ),
  // );

  // Stream<Event> get eventStream => _eventRepository.eventsStream;

  // Future<List<Event>> events() async {
  //   try {
  //     Result<List<Event>> eventsResult = await _eventRepository.allEvents();
  //     switch (eventsResult) {
  //       case Ok<List<Event>>():
  //         List<Event> events = eventsResult.value;
  //         _events = events;
  //         return eventsResult.value;
  //       case Error<List<Event>>():
  //         return Future.error(eventsResult.error);
  //     }
  //
  //     // return _events;
  //   } finally {
  //     // notifyListeners();
  //   }
  // }

  List<Event> get events => _events;

  // {
  //   // _eventRepository.events;
  //
  //   List<Event> events = [];
  //
  //   events = _eventRepository.allEvents().then(
  //     (Result<List<Event>> eventsResult) => switch (eventsResult) {
  //       // TODO: Handle this case.
  //       Ok<List<Event>>() => eventsResult.value,
  //
  //       Error<List<Event>>() => throw Exception(
  //         'Events were not properly loaded.',
  //       ),
  //     },
  //   );
  //
  //   return events;
  // }

  // List<Widget> get eventTiles =>
  //     List<Widget>.from(_events.map((Event event) => eventTile(event)));

  Future<Result<List<Event>>> _load() async {
    print('\nIn StreamBuilderTestViewModel._load()');
    try {
      final Result<List<Event>> result = await _eventRepository.allEvents();
      print(
        'result in StreamBuilderTestViewModel._load(): ${result.runtimeType}',
      );
      switch (result) {
        case Ok<List<Event>> _:
          print('result value: ${result.value}');
          // _events = result.value;
          updateEvents(result.value);
          print('\t- Set viewModel _events to ${_events.toString()}');
          // _log.fine('Loaded bookings');
          return result;
        // return Result.ok(_events);

        case Error<List<Event>> _:
          print('\t- !! Error result!');
          // _log.warning('Failed to load', result.error);
          return result;
      }

      // final userResult = await _userRepository.getUser();
      // switch (userResult) {
      //   case Ok<User>():
      //     _user = userResult.value;
      //     _log.fine('Loaded user');
      //   case Error<User>():
      //   // _log.warning('Failed to load user', userResult.error);
      // }
      //
      // return userResult;
    } on Exception catch (e) {
      print('!! Caught exception when calling _eventRepository.allEvents()');
      return Result.error(e);
    } finally {
      notifyListeners();
    }
  }

  late Command0<List<Event>> load;

  // void requestEvents() => _eventRepository.apiClient.requestEvents;

  void updateEvents(List<Event> newEvents) {
    print(
      '\n\t- Running StreamBuilderTestViewModel.updateEvents() with newEvents $newEvents\n',
    );
    _events = newEvents;
    notifyListeners();
  }
}
