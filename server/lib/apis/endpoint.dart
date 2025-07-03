import 'package:shelf_router/shelf_router.dart';

/// A generic API endpoint
class Endpoint {
  const Endpoint({
    String? parentRoute,
    required this.method,
    required this.route,
    required this.handler,
  }) : parentRoute = parentRoute ?? '';

  /// Adds this [Endpoint] to the routes accessible to a [Router].
  void addToRouter({required Router router}) => switch (method) {
    HTTPMethod.get => router.get(fullRoute, handler),
    HTTPMethod.post => router.post(fullRoute, handler),

    // TODO: Handle this case.
    HTTPMethod.head => throw UnimplementedError(),
    // TODO: Handle this case.
    HTTPMethod.put => throw UnimplementedError(),
    // TODO: Handle this case.
    HTTPMethod.delete => throw UnimplementedError(),
    // TODO: Handle this case.
    HTTPMethod.connect => throw UnimplementedError(),
    // TODO: Handle this case.
    HTTPMethod.options => throw UnimplementedError(),
    // TODO: Handle this case.
    HTTPMethod.trace => throw UnimplementedError(),
    // TODO: Handle this case.
    HTTPMethod.patch => throw UnimplementedError(),
  };

  /// Returns a duplicate of this endpoint.
  Endpoint copy() => Endpoint(
    parentRoute: parentRoute,
    method: method,
    route: route,
    handler: handler,
  );

  // Returns a duplicate of this endpoint but with one or more of its attributes changed.
  Endpoint copyWith({
    String? parentRoute,
    HTTPMethod? method,
    String? route,
    Function? handler,
  }) => Endpoint(
    parentRoute: parentRoute ?? this.parentRoute,
    method: method ?? this.method,
    route: route ?? this.route,
    handler: handler ?? this.handler,
  );

  String get fullRoute => '$parentRoute$route';

  final Function handler;

  final HTTPMethod method;

  final String parentRoute;

  final String route;
}

/// Valid HTTP methods - see [Mozilla guidance](https://developer.mozilla.org/en-US/docs/Web/HTTP/Reference/Methods).
enum HTTPMethod {
  get,
  head,
  post,
  put,
  delete,
  connect,
  options,
  trace,
  patch;

  const HTTPMethod();

  String get verb => name.toUpperCase();
}
