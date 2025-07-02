import 'package:shelf/shelf.dart';

/// A generic API endpoint
class Endpoint {
  const Endpoint({
    required this.method,
    required this.path,
    required this.handler,
  });

  final Handler handler;

  final HTTPMethod method;

  final String path;
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
