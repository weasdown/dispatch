import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'utils.dart';

class WebsocketUi extends StatelessWidget {
  const WebsocketUi({super.key, required this.channel});

  final WebSocketChannel channel;

  @override
  Widget build(BuildContext context) {
    return text(
      context,
      'Connected to WebSocketChannel:\n\n'
      '${channel.toString()}',
    );
  }
}
