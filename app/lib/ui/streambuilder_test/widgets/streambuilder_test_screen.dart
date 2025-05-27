import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../../data/services/api/api_client.dart';
import '../../../domain/models/event/category_colour.dart';
import '../../../domain/models/event/event.dart';
import '../view_models/streambuilder_test_viewmodel.dart';

// TODO remove this file and streambuilder_test_viewmodel.dart

class StreamBuilderTestScreen extends StatefulWidget {
  const StreamBuilderTestScreen({super.key, required this.viewModel});

  final StreamBuilderTestViewModel viewModel;

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

  Widget onConnected(ApiClient client, WebSocketChannel channel) {
    client.requestEvents;

    Widget active(Map<String, List> data) {
      // TODO remove all prints from file
      // print('In active');
      List<Map<String, dynamic>> eventsJsons = data['events']!
          .cast<Map<String, dynamic>>();

      List<Widget> eventTiles() {
        List<Event> events = List<Event>.from(
          eventsJsons.map((Map<String, dynamic> eventMap) {
            return Event.fromJson(eventMap);
          }),
        );

        Widget cardForEvent(Event event) => Card(
          color: event.category.colour,
          child: ListTile(
            title: Text(event.category.toString()),
            subtitle: Text(event.id.toString()),
            trailing: Text(event.assignedCallsigns.join(', ')),
          ),
        );

        return List<Widget>.from(
          events.map((Event event) => cardForEvent(event)),
        );
      }

      // List<Future<Widget>> eventTiles() {
      //   List<Future<Event>> events = List<Future<Event>>.from(
      //     eventsJsons.map((Map<String, dynamic> eventMap) async {
      //       return await Event.fromJson(eventMap, client);
      //     }),
      //   );
      //
      //   return List<Future<Widget>>.from(
      //     events.map((Future<Event> eventFuture) async {
      //       Event event = await eventFuture;
      //       return Card(
      //         color: event.category.colour,
      //         child: ListTile(
      //           title: Text(event.category.toString()),
      //           subtitle: Text(event.id.toString()),
      //           trailing: Text(event.assignedUnits.join(', ')),
      //         ),
      //       );
      //     }),
      //   );
      // }

      return ListView(
        children: eventTiles(),
        // List<Widget>.from(
        //   snapshot.data as List<Widget>,
        //   // eventTiles().map(
        //   //   (Future<Widget> futureWidget) async => await futureWidget,
        //   // ),
        // ),
      );

      // return FutureBuilder(
      //   future: eventTiles(),
      //   builder: (context, snapshot) {
      //     // print('In eventTiles() FB');
      //     return switch (snapshot.connectionState) {
      //       ConnectionState.none => Text(
      //         'None while building from eventTiles()',
      //       ),
      //
      //       ConnectionState.waiting => Column(
      //         children: [
      //           Text('Building from eventTiles()'),
      //           const SizedBox(height: 30),
      //           CircularProgressIndicator(),
      //         ],
      //       ),
      //
      //       ConnectionState.active => Text('Active'),
      //
      //       //     ListView(
      //       //   children: List<Widget>.from(
      //       //     snapshot.data as List<Widget>,
      //       //     // eventTiles().map(
      //       //     //   (Future<Widget> futureWidget) async => await futureWidget,
      //       //     // ),
      //       //   ),
      //       // ),
      //       ConnectionState.done => () {
      //         //     ListView(
      //         //   children: List<Widget>.from(
      //         //     snapshot.data as List<Widget>,
      //         //     // eventTiles().map(
      //         //     //   (Future<Widget> futureWidget) async => await futureWidget,
      //         //     // ),
      //         //   ),
      //         // ),
      //         // print('snapshot.data after eventTiles(): ${snapshot.data}');
      //         return Text('Done while building from eventTiles()');
      //       }(),
      //     };
      //   },
      // );
    }

    return StreamBuilder(
      // stream: widget.viewModel.eventStream,
      stream: channel.stream,
      builder: (context, snapshot) {
        // TODO remove prints
        // debugPrint('snapshot.data: ${snapshot.data}');
        // debugPrint(
        //   '\t- SB snapshot.connectionState: ${snapshot.connectionState}',
        // );

        return switch (snapshot.connectionState) {
          ConnectionState.none => Text('None'),
          ConnectionState.waiting => Column(
            children: [
              Text('Loading stream...'),
              const SizedBox(height: 30),
              CircularProgressIndicator(),
            ],
          ),
          ConnectionState.active => () {
            Map<String, dynamic> streamData =
                jsonDecode(snapshot.data) as Map<String, dynamic>;
            // print('streamData: $streamData');
            // print('Inner FB being called');
            return active(streamData.cast<String, List>());

            // return FutureBuilder(
            //   future: active(streamData.cast<String, List>()),
            //   builder: (context, fbSnapshot) {
            //     return switch (fbSnapshot.connectionState) {
            //       ConnectionState.none => Text('None'),
            //       ConnectionState.waiting => CircularProgressIndicator(),
            //       ConnectionState.active => Text('Active'),
            //       // TODO: Handle this case.
            //       ConnectionState.done => () {
            //         print('streamData: $streamData');
            //         print('fbSnapshot.data: ${fbSnapshot.data}');
            //         // return Text('Done');
            //         return (fbSnapshot.data as Widget);
            //       }(),
            //     };
            //   },
            // );
          }(),
          ConnectionState.done => Text('Done'),
        };
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    ApiClient client = context.read<ApiClient>();

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
        child: FutureBuilder(
          future: client.connect(),
          builder: (context, snapshot) {
            return switch (snapshot.connectionState) {
              ConnectionState.none => Text('None!'),

              ConnectionState.waiting => CircularProgressIndicator(),

              ConnectionState.active => onConnected(
                client,
                snapshot.data as WebSocketChannel,
              ),
              ConnectionState.done =>
                snapshot.hasError
                    ? Text(
                        'Error connecting to API at ${client.host}:${client.port}!\n${snapshot.error}',
                        textAlign: TextAlign.center,
                      )
                    : onConnected(client, snapshot.data as WebSocketChannel),
            };
          },
        ),
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
