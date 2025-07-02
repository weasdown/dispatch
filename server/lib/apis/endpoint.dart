import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

/// A generic API endpoint
class Endpoint {
  const Endpoint({
    required this.method,
    required this.path,
    required this.handler,
  });

  void addToRouter({required Router router}) =>
      router.add(method.verb, route, handler);

  final Handler handler;

  final HTTPMethod method;

  final String path;

  /// Alias for [path].
  String get route => path;
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
