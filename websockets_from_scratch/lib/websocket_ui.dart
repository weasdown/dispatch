import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebsocketUi extends StatelessWidget {
  const WebsocketUi({super.key, required this.channel});

  final WebSocketChannel channel;

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
