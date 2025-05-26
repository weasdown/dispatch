import 'package:web_socket_channel/web_socket_channel.dart';

class ApiClient {
  ApiClient({required this.host, required this.port});

  WebSocketChannel? _channel;

  WebSocketChannel? get channel => _channel;

  Uri get _channelUri => Uri(scheme: 'ws', host: host, port: port);

  WebSocketChannel connect() {
    _channel = WebSocketChannel.connect(_channelUri);
    return channel!;
  }

  final String host;

  final int port;

  Stream get stream => channel!.stream;

  void get requestEvents => channel!.sink.add('events');

  void get requestUnits => channel!.sink.add('units');
}
