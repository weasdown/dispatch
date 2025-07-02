import 'package:shelf_router/shelf_router.dart';

import 'api.dart';
import 'endpoint.dart';

/// An API that is accessed via HTTP.
mixin HttpApi implements Api {
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
