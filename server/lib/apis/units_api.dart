import 'dart:convert';

import 'package:dispatch/data/defaults.dart';
import 'package:dispatch/domain/models/unit/unit.dart';
import 'package:server/apis/endpoint.dart';
import 'package:shelf/shelf.dart';

import 'api.dart';
import 'http_api.dart';

/// Implements a simple units API.
final class UnitApi extends Api with HttpApi {
  @override
  String get baseRoute => '/unit';

  @override
  List<Endpoint> get endpoints => [_rootEndpoint];

  // Root endpoint that returns a JSON of all currently stored events.
  Endpoint get _rootEndpoint => Endpoint(
    method: HTTPMethod.get,
    parentRoute: baseRoute,
    route: '/',
    handler: (Request request) {
      return Response.ok(
        json.encode(_units),
        headers: {'Content-Type': 'application/json'},
      );
    },
  );

  final List<Unit> _units = Defaults.units;
}
