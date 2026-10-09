import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

import '../../../domain/models/event/event.dart';
import '../../../domain/models/unit/unit.dart';
import '../../../ui/map/widgets/map.dart';
import '../../../utils/result.dart';
import '../../single_event_screen/view_models/single_event_screen_viewmodel.dart';
import '../../single_event_screen/widgets/single_event_screen.dart';
import '../view_models/home_viewmodel.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
    required this.homeViewModel,
    required this.singleEventScreenViewModel,
  });

  final HomeViewModel homeViewModel;

  final SingleEventScreenViewModel singleEventScreenViewModel;

  @override
  Widget build(BuildContext context) {
    final Logger log = Logger('HomeScreen');

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

              final List<Event> allEvents = eventsResult.value;
              final List<Unit> allUnits = unitsResult.value;

              return Row(
                children: [
                  Flexible(
                    flex: 1,
                    child: MapPage(
                      singleEventScreenViewModel: singleEventScreenViewModel,
                      events: allEvents,
                      units: allUnits,
                    ),
                  ),
                  VerticalDivider(),
                  Flexible(
                    flex: 1,
                    child: SingleEventScreen(
                      viewModel: singleEventScreenViewModel,
                    ),
                  ),
                ],
              );
            }
            // snapshot is not done
            else {
              return Center(child: CircularProgressIndicator());
            }
          },
    );

    // // TODO remove commented code below to AllEventsScreen (not yet created)
    // return Scaffold(
    //   appBar: AppBar(
    //     title: Text(
    //       'Events',
    //       style: Theme.of(context).textTheme.headlineMedium,
    //     ),
    //   ),
    //   drawer: NavigationDrawer(
    //     children: [
    //       DrawerHeader(child: Text('Drawer Header')),
    //       Container(color: Colors.grey, child: Text('First item')),
    //     ],
    //   ),
    //   body: Center(
    //     child: Column(
    //       children: [
    //         ListenableBuilder(
    //           listenable: widget.viewModel,
    //           builder: (context, _) {
    //             debugPrint(
    //               'Number of events: ${widget.viewModel.events.length}',
    //             );
    //             return ListView(
    //               padding: EdgeInsets.symmetric(horizontal: 20),
    //               shrinkWrap: true,
    //               children: widget.viewModel.eventTiles,
    //             );
    //           },
    //         ),
    //       ],
    //     ),
    //   ),
    // );
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
