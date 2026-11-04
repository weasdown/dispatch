import 'package:dispatch/ui/map/view_models/map_view_model.dart';
import 'package:logging/logging.dart';
import 'package:material_ui/material_ui.dart';

import '../../../domain/models/event/event.dart';
import '../../../domain/models/unit/unit.dart';
import '../../../utils/result.dart';
import '../../events/priority_colour.dart';
import '../../events/view_models/all_events_view_model.dart';
import '../../events/view_models/single_event_screen_viewmodel.dart';
import '../../events/widgets/single_event_screen.dart';
import '../../map/widgets/map.dart';
import '../../unit/view_models/units_view_model.dart';
import '../view_models/home_viewmodel.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
    required this.homeViewModel,
    required this.eventsViewModel,
    required this.singleEventScreenViewModel,
    required this.mapViewModel,
    required this.allEventsViewModel,
    required this.unitsViewModel,
  });

  final AllEventsViewModel allEventsViewModel;

  final HomeViewModel homeViewModel;

  final AllEventsViewModel eventsViewModel;

  final MapViewModel mapViewModel;

  final SingleEventScreenViewModel singleEventScreenViewModel;

  final UnitsViewModel unitsViewModel;

  @override
  Widget build(BuildContext context) {
    final Logger log = Logger('HomeScreen');
    hierarchicalLoggingEnabled = true;

    // FIXME use ListenableBuilder instead of FutureBuilder (e.g. see AllUnitsScreen)
    return FutureBuilder(
      future: Future.wait([
        singleEventScreenViewModel.events,
        singleEventScreenViewModel.units,
      ]),
      builder:
          (
            BuildContext context,
            AsyncSnapshot<List<Result<List<Object>>>> snapshot,
          ) {
            if (snapshot.connectionState == ConnectionState.done) {
              final Result<List<Event>> eventsResult =
                  snapshot.data![0] as Result<List<Event>>;
              final Result<List<Unit>> unitsResult =
                  snapshot.data![1] as Result<List<Unit>>;

              // Events and units loaded successfully.
              if (eventsResult is! Ok<List<Event>> ||
                  unitsResult is! Ok<List<Unit>>) {
                return _HomeErrorDisplay(
                  eventsResult: eventsResult,
                  unitsResult: unitsResult,
                );
              }

              log.fine('Events and units loaded successfully');

              // TODO convert this row of flexibles into tabs, with one tab being displayed on narrow screens, or two tabs side by side on laptop-sized screens.
              return Row(
                children: [
                  Flexible(
                    flex: 1,
                    child: MapPage(
                      mapViewModel: mapViewModel,
                      eventsViewModel: eventsViewModel,
                      singleEventScreenViewModel: singleEventScreenViewModel,
                      unitsViewModel: unitsViewModel,
                      events: eventsResult.value,
                      units: unitsResult.value,
                    ),
                  ),
                  VerticalDivider(width: 3, thickness: 3),
                  Flexible(
                    flex: 1,
                    child: SingleEventScreen(
                      viewModel: singleEventScreenViewModel,
                    ),
                  ),
                  // Flexible(
                  //   flex: 1,
                  //   child: AllEventsScreen(viewModel: allEventsViewModel),
                  // ),
                  // Flexible(
                  //   flex: 1,
                  //   child: AllUnitsScreen(viewModel: unitsViewModel),
                  // ),
                ],
              );
            }
            // snapshot is not done
            else {
              return Center(child: CircularProgressIndicator());
            }
          },
    );
  }
}

class _HomeErrorDisplay extends StatelessWidget {
  const _HomeErrorDisplay({
    required this.eventsResult,
    required this.unitsResult,
  });

  final Result<List<Event>> eventsResult;
  final Result<List<Unit>> unitsResult;

  @override
  Widget build(BuildContext context) {
    late final String message;
    late final Exception error;

    switch ((eventsResult, unitsResult)) {
      case (Error<List<Event>> _, Error<List<Unit>> _):
        message = 'Failed to load both events and units! ';
        final Exception eventsError =
            (eventsResult as Error<List<Event>>).error;
        final Exception unitsError = (unitsResult as Error<List<Unit>>).error;
        error = Exception(
          'Events error: ${eventsError.toString()}\nUnits error: ${unitsError.toString()}',
        );

      case (Ok<List<Event>> _, _):
        message = 'Failed to load events! ';
        error = (eventsResult as Error<List<Event>>).error;

      case (_, Ok<List<Unit>> _):
        message = 'Failed to load units! ';
        error = (unitsResult as Error<List<Unit>>).error;
    }

    return ErrorWidget.withDetails(
      message: message,
      error: FlutterError(error.toString()),
    );
  }
}

/// A purple snackbar that's displayed when a new C1/L1 event is received from the [HomeViewModel.newC1L1Stream].
class C1L1PurpleBanner extends SnackBar {
  C1L1PurpleBanner({
    super.key,
    required BuildContext context,
    required AllEventsViewModel eventsViewModel,
    required SingleEventScreenViewModel singleEventScreenViewModel,
    required Event newC1L1,
  }) : super(
         content: Text(
           'New C1/L1: ${newC1L1.idLastFour}',
           style: Theme.of(context).textTheme.bodyLarge!
               .copyWith(color: _textColour),
         ),
         backgroundColor: Category.one.priority.backgroundColour,
         showCloseIcon: true,
         persist: true,
         action: SnackBarAction(
           label: 'Show event',
           textColor: _textColour,
           onPressed: () {
             (Logger('C1L1PurpleBanner')..level = Level.ALL).fine(
               'Selecting new C1/L1 ${newC1L1.idLastFour} from snackbar',
             );
             eventsViewModel.selectEvent.execute(newC1L1);
             singleEventScreenViewModel.displayEvent.execute(newC1L1);
           },
         ),
       );

  static final Color _textColour = Colors.white;
}
