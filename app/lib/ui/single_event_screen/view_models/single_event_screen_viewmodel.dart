import 'package:logging/logging.dart';
import 'package:material_ui/material_ui.dart';

import '../../../data/repositories/event/event_repository.dart';
import '../../../data/repositories/unit/unit_repository.dart';
import '../../../data/repositories/user/user_repository.dart';
import '../../../domain/models/event/event.dart';
import '../../../domain/models/event/remark.dart';
import '../../../domain/models/unit/unit.dart';
import '../../../domain/models/user/user.dart';
import '../../../utils/command.dart';
import '../../../utils/result.dart';

class SingleEventScreenViewModel extends ChangeNotifier {
  SingleEventScreenViewModel({
    required this._eventRepository,
    required this._unitRepository,
  }) {
    updateEvent = Command0(_updateEvent);
    load = Command0(_load)..execute();
  }

  Future<void> addRemark(UserRepository userRepository, String message) async {
    final Result<User> userResult = await userRepository.getUser();

    switch (userResult) {
      case Ok<User> _:
        final User user = userResult.value;
        _eventRepository.addRemark(Remark(author: user, message: message));
      case Error<User> _:
        throw userResult.error;
    }
  }

  final EventRepository _eventRepository;
  final UnitRepository _unitRepository;
  final Logger _log = Logger('SingleEventScreenViewModel');

  late Command0 load;

  Event? _event;

  Event? get event => _event;

  Future<Result<List<Event>>> get events => _eventRepository.allEvents;

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

  Future<Result<List<Unit>>> get units => _unitRepository.allUnits;

  late final Command0 updateEvent;

  Future<Result<void>> _updateEvent() async {
    final result = await _eventRepository.setEvent(_event!);
    switch (result) {
      case Ok<void>():
        _log.fine('Event updated');
      case Error<void>():
        _log.warning('Failed to update Event', result.error);
    }
    return result;
  }
}
