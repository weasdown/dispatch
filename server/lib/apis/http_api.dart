import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import 'api.dart';
import 'endpoint.dart';

/// An API that is accessed via HTTP.
mixin HttpApi implements Api {
  /// Definitions of this API's endpoints.
  List<Endpoint> get endpoints;

  /// Encodes some [data] (e.g. a [Unit] or `List<Unit>`) as a JSON, then
  /// delivers it as an HTTP OK [Response].
  Response respondOkJSON(Object data) => Response.ok(
    json.encode(data),
    headers: {'Content-Type': 'application/json'},
  );

  Router get router {
    final router = Router();

    for (Endpoint endpoint in endpoints) {
      endpoint.addToRouter(router: router);
    }

    return router;
  }
}
