import 'dart:async';
import 'dart:convert';

import 'package:dispatch/domain/models/event/event.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'api.dart';
import 'utils.dart';

// GlobalKey _uiKey = GlobalKey(debugLabel: 'WebsocketUI StreamBuilder');

class WebsocketUi extends StatefulWidget {
  const WebsocketUi({
    super.key,
    // required this.apiClient,
    required this.channel,
  });

  // final WebSocketApiClient apiClient;

  final WebSocketChannel channel;

  @override
  State<WebsocketUi> createState() => _WebsocketUiState();
}

class _WebsocketUiState extends State<WebsocketUi> {
  // Copied from: https://stackoverflow.com/questions/64838335/using-didupdatewidget-to-replace-a-stream-causes-bad-state-stream-has-already
  Stream<String>? _eventStream;
  late StreamController<String> _eventStreamController;
  late StreamSubscription<String> _eventStreamSubscription;

  void initStream() async {
    // _eventStream = widget.apiClient.stream;

    // _eventStreamController?.close();
    _eventStreamController = StreamController<String>();

    // widget.channel.stream.pipe(_eventStreamController);

    _eventStreamSubscription = widget.channel.stream.cast<String>().listen((
      String event,
    ) {
      _eventStreamController.add(event);
    }, onDone: _eventStreamController.close);
    // // ..onDone(() => _eventStreamController.close());
  }

  bool connected = true;

  // String? _data;
  Map<String, dynamic>? _dataJson;

  // String eventString = '';

  // final StreamController<String> _streamController =
  //     StreamController<String>.broadcast();
  Stream get onVariableChanged => _eventStreamController.stream;

  Widget onData(AsyncSnapshot<String> snapshot) {
    if (snapshot.hasData) {
      String data = snapshot.data!;
      // _data = data;
      // _eventStreamController.sink.add(data);

      _dataJson = json.decode(data);
      print('_dataJson: $_dataJson');
    }

    return ListView(shrinkWrap: true, children: buildEventTiles(_dataJson!));
  }

  Widget onDone(BuildContext context, AsyncSnapshot<String> snapshot)
  // async
  {
    connected = false;
    Widget resultWidget;
    if (snapshot.hasData) {
      resultWidget = Column(
        children: [
          text(
            context,
            'Connection to WebSocket closed.',
            //' Final data:\n\n${snapshot.data}', // TODO remove final data print
          ),
          const SizedBox(height: 30),
          refreshButton(
            onPressed: () {
              dispose();

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => WebsocketUi(
                    // apiClient: WebSocketApiClient.events()..connect(),
                    channel: widget.channel,
                  ),
                ),
              );
              // initState();
            },

            //     setState(() {
            //   print('In WebsocketUi refreshButton');
            //   _data = null;
            //   _dataJson = null;
            //   stream = null;
            // }),
          ),
        ],
      );
    } else {
      resultWidget = errorText(context, snapshot);
    }

    // await widget.channel.sink.close(normalClosure, 'normalClosure');
    // print('\nClose code: ${widget.channel.closeCode}');

    return resultWidget;
  }

  Widget onWaiting(AsyncSnapshot<String> snapshot) {
    // TODO reinstate apiClient
    // widget.apiClient.requestEvents();
    widget.channel.sink.add('events');

    return Column(
      children: [
        text(context, 'Getting WebSocket data...'),
        const SizedBox(height: 10),
        Text(
          '(ConnectionState: ${snapshot.connectionState.name})',
          style: Theme.of(
            context,
          ).textTheme.headlineSmall!.copyWith(fontSize: 20),
        ),
        const SizedBox(height: 50),
        CircularProgressIndicator(),
      ],
    );
  }

  List<Widget> buildEventTiles(Map<String, dynamic> eventJson) {
    List<Map<String, dynamic>> eventsList = eventJson['events']
        .cast<Map<String, dynamic>>();

    List<Widget> widgets = [];
    for (Map<String, dynamic> eventEntry in eventsList) {
      Event event = Event.fromJson(eventEntry);
      widgets.add(
        Card(
          child: ListTile(
            title: Text(event.address),
            subtitle: Text(event.category.toString()),
            trailing: Text(event.assignedCallsigns.join(', ')),
          ),
        ),
      );
    }

    return widgets;
  }

  @override
  void initState() {
    super.initState();
    _eventStream = null;
    connected = true;
    initStream();

    // _streamController.close();
    // stream = widget.apiClient.stream.asBroadcastStream();
    // widget.apiClient.stream.pipe(_streamController);
  }

  @override
  void didUpdateWidget(covariant WebsocketUi oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    _eventStreamController.close();
    // _streamController.close();
    // Initialize the stream only if it has changed
    // if (widget._eventStream != _eventStream) {
    //   _eventStream = widget._eventStream;
    initStream();
    // }
  }

  @override
  void dispose() {
    _eventStreamController.close();
    // _streamController.close();
    connected = false;

    // // // _data = null;
    // // _dataJson = null;
    // // // stream = null;

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // _stream = widget.channel.stream.cast<String>().asBroadcastStream();

    // _streamController.stream = widget.channel.stream
    //     .cast<String>()
    //     .asBroadcastStream();

    // print('_data: $_data');
    print('connected: $connected');

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            StreamBuilder<String>(
              // key: _uiKey,
              // stream: _eventStream,
              stream: _eventStreamController.stream,
              // stream: widget.channel.stream.cast<String>(),
              // stream: _streamController.stream,
              builder: (context, snapshot) {
                Widget dataWidget = switch (snapshot.connectionState) {
                  ConnectionState.none => Center(
                    child: text(context, 'No connection'),
                  ),

                  ConnectionState.waiting => onWaiting(snapshot),

                  ConnectionState.active => onData(snapshot),

                  ConnectionState.done => onDone(context, snapshot),
                  //     FutureBuilder(
                  //   future: onDone(context, snapshot),
                  //   builder: (context, snapshot) =>
                  //       switch (snapshot.connectionState) {
                  //         ConnectionState.done =>
                  //           (snapshot.data != null)
                  //               ? snapshot.data as Widget
                  //               : Text('Connection closed without a Widget'),
                  //         _ => SizedBox(),
                  //       },
                  // ),
                };

                return Column(
                  children: [
                    text(
                      context,
                      connected
                          ? 'Connected to WebSocketChannel'
                          : 'Not connected to WebSocketChannel',
                    ),
                    SizedBox(height: 8),
                    Text(
                      '(Connection state: ${snapshot.connectionState.name})',
                    ),
                    const SizedBox(height: 30),
                    dataWidget,
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
