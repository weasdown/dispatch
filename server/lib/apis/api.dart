import 'package:shelf_router/shelf_router.dart';

import 'endpoint.dart';

/// A generic API.
abstract class Api {
  /// Definitions of this API's endpoints.
  List<Endpoint> get endpoints;

  Router get router {
    final router = Router();

    for (Endpoint endpoint in endpoints) {
      endpoint.addToRouter(router: router);
    }

    return router;
  }
}
