import 'dart:convert';

import 'package:dispatch/data/services/local_data_service.dart';
import 'package:dispatch/domain/models/unit/unit.dart';
import 'package:shelf/shelf.dart';

import 'api.dart';
import 'endpoint.dart';
import 'http_api.dart';

/// Implements a simple units API.
final class UnitApi extends Api with HttpApi {
  UnitApi({required this.localDataService});

  @override
  String get baseRoute => '/units';

  @override
  List<Endpoint> get endpoints => [_rootEndpoint];

  final LocalDataService localDataService;

  // Root endpoint that returns a JSON of all currently stored events.
  Endpoint get _rootEndpoint => Endpoint(
    method: HTTPMethod.get,
    parentRoute: baseRoute,
    route: '/',
    handler: (Request request) {
      print('\nRunning UnitApi._rootEndpoint');
      return Response.ok(
        json.encode(localDataService.units),
        headers: {'Content-Type': 'application/json'},
      );
    },
  );
}
