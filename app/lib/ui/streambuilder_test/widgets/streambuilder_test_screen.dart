import 'package:flutter/material.dart';

import '../../../domain/models/event/category_colour.dart';
import '../../../domain/models/event/event.dart';
import '../../../utils/command.dart';
import '../../../utils/result.dart';
import '../view_models/streambuilder_test_viewmodel.dart';

// TODO remove this file and streambuilder_test_viewmodel.dart

class StreamBuilderTestScreen extends StatefulWidget {
  const StreamBuilderTestScreen({super.key, required this.viewModel});

  final StreamBuilderTestViewModel viewModel;

  final bool detailed = true;

  @override
  State<StreamBuilderTestScreen> createState() =>
      _StreamBuilderTestScreenState();
}

class _StreamBuilderTestScreenState extends State<StreamBuilderTestScreen> {
  // TODO remove initState
  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   widget.viewModel.requestEvents;
  // }

  // late Stream eventStream;
  //
  // @override
  // void initState() {
  //   // TODO: implement initState
  //   eventStream = widget.viewModel.load.;
  //   super.initState();
  // }

  // Widget onConnected(ApiClient client, WebSocketChannel channel) {
  //   client.requestEvents;
  //
  //   Widget active(Map<String, List> data) {
  //     // TODO remove all prints from file
  //     // print('In active');
  //     List<Map<String, dynamic>> eventsJsons = data['events']!
  //         .cast<Map<String, dynamic>>();
  //
  //     List<Widget> eventTiles() {
  //       List<Event> events = List<Event>.from(
  //         eventsJsons.map((Map<String, dynamic> eventMap) {
  //           return Event.fromJson(eventMap);
  //         }),
  //       );
  //
  //       Widget cardForEvent(Event event) => Card(
  //         color: event.category.colour,
  //         child: ListTile(
  //           title: Text(event.category.toString()),
  //           subtitle: Text(event.id.toString()),
  //           trailing: Text(event.assignedCallsigns.join(', ')),
  //         ),
  //       );
  //
  //       return List<Widget>.from(
  //         events.map((Event event) => cardForEvent(event)),
  //       );
  //     }
  //
  //     // List<Future<Widget>> eventTiles() {
  //     //   List<Future<Event>> events = List<Future<Event>>.from(
  //     //     eventsJsons.map((Map<String, dynamic> eventMap) async {
  //     //       return await Event.fromJson(eventMap, client);
  //     //     }),
  //     //   );
  //     //
  //     //   return List<Future<Widget>>.from(
  //     //     events.map((Future<Event> eventFuture) async {
  //     //       Event event = await eventFuture;
  //     //       return Card(
  //     //         color: event.category.colour,
  //     //         child: ListTile(
  //     //           title: Text(event.category.toString()),
  //     //           subtitle: Text(event.id.toString()),
  //     //           trailing: Text(event.assignedUnits.join(', ')),
  //     //         ),
  //     //       );
  //     //     }),
  //     //   );
  //     // }
  //
  //     return ListView(
  //       children: eventTiles(),
  //       // List<Widget>.from(
  //       //   snapshot.data as List<Widget>,
  //       //   // eventTiles().map(
  //       //   //   (Future<Widget> futureWidget) async => await futureWidget,
  //       //   // ),
  //       // ),
  //     );
  //
  //     // return FutureBuilder(
  //     //   future: eventTiles(),
  //     //   builder: (context, snapshot) {
  //     //     // print('In eventTiles() FB');
  //     //     return switch (snapshot.connectionState) {
  //     //       ConnectionState.none => Text(
  //     //         'None while building from eventTiles()',
  //     //       ),
  //     //
  //     //       ConnectionState.waiting => Column(
  //     //         children: [
  //     //           Text('Building from eventTiles()'),
  //     //           const SizedBox(height: 30),
  //     //           CircularProgressIndicator(),
  //     //         ],
  //     //       ),
  //     //
  //     //       ConnectionState.active => Text('Active'),
  //     //
  //     //       //     ListView(
  //     //       //   children: List<Widget>.from(
  //     //       //     snapshot.data as List<Widget>,
  //     //       //     // eventTiles().map(
  //     //       //     //   (Future<Widget> futureWidget) async => await futureWidget,
  //     //       //     // ),
  //     //       //   ),
  //     //       // ),
  //     //       ConnectionState.done => () {
  //     //         //     ListView(
  //     //         //   children: List<Widget>.from(
  //     //         //     snapshot.data as List<Widget>,
  //     //         //     // eventTiles().map(
  //     //         //     //   (Future<Widget> futureWidget) async => await futureWidget,
  //     //         //     // ),
  //     //         //   ),
  //     //         // ),
  //     //         // print('snapshot.data after eventTiles(): ${snapshot.data}');
  //     //         return Text('Done while building from eventTiles()');
  //     //       }(),
  //     //     };
  //     //   },
  //     // );
  //   }
  //
  //   return StreamBuilder(
  //     // stream: widget.viewModel.eventStream,
  //     stream: channel.stream,
  //     builder: (context, snapshot) {
  //       // TODO remove prints
  //       // debugPrint('snapshot.data: ${snapshot.data}');
  //       // debugPrint(
  //       //   '\t- SB snapshot.connectionState: ${snapshot.connectionState}',
  //       // );
  //
  //       return switch (snapshot.connectionState) {
  //         ConnectionState.none => Text('None'),
  //         ConnectionState.waiting => Column(
  //           children: [
  //             Text('Loading stream...'),
  //             const SizedBox(height: 30),
  //             CircularProgressIndicator(),
  //           ],
  //         ),
  //         ConnectionState.active => () {
  //           Map<String, dynamic> streamData =
  //               jsonDecode(snapshot.data) as Map<String, dynamic>;
  //           // print('streamData: $streamData');
  //           // print('Inner FB being called');
  //           return active(streamData.cast<String, List>());
  //
  //           // return FutureBuilder(
  //           //   future: active(streamData.cast<String, List>()),
  //           //   builder: (context, fbSnapshot) {
  //           //     return switch (fbSnapshot.connectionState) {
  //           //       ConnectionState.none => Text('None'),
  //           //       ConnectionState.waiting => CircularProgressIndicator(),
  //           //       ConnectionState.active => Text('Active'),
  //           //       // TODO: Handle this case.
  //           //       ConnectionState.done => () {
  //           //         print('streamData: $streamData');
  //           //         print('fbSnapshot.data: ${fbSnapshot.data}');
  //           //         // return Text('Done');
  //           //         return (fbSnapshot.data as Widget);
  //           //       }(),
  //           //     };
  //           //   },
  //           // );
  //         }(),
  //         ConnectionState.done => Text('Done'),
  //       };
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    final Command0<List<Event>> loader = widget.viewModel.load;

    Widget displayWidget(List<Event> events) {
      print('events in displayWidget: $events');
      return events.isEmpty
          ? Text(
              'No events to display!',
              style: Theme.of(context).textTheme.headlineSmall,
            )
          : ListView.builder(
              itemCount: events.length,
              itemBuilder: (_, int index) => _EventTile(event: events[index]),
            );
    }

    Command0<List<Event>> load = widget.viewModel.load;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'StreamBuilder test',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
      drawer: NavigationDrawer(
        children: [
          DrawerHeader(child: Text('Drawer Header')),
          Container(color: Colors.grey, child: Text('First item')),
        ],
      ),
      body: Center(
        // child: displayWidget(widget.viewModel.events),
        child: widget.detailed
            ? ListenableBuilder(
                listenable: loader,
                builder: (context, child) {
                  // return Text(
                  //   'In LB with events:\n'
                  //   '${widget.viewModel.events}',
                  //   textAlign: TextAlign.center,
                  // );
                  print(
                    '- loader.result: ${loader.result}\n'
                    '- loader.completed? ${loader.completed}\n'
                    '- loader.error? ${loader.error}\n'
                    '- loader.running? ${loader.running}',
                  );
                  if (loader.running) {
                    return Column(
                      children: [
                        Text(
                          'Loading...',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 30),
                        CircularProgressIndicator(),
                      ],
                    );
                  } else if (loader.error) {
                    return Text(
                      'Error!\n\n'
                      '${(loader.result as Error<List<Event>>).error}',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineSmall,
                    );
                  } else {
                    if (loader.result is Ok<List<Event>>) {
                      widget.viewModel.updateEvents(
                        (loader.result as Ok<List<Event>>).value,
                      );
                    }
                    // return Text('Done');
                    return child!;
                  }
                },
                // child: displayWidget(widget.viewModel.events),
                child: ListenableBuilder(
                  listenable: widget.viewModel,
                  builder: (context, _) {
                    print('\nListening to viewModel');
                    return displayWidget(widget.viewModel.events);

                    // return FutureBuilder(
                    //   future: widget.viewModel.events,
                    //   builder: (context, fbSnapshot) {
                    //     print(
                    //       '- loader.result: ${loader.result}\n'
                    //       '- loader.completed? ${loader.completed}\n'
                    //       '- loader.error? ${loader.error}\n'
                    //       '- loader.running? ${loader.running}',
                    //     );
                    //
                    //     if (loader.result is Error) {
                    //       return Text(
                    //         'Error from loader!\n'
                    //         '${loader.result}',
                    //       );
                    //     }
                    //
                    //     return switch (fbSnapshot.connectionState) {
                    //       ConnectionState.done =>
                    //         (fbSnapshot.hasError)
                    //             ? Text(
                    //                 'Error!\n${fbSnapshot.error}',
                    //                 textAlign: TextAlign.center,
                    //                 style: Theme.of(context).textTheme.headlineSmall,
                    //               )
                    //             : displayWidget(fbSnapshot.data as List<Event>),
                    //
                    //       _ => Column(
                    //         children: [
                    //           Text('Loading events in FutureBuilder...'),
                    //           const SizedBox(height: 30),
                    //           CircularProgressIndicator(),
                    //         ],
                    //       ),
                    //     };
                    //   },
                    // );
                  },
                ),
              )
            : FutureBuilder(
                future: load.execute(),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.done:
                      Widget text(String message) => Text(
                        message,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headlineSmall,
                      );

                      print('load.result: ${load.result}');

                      return (snapshot.hasError)
                          ? text('Error!\n\n${snapshot.error}')
                          : text('Data:\n\n${widget.viewModel.events}');

                    // // TODO: Handle this case.
                    // throw UnimplementedError();
                    case _:
                      return Column(
                        children: [
                          Text('Loading data...'),
                          const SizedBox(height: 30),
                          CircularProgressIndicator(),
                        ],
                      );
                    // case ConnectionState.none:
                    //   // TODO: Handle this case.
                    //   throw UnimplementedError();
                    // case ConnectionState.waiting:
                    //   // TODO: Handle this case.
                    //   throw UnimplementedError();
                    // case ConnectionState.active:
                    //   // TODO: Handle this case.
                    //   throw UnimplementedError();
                  }
                },
              ),
        // child: FutureBuilder(
        //   future: widget.viewModel.events(context),
        //   builder: (context, snapshot) {
        //     return switch (snapshot.connectionState) {
        //       ConnectionState.none => Text('None'),
        //       ConnectionState.waiting || ConnectionState.active => Column(
        //         children: [
        //           Text('Waiting...'),
        //           const SizedBox(height: 30),
        //           CircularProgressIndicator(),
        //         ],
        //       ),
        //       ConnectionState.done => () {
        //         print('snapshot.data: ${snapshot.data}');
        //
        //         Widget errorText(String message) => Text(
        //           'Error while getting events!\n'
        //           '\n'
        //           '$message',
        //           textAlign: TextAlign.center,
        //           style: Theme.of(context).textTheme.bodyLarge,
        //         );
        //
        //         if (snapshot.hasError) {
        //           return errorText(snapshot.error.toString());
        //         } else {
        //           return (snapshot.data != null)
        //               ? _displayEvents(snapshot.data as List<Event>)
        //               : errorText(
        //                   ArgumentError.notNull('snapshot.data').toString(),
        //                 );
        //         }
        //       }(),
        //     };
        //   },
        // ),
        // // child: FutureBuilder(
        // //   future: client.connect(),
        // //   builder: (context, snapshot) {
        // //     return switch (snapshot.connectionState) {
        // //       ConnectionState.none => Text('None!'),
        // //
        // //       ConnectionState.waiting => CircularProgressIndicator(),
        // //
        // //       ConnectionState.active => onConnected(
        // //         client,
        // //         snapshot.data as WebSocketChannel,
        // //       ),
        // //       ConnectionState.done =>
        // //         snapshot.hasError
        // //             ? Text(
        // //                 'Error connecting to API at ${client.host}:${client.port}!\n${snapshot.error}',
        // //                 textAlign: TextAlign.center,
        // //               )
        // //             : onConnected(client, snapshot.data as WebSocketChannel),
        // //     };
        // //   },
        // // ),
      ),
    );

    // // TODO remove home_screen Scaffold
    // return Scaffold(
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

// TODO merge StreamBuilderTestViewModel.eventTile into this
class _EventTile extends StatelessWidget {
  const _EventTile({required this.event});

  final Event event;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: event.category.colour,
      child: ListTile(
        title: Text(event.category.toString()),
        subtitle: Text(event.id.toString()),
        trailing: Text(event.assignedCallsigns.join(', ')),
      ),
    );
  }
}
