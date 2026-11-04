import 'package:material_ui/material_ui.dart';

import '../../../data/repositories/event/event_repository.dart';
import '../../../domain/models/event/event.dart';
import '../../../utils/command.dart';
import '../../../utils/result.dart';

class HomeViewModel extends ChangeNotifier {
  HomeViewModel({required this._eventRepository}) {
    load = Command0(_load)..execute();
  }

  final EventRepository _eventRepository;

  List<Event> get events => _events;
  List<Event> _events = [];

  late final Command0<void> load;
  Future<Result<void>> _load() async {
    try {
      final result = await _eventRepository.allEvents;
      switch (result) {
        case Ok<List<Event>>():
          _events = result.value;
          return Result.ok(null);
        case Error<List<Event>>():
          return result;
      }
    } finally {
      notifyListeners();
    }
  }
}
