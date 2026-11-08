import 'package:flutter/scheduler.dart';
import 'package:logging/logging.dart';
import 'package:material_ui/material_ui.dart';

import '../../../domain/models/event/event.dart';
import '../../../domain/models/unit/unit.dart';
import '../../../utils/result.dart';
import '../../events/view_models/all_events_view_model.dart';
import '../../events/view_models/single_event_screen_viewmodel.dart';
import '../../events/widgets/single_event_screen.dart';
import '../../map/view_models/map_view_model.dart';
import '../../map/widgets/map.dart';
import '../../unit/view_models/units_view_model.dart';
import '../view_models/home_viewmodel.dart';
import 'c1_l1_purple_banner.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    required this.homeViewModel,
    required this.eventsViewModel,
    required this.mapViewModel,
    required this.singleEventScreenViewModel,
    required this.unitsViewModel,
    required this.contextMenuController,
  });

  final ContextMenuController contextMenuController;

  final AllEventsViewModel eventsViewModel;
  final HomeViewModel homeViewModel;
  final MapViewModel mapViewModel;
  final SingleEventScreenViewModel singleEventScreenViewModel;
  final UnitsViewModel unitsViewModel;

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
          newC1L1: widget.homeViewModel.events
              .where((Event event) => event == newC1L1)
              .firstOrNull!,
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

    return ListenableBuilder(
      listenable: Listenable.merge([
        // FIXME convert these and other listenables like them in _HomeScreenState to use widget.homeViewModel
        widget.homeViewModel.load,
        // widget.eventsViewModel.loadEvents,
      ]),
      builder: (context, child) {
        if (widget.singleEventScreenViewModel.load.running ||
            widget.eventsViewModel.loadEvents.running) {
          _log.finer('HomeScreen viewModels are still loading...');
          return const Center(child: CircularProgressIndicator());
        }

        if (widget.singleEventScreenViewModel.load.error ||
            widget.eventsViewModel.loadEvents.error) {
          _log.finer('HomeScreen viewModel(s) received an error');
          return _HomeErrorDisplay(
            eventsResult:
                widget.eventsViewModel.loadEvents.result as Result<List<Event>>,
            unitsResult:
                widget.unitsViewModel.loadUnits.result as Result<List<Unit>>,
          );
        } else {
          _log.finer('HomeScreen viewModels successfully completed loading');
          return child!;
        }
      },
      child: Scaffold(
        // TODO remove listening to updated events - can be handled in MapPage, SingleEventScreen etc.
        // Rebuild when any event is updated.
        body: ListenableBuilder(
          listenable: widget.homeViewModel.getUpdatedEvent,
          builder: (BuildContext context, Widget? child) {
            // builder: (BuildContext context, AsyncSnapshot<EventID> snapshot) {
            // if (snapshot.hasData) {
            //   final EventID updatedID = snapshot.data!;
            //   _log.fine('Update available for event ${updatedID.lastFour}');
            // }

            // Rebuild when any new event is received.
            return StreamBuilder<Event>(
              stream: widget.homeViewModel.newEventStream,
              builder: (BuildContext context, AsyncSnapshot<Event> snapshot) {
                if (snapshot.hasData) {
                  final Event newEvent = snapshot.data!;
                  _log.fine(
                    'Got new event: ${newEvent.idLastFour}, ${newEvent.status.description}',
                  );
                }

                // Show a purple banner when any new C1/L1 (Priority.zero) event is received.
                return StreamBuilder<Event>(
                  stream: widget.homeViewModel.newC1L1Stream,
                  builder: (BuildContext context, AsyncSnapshot<Event> snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data == null) {
                        _log.severe('Received null C1/L1 event from stream');
                      }
                      final Event newC1L1 = snapshot.data!;
                      _log.info(
                        'Received new C1 ${newC1L1.idLastFour}! Showing purple banner',
                      );
                      _onNewC1L1(
                        newC1L1: newC1L1,
                        allEventsViewModel: widget.eventsViewModel,
                        singleEventScreenViewModel:
                            widget.singleEventScreenViewModel,
                      );
                    }

                    // TODO convert this row of flexibles into tabs, with one tab being displayed on narrow screens, or two tabs side by side on laptop-sized screens.
                    return Row(
                      children: [
                        Flexible(
                          flex: 1,
                          child: MapPage(
                            mapViewModel: widget.mapViewModel,
                            events: widget.homeViewModel.events,
                            units: widget.homeViewModel.units,
                            contextMenuController: widget.contextMenuController,
                          ),
                        ),
                        VerticalDivider(width: 3, thickness: 3),
                        Flexible(
                          flex: 1,
                          child: ListenableBuilder(
                            listenable: widget.homeViewModel,
                            builder: (BuildContext context, Widget? child) =>
                                SingleEventScreen(
                                  viewModel: widget.singleEventScreenViewModel,
                                  homeViewModel: widget.homeViewModel,
                                ),
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
                );
              },
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
