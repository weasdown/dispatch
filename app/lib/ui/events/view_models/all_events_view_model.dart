import 'package:material_ui/material_ui.dart';
import 'package:logging/logging.dart';

import '../../../data/repositories/event/event_repository.dart';
import '../../../domain/models/event/event.dart';
import '../../../utils/command.dart';
import '../../../utils/result.dart';

class AllEventsViewModel extends ChangeNotifier {
  AllEventsViewModel({required this._eventRepository}) {
    selectEvent = Command1<void, Event>(_selectEvent);
    loadEvents = Command0<List<Event>>(_loadEvents)..execute();
  }

  final EventRepository _eventRepository;

  List<Event> get events => _events;
  List<Event> _events = [];

  late final Command0<void> loadEvents;
  Future<Result<List<Event>>> _loadEvents() async {
    try {
      final allEventsResult = await _eventRepository.allEvents;

      switch (allEventsResult) {
        case Ok<List<Event>> _:
          _events = allEventsResult.value;
          _log.fine('Loaded events');
          return Result.ok(_events);

        case Error<List<Event>> _:
          _log.warning('Failed to load events', allEventsResult.error);
          return allEventsResult;
      }
    } finally {
      notifyListeners();
    }
  }

  final Logger _log = Logger('AllEventsVewModel')..level = Level.ALL;

  late final Command1<void, Event> selectEvent;
  Future<Result<void>> _selectEvent(Event eventToSelect) {
    _log.fine('Selecting event ${eventToSelect.idLastFour}');
    final result = _eventRepository.selectEvent(eventToSelect);
    notifyListeners();
    return result;
  }
}
