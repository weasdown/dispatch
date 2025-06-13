import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

import '../../../data/repositories/event/event_repository.dart';
import '../../../domain/models/event/event.dart';
import '../../../utils/command.dart';
import '../../../utils/result.dart';

class SingleEventScreenViewModel extends ChangeNotifier {
  SingleEventScreenViewModel({required EventRepository eventRepository})
    : _eventRepository = eventRepository {
    load = Command0(_load)..execute();
  }

  final EventRepository _eventRepository;
  final _log = Logger('SingleEventScreenViewModel');

  late Command0 load;

  Event? _event;

  Event? get event => _event;

  Future<Result> _load() async {
    try {
      final result = await _eventRepository.selectedEvent;
      switch (result) {
        case Ok<Event?>():
          _event = result.value;
          _log.fine('Loaded event');
          return Result.ok(_event);
        case Error<Event?>():
          _log.warning('Failed to load event', result.error);
          return result;
      }
    } finally {
      notifyListeners();
    }
  }
}
