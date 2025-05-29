import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketApiClient {
  WebSocketApiClient({String? host, int? port, String? path, Duration? timeout})
    : _host = host ?? 'localhost',
      _port = port ?? 8080,
      _path = path ?? '/',
      _connectionTimeout = timeout ?? Duration(seconds: 20);

  WebSocketChannel? get channel => _channel;
  WebSocketChannel? _channel;

  Uri get channelUri =>
      Uri(scheme: 'ws', host: _host, port: _port, path: _path);

  Future<WebSocketChannel> connect() =>
      Future<WebSocketChannel>.delayed(Duration(seconds: 1), () async {
        final WebSocketChannel channel = WebSocketChannel.connect(channelUri);
        _channel = channel;

        await channel.ready;

        return channel;
      }).timeout(connectionTimeout);

  Duration get connectionTimeout => _connectionTimeout;
  final Duration _connectionTimeout;

  final String _host;

  final String _path;

  final int _port;

  void requestEvents() => channel!.sink.add('events');

  Stream<String> get stream =>
      (_stream != null) ? _stream! : channel!.stream.cast<String>();
  Stream<String>? _stream;
}
