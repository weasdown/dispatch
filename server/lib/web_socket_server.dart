import 'dart:convert';
import 'dart:io';

import 'package:dispatch/data/services/local_data_service.dart';
import 'package:dispatch/domain/models/event/event.dart';
import 'package:dispatch/domain/models/unit/unit.dart';
import 'package:dispatch/utils/result.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:logging/logging.dart';
import 'package:shelf/shelf.dart' show Handler;
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_web_socket/shelf_web_socket.dart';

/// A server that provides a WebSocket connection.
class WebSocketServer {
  WebSocketServer._({String? host, int? port})
    : host = host ?? _defaultHost,
      _port = port ?? _defaultPort,
      _localDataService = LocalDataService() {
    _events = _localDataService.events;
    _units = _localDataService.units;
  }

  /// Creates a server without immediately running it.
  WebSocketServer.pending({String? host, int? port})
    : this._(host: host, port: port);

  /// Creates a server and immediately runs it.
  factory WebSocketServer.run({String? host, int? port}) =>
      WebSocketServer._(host: host, port: port).._serve();

  /// Adds an item to its respective list.
  Future<Result<void>> add<T>(T item) => switch (T) {
    Unit _ => Future(() => Result.ok(_units.add(item as Unit))),
    Event _ => Future(() => Result.ok(_events.add(item as Event))),
    _ => throw TypeError(),
  };

  Handler get coreHandler => webSocketHandler((webSocket, _) {
    webSocket.stream.asBroadcastStream().listen((message) async {
      print('\n$_formattedTimestamp: Received message "$message"');

      final String key;
      final List response;

      switch (message) {
        case 'units':
          response = _units;
          key = message.toString();
        case 'events':
          response = _events;
          key = message.toString();
        case _:
          response = [
            ArgumentError.value(
              message,
              'message',
              'must be "events" or "units"',
            ),
          ];
          key = 'error';
      }

      // Send the response back to the sender.
      Map<String, dynamic> messageToReply = {key: response};
      String messageJSON = json.encode(messageToReply);
      webSocket.sink.add(messageJSON);
      print('$_formattedTimestamp: Replied with "$messageJSON"');
    });
  });

  static const String _defaultHost = 'localhost';

  static const int _defaultPort = 8080;

  List<Event> _events = [];

  String get _formattedTimestamp {
    final DateTime timestamp = DateTime.timestamp();
    final DateFormat formatter = DateFormat('yyyy/MM/dd').add_Hms();
    final String formattedTimestamp = formatter.format(timestamp);
    return formattedTimestamp;
  }

  final String host;

  LocalDataService _localDataService;

  final _log = Logger('WebSocketServer');

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
        print(
          'Serving at ws://${server.address.host}:${server.port}\n'
          '\t- Current units: $_units\n'
          '\t- Current events: $_events\n',
        );
        return server;
      });

  List<Unit> _units = [];

  /// Gets all the [Unit]s currently connected to (but not necessarily logged in to) this server.
  Result<List<Unit>> get units => Result.ok(_units);
}
