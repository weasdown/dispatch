import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketApiClient {
  WebSocketApiClient._({
    String? host,
    int? port,
    required String path,
    Duration? timeout,
  }) : _host = host ?? 'localhost',
       _port = port ?? 8080,
       _path = path,
       _connectionTimeout = timeout ?? const Duration(seconds: 20);

  WebSocketApiClient.events() : this._(path: 'events');

  WebSocketApiClient.units() : this._(path: 'units');

  WebSocketChannel? get channel => _channel;
  WebSocketChannel? _channel;

  Uri get _channelUri =>
      Uri(scheme: 'ws', host: _host, port: _port, path: _path);

  Future<WebSocketChannel> connect() =>
      Future<WebSocketChannel>.delayed(Duration(seconds: 1), () async {
        final WebSocketChannel channel = WebSocketChannel.connect(_channelUri);
        _channel = channel;

        await channel.ready;

        return channel;
      }).timeout(connectionTimeout);

  Duration get connectionTimeout => _connectionTimeout;
  final Duration _connectionTimeout;

  /// The server path that this client is connected to.
  String get endpoint => _path;

  final String _host;

  final String _path;

  final int _port;

  void requestEvents() => channel!.sink.add('events');

  Stream<String> get stream {
    Stream<String> stream = (_stream != null)
        ? _stream!
        : channel!.stream.cast<String>();
    stream = stream.asBroadcastStream();
    return stream;
  }

  Stream<String>? _stream;
}
