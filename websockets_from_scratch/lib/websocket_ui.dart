import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'utils.dart';

class WebsocketUi extends StatelessWidget {
  const WebsocketUi({super.key, required this.channel});

  final WebSocketChannel channel;

  Widget onDone(BuildContext context, AsyncSnapshot<String> snapshot) {
    if (snapshot.hasData) {
      return text(context, 'Got stream data:\n\n${snapshot.data}');
    } else {
      return errorText(context, snapshot);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          text(context, 'Connected to WebSocketChannel'),
          SizedBox(height: 30),
          StreamBuilder<String>(
            stream: channel.stream.cast<String>(),
            builder: (context, snapshot) {
              return switch (snapshot.connectionState) {
                ConnectionState.done => onDone(context, snapshot),

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
