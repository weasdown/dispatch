/// @docImport: '../server.dart';
library;

import 'package:dispatch/data/services/local_data_service.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../apis/endpoint.dart';
import '../apis/events_api.dart';
import '../apis/units_api.dart';
import 'dispatch_server.dart';

/// HTTP-based equivalent of the [WebSocketServer].
final class HttpDispatchServer extends DispatchServer {
  HttpDispatchServer._({
    required super.host,
    required super.port,
    required Handler eventHandler,
    required Handler unitHandler,
  }) : _localDataService = LocalDataService(),
       super(scheme: 'http');

  factory HttpDispatchServer.run({
    String? host,
    int? port,
    required LocalDataService localDataService,
  }) => HttpDispatchServer._(
    host: host,
    port: port,
    eventHandler: EventApi(localDataService: localDataService).router.call,
    unitHandler: UnitApi(localDataService: localDataService).router.call,
  )..serve();

  @override
  Handler get handler => _router.call;

  final LocalDataService _localDataService;

  Router get _router {
    final Router router = Router();

    final EventApi eventApi = EventApi(localDataService: _localDataService);
    final UnitApi unitApi = UnitApi();

    for (Endpoint endpoint in [...eventApi.endpoints, ...unitApi.endpoints]) {
      endpoint.addToRouter(router: router);
    }

    return router;
  }
}
