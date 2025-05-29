import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:dispatch/data/services/local_data_service.dart';
import 'package:dispatch/domain/models/event/event.dart';
import 'package:dispatch/domain/models/noc.dart';
import 'package:dispatch/domain/models/unit/unit.dart';
import 'package:dispatch/utils/result.dart';
import 'package:intl/intl.dart';
import 'package:logging/logging.dart';
import 'package:shelf/shelf.dart' show Handler, Pipeline, logRequests;
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_router/shelf_router.dart';
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

  static Handler get eventsWebsocketHandler => webSocketHandler((webSocket, _) {
    webSocket.stream.asBroadcastStream().listen((message) async {
      print('\n$_formattedTimestamp: Received message "$message"');

      final String key = message;
      final List response;
      // final Response response;

      List<Event> events = Assets.events;

      switch (message) {
        // case 'units':
        //   // // TODO consider replacing with WebSocketServer._units
        //   // // response = _units;
        //   // response = Assets.units;
        //   // key = message.toString();
        //
        //   response = Assets.units;

        case 'events':
          // // TODO consider replacing with WebSocketServer._events
          // // response = _events;
          // response = Assets.events;
          // key = message.toString();

          response = events;

        case _:
          response = [
            ArgumentError.value(
              message,
              'message',
              'must be "events"', // or "units"',
            ),
          ];
        // key = 'error';

        // response = Response.badRequest();
      }

      // Send the response back to the sender.
      // webSocket.sink.add(json.encode(response));
      Map<String, dynamic> messageToReply = {key: response};
      String messageJSON = json.encode(messageToReply);
      webSocket.sink.add(messageJSON);

      Future<void> sendTestEvents() async {
        List<Event> testEvents = List.generate(5, (_) {
          int randomInt = Random().nextInt(1000);
          final Event testEvent = Event.withNOC(
            id: randomInt,
            address: '$randomInt Test St, Testfordshire',
            noc: Cat4NOC.nauseaVomiting(),
          );
          return testEvent;
        });

        Future<void> testEventFuture(Event testEvent) => Future.delayed(
          Duration(seconds: 1, milliseconds: Random().nextInt(500)),
          () {
            events.add(testEvent);

            Map<String, dynamic> messageToReply = {'events': events};
            messageJSON = json.encode(messageToReply);
            webSocket.sink.add(messageJSON);
            print('Sent event ${testEvent.id}');
          },
        );

        for (Event testEvent in testEvents) {
          await testEventFuture(testEvent).then((_) async {
            // Wait 1 second before sending the next event.
            print('Waiting');
            await Future.delayed(Duration(seconds: 1));
          });
        }
      }

      await sendTestEvents();

      print('$_formattedTimestamp: Replied with "$messageJSON"');
    });
  });

  static const String _defaultHost = 'localhost';

  static const int _defaultPort = 8080;

  List<Event> _events = [];

  static String get _formattedTimestamp {
    final DateTime timestamp = DateTime.timestamp();
    final DateFormat formatter = DateFormat('yyyy/MM/dd').add_Hms();
    final String formattedTimestamp = formatter.format(timestamp);
    return formattedTimestamp;
  }

  // A pipeline that handles and logs requests.
  Handler get _handler => Pipeline()
      .addMiddleware(logRequests())
      // .addMiddleware(() => wsHandler) // FIXME
      // TODO add auth handler once authRequests() implemented.
      // .addMiddleware(authRequests())
      // .addMiddleware((innerHandler) {
      //   print('Received request: $innerHandler');
      //   return _router.call;
      // })
      .addHandler(_router.call);

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

  // Configure routes.
  final Router _router = Router()
    // ..get('/', eventHandler)
    ..get('/events', eventsWebsocketHandler);
  // ..mount('/', EventsApi().router.call)
  // ..mount('/events', EventsApi().handler)
  // ..mount('/', WebSocketServer.wsHandler);
  // TODO enable units API once implemented.
  // ..mount('/units', UnitsApi().router.call);
  // ..mount('/units', UnitsApi().handler);
  // TODO enable login API once implemented.
  // ..mount('/login', LoginApi().router.call);

  // // Configure routes.
  // final Router _router = Router()..mount('/events', EventsApi().router.call);
  // // TODO enable login API once implemented.
  // // ..mount('/login', LoginApi().router.call);

  // FIXME refactor so server is higher-level than dart:io's HttpServer. Currently crashes when run on web because HttpServer isn't supported on web.
  Future<HttpServer> _serve() async =>
      // shelf_io.serve(coreHandler, host, _port).then((HttpServer server) {
      shelf_io.serve(_handler, host, _port).then((HttpServer server) {
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
