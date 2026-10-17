import '../../../../utils/result.dart';
import '../../../ui/single_event_screen/view_models/single_event_screen_viewmodel.dart';
import 'event_mode_repository.dart';

class EventModeRepositoryLocal implements EventModeRepository {
  EventMode _mode = EventMode.select;

  @override
  Future<Result<EventMode>> getEventMode() async => Result.ok(_mode);

  @override
  Future<Result<void>> updateEventMode(EventMode mode) async {
    _mode = mode;
    return Result.ok(null);
  }
}
