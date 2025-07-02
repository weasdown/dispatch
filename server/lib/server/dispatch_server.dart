import 'dart:io' show HttpServer;

import 'package:dispatch/data/services/local_data_service.dart';
import 'package:dispatch/domain/models/event/event.dart';
import 'package:dispatch/domain/models/unit/unit.dart';
import 'package:logging/logging.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;

abstract class DispatchServer {
  DispatchServer({String? scheme, String? host, int? port})
    : _scheme = scheme ?? 'http',
      _host = host ?? defaultHost,
      _port = port ?? defaultPort,
      _localDataService = LocalDataService();

  static const String defaultHost = 'localhost';

  static const int defaultPort = 8080;

  Handler get handler;

  List<Event> get events => _localDataService.events;

  final String _host;

  final LocalDataService _localDataService;

  final Logger _log = Logger('DispatchServer');

  final int _port;

  final String _scheme;

  String get scheme => _scheme;

  // FIXME refactor so server is higher-level than dart:io's HttpServer. Currently crashes when run on web because HttpServer isn't supported on web.
  Future<HttpServer> serve() async =>
      await shelf_io.serve(handler, _host, _port).then((HttpServer server) {
        final String logMessage =
            'Serving at $scheme://${server.address.host}:${server.port}\n'
            '\t- Current units: $units\n'
            '\t- Current events: $events\n';
        _log.info(logMessage);
        print(logMessage);
        return server;
      });

  List<Unit> get units => _localDataService.units;
}
