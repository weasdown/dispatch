import 'dart:convert';
import 'dart:io';

import 'package:dispatch/data/services/local_data_service.dart';
import 'package:dispatch/domain/models/event/event.dart';
import 'package:dispatch/domain/models/noc.dart';
import 'package:dispatch/domain/models/unit/unit.dart';
import 'package:dispatch/utils/result.dart';
import 'package:intl/intl.dart';
import 'package:logging/logging.dart';
import 'package:shelf/shelf.dart' show Handler;
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_web_socket/shelf_web_socket.dart';

import 'config/assets.dart';

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

  static Handler get wsHandler => webSocketHandler((webSocket, _) {
    webSocket.stream.asBroadcastStream().listen((message) async {
      print('\n$_formattedTimestamp: Received message "$message"');

      final String key = message;
      final List response;
      // final Response response;

      switch (message) {
        case 'units':
          // // TODO consider replacing with WebSocketServer._units
          // // response = _units;
          // response = Assets.units;
          // key = message.toString();

          response = Assets.units;

        case 'events':
          // // TODO consider replacing with WebSocketServer._events
          // // response = _events;
          // response = Assets.events;
          // key = message.toString();

          List<Event> events = Assets.events;
          events.add(
            Event.withNOC(
              id: 1234,
              address: 'TEST-001, Test St, Testfordshire',
              noc: Cat4NOC.nauseaVomiting(),
            ),
          );

          response = events;
        case _:
          response = [
            ArgumentError.value(
              message,
              'message',
              'must be "events" or "units"',
            ),
          ];
        // key = 'error';

        // response = Response.badRequest();
      }

      // Map<String, dynamic> responseJson = {'statusCode': response.statusCode};

      // Send the response back to the sender.
      // webSocket.sink.add(json.encode(response));
      Map<String, dynamic> messageToReply = {key: response};
      String messageJSON = json.encode(messageToReply);
      webSocket.sink.add(messageJSON);

      print('$_formattedTimestamp: Replied with "$messageJSON"');
    });
  });

  Handler get coreHandler => wsHandler;
  // _handler;

  static const String _defaultHost = 'localhost';

  static const int _defaultPort = 8080;

  List<Event> _events = [];

  static String get _formattedTimestamp {
    final DateTime timestamp = DateTime.timestamp();
    final DateFormat formatter = DateFormat('yyyy/MM/dd').add_Hms();
    final String formattedTimestamp = formatter.format(timestamp);
    return formattedTimestamp;
  }

  // // Configure a pipeline that logs requests.
  // Handler get _handler =>
  //     Pipeline().addMiddleware(logRequests()).addHandler(_router.call);

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

  // // Configure routes.
  // final Router _router = Router()..mount('/events', EventsApi().router.call);
  // // TODO enable login API once implemented.
  // // ..mount('/login', LoginApi().router.call);

  // FIXME refactor so server is higher-level than dart:io's HttpServer. Currently crashes when run on web because HttpServer isn't supported on web.
  Future<HttpServer> _serve() async =>
      shelf_io.serve(coreHandler, host, _port).then((HttpServer server) {
        final String logMessage =
            'Serving at ws://${server.address.host}:$_port\n'
            '\t- Current units: $_units\n'
            '\t- Current events: $_events\n';
        _log.info(logMessage);
        print(logMessage);
        return server;
      });

  List<Unit> _units = [];

  /// Gets all the [Unit]s currently connected to (but not necessarily logged in to) this server.
  Result<List<Unit>> get units => Result.ok(_units);
}
