import 'package:web_socket_channel/web_socket_channel.dart';

import '../../../../../domain/models/event/event.dart';
import '../../../../../utils/result.dart';

class ApiClient {
  ApiClient({String? host, int? port})
    : _host = host ?? 'localhost',
      _port = port ?? 8080;

  WebSocketChannel? _channel;

  WebSocketChannel? get channel => _channel;

  Uri get _channelUri => Uri(scheme: 'ws', host: _host, port: _port);

  Future<WebSocketChannel> connect() async {
    final channel = WebSocketChannel.connect(_channelUri);
    _channel = channel;

    await channel.ready;

    return channel;
  }

  Future<Result<List<Event>>> get events async {
    List<Event> events = [];
    return Future(() => Result.ok(events));
    // return channel.stream.cast<Map<String, dynamic>>().listen((
    //     Map<String, dynamic> json,
    //     ) {
    //   switch (json) {
    //     case {'events': List<Event> events, 'units': List<Unit> units}:
    //       ;
    //     case _:
    //       throw const FormatException('Failed to load album.');
    //   }
    //   ;
    //
    //   // channel.sink.add('received!');
    //   // channel.sink.close(status.goingAway);
    // });
  }

  final String _host;

  String get host => _host;

  final int _port;

  int get port => _port;

  Stream<Object> get stream {
    if (channel == null) {
      connect();
    }

    return channel!.stream.cast<Object>(); //.asBroadcastStream();
  }

  Future<void> get requestEvents async {
    if (channel == null) {
      _channel = await connect();
    }
    channel!.sink.add('events');
  }

  Future<void> get requestUnits async {
    if (channel == null) {
      _channel = await connect();
    }
    channel!.sink.add('units');
  }
}
