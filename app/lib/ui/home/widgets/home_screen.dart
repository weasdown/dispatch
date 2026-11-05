import 'package:dispatch/data/repositories/event/event_repository.dart';
import 'package:flutter/scheduler.dart';
import 'package:logging/logging.dart';
import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

import '../../../data/repositories/unit/unit_repository.dart';
import '../../../domain/models/event/category.dart';
import '../../../domain/models/event/event.dart';
import '../../../domain/models/unit/unit.dart';
import '../../../utils/result.dart';
import '../../events/priority_colour.dart';
import '../../events/view_models/all_events_view_model.dart';
import '../../events/view_models/single_event_screen_viewmodel.dart';
import '../../events/widgets/single_event_screen.dart';
import '../../map/view_models/map_view_model.dart';
import '../../map/widgets/map.dart';
import '../../unit/view_models/units_view_model.dart';
import '../view_models/home_viewmodel.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.homeViewModel});

  // final AllEventsViewModel allEventsViewModel;

  final HomeViewModel homeViewModel;

  // final AllEventsViewModel eventsViewModel;

  // final MapViewModel mapViewModel;

  // final SingleEventScreenViewModel singleEventScreenViewModel;

  // final UnitsViewModel unitsViewModel;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Logger _log = Logger('HomeScreen');

  // When a new C1/L1 event is received, it will be sent over the homeViewModel's newC1L1Stream.
  // When a new event is received from the stream, show a snackbar with a button to select the event.
  void _onNewC1L1({
    required Event newC1L1,
    required AllEventsViewModel allEventsViewModel,
    required SingleEventScreenViewModel singleEventScreenViewModel,
  }) {
    SchedulerBinding.instance.addPostFrameCallback(
      (_) => ScaffoldMessenger.of(context).showSnackBar(
        C1L1PurpleBanner(
          newC1L1: newC1L1,
          context: context,
          eventsViewModel: allEventsViewModel,
          singleEventScreenViewModel: singleEventScreenViewModel,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    hierarchicalLoggingEnabled = true;

    final eventRepository = context.read<EventRepository>();
    final unitRepository = context.read<UnitRepository>();

    final eventsViewModel = AllEventsViewModel(
      eventRepository: eventRepository,
    );
    final mapViewModel = MapViewModel(
      eventRepository: eventRepository,
      unitRepository: unitRepository,
    );
    final singleEventScreenViewModel = SingleEventScreenViewModel(
      eventRepository: eventRepository,
      unitRepository: unitRepository,
    );
    final unitsViewModel = UnitsViewModel(unitRepository: unitRepository);

    return ListenableBuilder(
      listenable: Listenable.merge([
        singleEventScreenViewModel.load,
        eventsViewModel.loadEvents,
      ]),
      builder: (context, child) {
        if (singleEventScreenViewModel.load.running ||
            eventsViewModel.loadEvents.running) {
          _log.finer('HomeScreen viewModels are still loading...');
          return const Center(child: CircularProgressIndicator());
        }

        if (singleEventScreenViewModel.load.error ||
            eventsViewModel.loadEvents.error) {
          _log.finer('HomeScreen viewModel(s) received an error');
          return _HomeErrorDisplay(
            eventsResult:
                eventsViewModel.loadEvents.result as Result<List<Event>>,
            unitsResult: unitsViewModel.loadUnits.result as Result<List<Unit>>,
          );
        } else {
          _log.finer('HomeScreen viewModels successfully completed loading');
          return child!;
        }
      },
      child: Scaffold(
        body: StreamBuilder(
          stream: widget.homeViewModel.newC1L1Stream,
          builder: (BuildContext context, AsyncSnapshot<Event> snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data == null) {
                _log.severe('Received null C1/L1 event from stream');
              }
              final Event newC1L1 = snapshot.data!;
              _log.warning(
                'Received new C1 ${newC1L1.idLastFour}! Showing purple banner',
              );
              _onNewC1L1(
                newC1L1: newC1L1,
                allEventsViewModel: eventsViewModel,
                singleEventScreenViewModel: singleEventScreenViewModel,
              );
            }

            final Ok<List<Event>> eventsResult =
                eventsViewModel.loadEvents.result as Ok<List<Event>>;
            final Ok<List<Unit>> unitsResult =
                unitsViewModel.loadUnits.result as Ok<List<Unit>>;

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
                //   child: AllEventsScreen(viewModel: widget.allEventsViewModel),
                // ),
                // Flexible(
                //   flex: 1,
                //   child: AllUnitsScreen(viewModel: widget.unitsViewModel),
                // ),
              ],
            );
          },
        ),
      ),
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
