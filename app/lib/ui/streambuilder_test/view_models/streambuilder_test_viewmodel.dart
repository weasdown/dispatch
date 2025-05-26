import 'package:flutter/material.dart';

import '../../../data/repositories/event/event_repository.dart';
import '../../../domain/models/event/category_colour.dart';
import '../../../domain/models/event/event.dart';
import '../../../utils/result.dart';

// TODO remove this file and streambuilder_test_screen.dart

class StreamBuilderTestViewModel extends ChangeNotifier {
  StreamBuilderTestViewModel({required EventRepository eventRepository})
    : _eventRepository = eventRepository {
    _load();
  }

  final EventRepository _eventRepository;

  List<Event> _events = [];

  Widget eventTile(Event singleEvent) => Card(
    color: singleEvent.category.colour,
    child: ListTile(
      leading: SelectableText(
        singleEvent.category.toString(),
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
      title: SelectableText('${singleEvent.id} - ${singleEvent.address}'),
      subtitle: SelectableText(singleEvent.status.toString()),
    ),
  );

  List<Event> get events => _events;

  List<Widget> get eventTiles =>
      List<Widget>.from(_events.map((Event event) => eventTile(event)));

  Future<Result> _load() async {
    try {
      final result = await _eventRepository.allEvents;
      switch (result) {
        case Ok<List<Event>>():
          _events = result.value;
          // _log.fine('Loaded bookings');
          return Result.ok(_events);
        case Error<List<Event>>():
          // _log.warning('Failed to load bookings', result.error);
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
    } finally {
      notifyListeners();
    }
  }
}
