import 'dart:convert';
import 'dart:io';

import 'package:dispatch/domain/models/event.dart';
import 'package:dispatch/domain/models/unit/unit.dart';
import 'package:dispatch/utils/result.dart';
import 'package:shelf/shelf.dart' show Handler;
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_web_socket/shelf_web_socket.dart';

/// A server that provides a WebSocket connection.
class WebSocketServer {
  WebSocketServer._({String? host, int? port})
    : host = host ?? _defaultHost,
      _port = port ?? _defaultPort,
      _events = [],
      _units = [];

  /// Creates a server without immediately running it.
  WebSocketServer.pending({String? host, int? port})
    : this._(host: host, port: port);

  /// Creates a server and immediately runs it.
  factory WebSocketServer.run({String? host, int? port}) =>
      WebSocketServer._(host: host, port: port).._serve();

  static final Handler coreHandler = webSocketHandler((webSocket, _) {
    webSocket.stream.listen((message) async {
      print('Received message: $message');

      Map<String, dynamic> messageJSON = messageFromJSON(message);
      print('Message JSON: $messageJSON');

      // TODO implement response.
      final String response = 'A placeholder response';

      // Send the response back to the sender.
      webSocket.sink.add(json.encode({'response': response}));
    });
  });

  static const String _defaultHost = 'localhost';

  static const int _defaultPort = 8080;

  List<Event> _events;

  final String host;

  // @Deprecated('messageFromJSON is pending removal.')
  static Map<String, dynamic> messageFromJSON(String message) {
    try {
      return jsonDecode(message);
    } on FormatException {
      throw ArgumentError('message is not a valid JSON.');
    }
  }

  final int _port;

  // FIXME refactor so server is higher-level than dart:io's HttpServer. Currently crashes when run on web because HttpServer isn't supported on web.
  Future<HttpServer> _serve() async =>
      shelf_io.serve(coreHandler, host, _port).then((HttpServer server) {
        print('Serving at ws://${server.address.host}:${server.port}');
        return server;
      });

  List<Unit> _units;

  /// Gets all the [Unit]s currently connected to (but not necessarily logged in to) this server.
  Future<Result<List<Unit>>> get units async => Future(() => Result.ok(_units));
}
