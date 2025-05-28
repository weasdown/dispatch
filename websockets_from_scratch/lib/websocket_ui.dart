import 'dart:convert';

import 'package:dispatch/domain/models/event/event.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'utils.dart';

class WebsocketUi extends StatefulWidget {
  const WebsocketUi({super.key, required this.channel});

  final WebSocketChannel channel;

  Widget onDone(BuildContext context, AsyncSnapshot<String> snapshot) {
    if (snapshot.hasData) {
      return text(
        context,
        'Connection to WebSocket closed. Final data:\n\n${snapshot.data}',
      );
    } else {
      return errorText(context, snapshot);
    }
  }

  @override
  State<WebsocketUi> createState() => _WebsocketUiState();
}

class _WebsocketUiState extends State<WebsocketUi> {
  String? _data;
  Map<String, dynamic>? _dataJson;

  Widget onData(AsyncSnapshot<String> snapshot) {
    if (snapshot.hasData) {
      String data = snapshot.data!;
      _data = data;

      _dataJson = json.decode(_data!);

      print('_dataJson: $_dataJson');
    }

    return ListView(shrinkWrap: true, children: buildEventTiles(_dataJson!));
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
  Widget build(BuildContext context) {
    print('_data: $_data');
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView(
        children: [
          text(context, 'Connected to WebSocketChannel'),
          SizedBox(height: 30),
          StreamBuilder<String>(
            stream: widget.channel.stream.cast<String>(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                widget.channel.sink.add('events');
              }

              return switch (snapshot.connectionState) {
                ConnectionState.done => widget.onDone(context, snapshot),

                ConnectionState.active => onData(snapshot),

                _ => Column(
                  children: [
                    text(context, 'Getting WebSocket data...'),
                    const SizedBox(height: 10),
                    Text(
                      '(ConnectionState: ${snapshot.connectionState})',
                      style: Theme.of(
                        context,
                      ).textTheme.headlineSmall!.copyWith(fontSize: 20),
                    ),
                    const SizedBox(height: 50),
                    CircularProgressIndicator(),
                  ],
                ),
              };
            },
          ),
        ],
      ),
    );
  }
}
