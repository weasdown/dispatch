/// @docImport: '../server.dart';
library;

import 'package:server/server/dispatch_server.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

/// HTTP-based equivalent of the [WebSocketServer].
final class HttpDispatchServer extends DispatchServer {
  HttpDispatchServer._({
    required super.host,
    required super.port,
    required Handler eventHandler,
    required Handler unitHandler,
  }) : super(scheme: 'http', handler: _router.call);

  factory HttpDispatchServer.run({String? host, int? port}) =>
      HttpDispatchServer._(
        host: host,
        port: port,
        eventHandler: _mockEventHandler,
        unitHandler: _mockUnitHandler,
      )..serve();

  static Handler get _eventHandler => _mockEventHandler;

  static Router get _router => Router()
    ..get('/event', _eventHandler)
    ..mount('/unit', _unitHandler);

  static final Handler _unitHandler = _mockUnitHandler;
}

Handler get _mockEventHandler => (Request request) {
  // TODO implement _mockEventHandler
  return Future.value(Response.ok([true]));
};

Handler get _mockUnitHandler => (Request request) {
  // TODO implement _mockUnitHandler
  return Future.value(Response.ok([true]));
};
