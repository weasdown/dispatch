import 'dart:convert';

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

    return Text(
      'Got data from stream:\n$_dataJson',
      style: Theme.of(context).textTheme.bodyLarge,
      textAlign: TextAlign.center,
    );
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
