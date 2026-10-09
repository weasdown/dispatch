import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:logging/logging.dart';

import '../../../domain/models/event/event.dart';
import '../view_models/single_event_screen_viewmodel.dart';

class SingleEventScreen extends StatefulWidget {
  const SingleEventScreen({super.key, required this.viewModel});

  final SingleEventScreenViewModel viewModel;

  @override
  State<SingleEventScreen> createState() => _SingleEventScreenState();
}

class _SingleEventScreenState extends State<SingleEventScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: Text('Event'), toolbarHeight: 32),
      body: ListenableBuilder(
        listenable: widget.viewModel.load,
        builder: (context, child) {
          Event? event = widget.viewModel.event;

          return _SingleEvent(event: event);

          // // TODO move this if-else to _SingleEvent widget
          // // TODO consider invert if to have == null case first
          // if (event != null) {
          //   _log.info('Event selected at ${event.address}');
          //
          //   return Row(
          //     children: [
          //       Flexible(
          //         flex: 1,
          //         child: FutureBuilder(
          //           future: Future.wait([
          //             widget.viewModel.events,
          //             widget.viewModel.units,
          //           ]),
          //           builder:
          //               (
          //                 BuildContext context,
          //                 AsyncSnapshot<List<Result<List<Object>>>> snapshot,
          //               ) {
          //                 if (snapshot.connectionState ==
          //                     ConnectionState.done) {
          //                   Result<List<Event>> eventsResult =
          //                       snapshot.data![0] as Result<List<Event>>;
          //                   Result<List<Unit>> unitsResult =
          //                       snapshot.data![1] as Result<List<Unit>>;
          //
          //                   // FIXME stop assuming the Results are Oks - they may be Errors.
          //                   List<Event> allEvents =
          //                       (eventsResult as Ok<List<Event>>).value;
          //                   List<Unit> allUnits =
          //                       (unitsResult as Ok<List<Unit>>).value;
          //
          //                   final EventRepository eventRepository = context
          //                       .read();
          //                   final UnitRepository unitRepository = context
          //                       .read();
          //
          //                   return MapPage(
          //                     // viewModel: MapViewModel(
          //                     //   eventRepository: eventRepository,
          //                     //   unitRepository: unitRepository,
          //                     // ),
          //                     singleEventScreenViewModel:
          //                         SingleEventScreenViewModel(
          //                           eventRepository: eventRepository,
          //                           unitRepository: unitRepository,
          //                         ),
          //                     events: allEvents,
          //                     units: allUnits,
          //                   );
          //                 } else {
          //                   return CircularProgressIndicator();
          //                 }
          //               },
          //         ),
          //         // Align(
          //         //   alignment: AlignmentGeometry.center,
          //         //   child: FutureBuilder(
          //         //     future: widget.viewModel.events,
          //         //     builder:
          //         //         (
          //         //           BuildContext context,
          //         //           AsyncSnapshot<Result<List<Event>>> snapshot,
          //         //         ) {
          //         //           if (snapshot.connectionState ==
          //         //               ConnectionState.done) {
          //         //             final Result<List<Event>> eventsResult =
          //         //                 snapshot.data!;
          //         //
          //         //             return switch (eventsResult) {
          //         //               Ok<List<Event>> _ => GoogleMap(
          //         //                 initialCameraPosition: CameraPosition(
          //         //                   bearing: 192.8334901395799,
          //         //                   target: event.location != null
          //         //                       ? LatLng(event.lat, event.lng)
          //         //                       : LatLng(0, 0),
          //         //                   tilt: 59.440717697143555,
          //         //                   zoom: 19.151926040649414,
          //         //                 ),
          //         //                 onMapCreated:
          //         //                     (GoogleMapController controller) {
          //         //                       _controller.complete(controller);
          //         //                     },
          //         //                 markers: () {
          //         //                   List<Event> events = eventsResult.value;
          //         //                   Set<Marker> markers = events
          //         //                       .map((Event event) => event.mapMarker)
          //         //                       .toSet();
          //         //                   return markers;
          //         //                 }(),
          //         //               ),
          //         //               _ => ErrorWidget('Failed to load all events'),
          //         //             };
          //         //           } else {
          //         //             return CircularProgressIndicator();
          //         //           }
          //         //         },
          //         //   ),
          //         // ),
          //       ),
          //
          //       VerticalDivider(),
          //       // TODO make the below widget the actual contents of this build method. Move the overall layout part above to a home page or similar.
          //       // SingleEventScreen
          //       Flexible(
          //         flex: 1,
          //         child: Center(
          //           child: SizedBox.expand(
          //             child: Align(
          //               alignment: AlignmentGeometry.center,
          //               child: Padding(
          //                 padding: const EdgeInsets.symmetric(horizontal: 20.0),
          //                 child: Column(
          //                   crossAxisAlignment: CrossAxisAlignment.center,
          //                   children: [
          //                     overview,
          //                     const Gap(30),
          //                     location,
          //                     const Gap(30),
          //                     buttons,
          //                     const Gap(50),
          //                     patientDetails,
          //                   ],
          //                 ),
          //               ),
          //             ),
          //           ),
          //         ),
          //       ),
          //     ],
          //   );
          // } else {
          //   _log.warning('There is no selected event');
          //   return Center(
          //     child: Text(
          //       'No event selected',
          //       textAlign: TextAlign.center,
          //       style: Theme.of(context).textTheme.headlineSmall,
          //     ),
          //   );
          // }
        },
      ),
    );
  }
}

class _SingleEvent extends StatelessWidget {
  const _SingleEvent({required this.event});

  final Event? event;

  @override
  Widget build(BuildContext context) {
    final Logger log = Logger('_SingleEvent');

    return (event == null)
        ? _NullEvent(event: event, log: log)
        : Flexible(
            flex: 1,
            child: Center(
              child: SizedBox.expand(
                child: Align(
                  alignment: AlignmentGeometry.center,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _Overview(event: event),
                        const Gap(30),
                        _Location(event: event),
                        const Gap(30),
                        _Buttons(event: event),
                        const Gap(50),
                        _PatientDetails(event: event),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ); // event != null
  }
}

class _Buttons extends StatelessWidget {
  const _Buttons({required this.event});

  final Event? event;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          style: ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(Colors.red),
          ),
          onPressed: () => debugPrint('Find AED'),
          child: Text(
            'Find AED',
            style: Theme.of(context).textTheme.bodyMedium!
                .copyWith(color: Colors.white),
          ),
        ),
      ],
    );
  }
}

class _Location extends StatelessWidget {
  const _Location({required this.event});

  final Event? event;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(event!.address, style: Theme.of(context).textTheme.headlineSmall),
      ],
    );
  }
}

class _NullEvent extends StatelessWidget {
  const _NullEvent({required this.event, required this.log});

  final Event? event;
  final Logger log;

  @override
  Widget build(BuildContext context) {
    log.warning('There is no selected event');
    return Center(
      child: Text(
        'No event selected',
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.headlineSmall,
      ),
    );
  }
}

class _Overview extends StatelessWidget {
  const _Overview({required this.event});

  final Event? event;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Table(
        children: [
          TableRow(
            children: [
              Text(
                (event!.noc != null)
                    ? '${event!.category.toString()}: ${event!.noc!.description}'
                    : event!.status.toString(),
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PatientDetails extends StatelessWidget {
  const _PatientDetails({required this.event});

  final Event? event;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(border: Border.all()),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text('Patient details...\n\nTBC', textAlign: TextAlign.center),
      ),
    );
  }
}
