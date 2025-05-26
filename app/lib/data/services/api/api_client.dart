import 'package:web_socket_channel/web_socket_channel.dart';

class ApiClient {
  ApiClient({String? host, int? port})
    : _host = host ?? 'localhost',
      _port = port ?? 5678;

  WebSocketChannel? _channel;

  WebSocketChannel? get channel => _channel;

  Uri get _channelUri => Uri(scheme: 'ws', host: _host, port: _port);

  WebSocketChannel connect() {
    _channel = WebSocketChannel.connect(_channelUri);
    return channel!;
  }

  final String _host;

  final int _port;

  Stream<Object> get stream {
    if (channel == null) {
      connect();
    }

    return channel!.stream.cast<Object>(); //.asBroadcastStream();
  }

  void get requestEvents => channel!.sink.add('events');

  void get requestUnits => channel!.sink.add('units');
}
