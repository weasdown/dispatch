import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../../data/services/api/api_client.dart';
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
  @override
  Widget build(BuildContext context) {
    // TODO move this StreamBuilder test to a new Widget and revert to the Home widget.
    ApiClient client = ApiClient(host: 'localhost', port: 8080);
    WebSocketChannel channel = client.connect();
    // client.requestUnits;
    client.requestEvents;

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
        child: StreamBuilder(
          stream: channel.stream,
          builder: (context, snapshot) => switch (snapshot.connectionState) {
            ConnectionState.none => Text('None'),
            ConnectionState.waiting => CircularProgressIndicator(),
            ConnectionState.active => Text(
              'Active\n\n'
              '${snapshot.data}',
              textAlign: TextAlign.center,
            ),
            ConnectionState.done => Text('Done'),
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
