import 'dart:convert';

import 'package:shelf/shelf.dart';

import '../config/assets.dart';
import 'api.dart';

/// Implements a simple units API.
final class UnitsApi extends Api {
  @override
  Future<Response> handler(Request request) async {
    // TODO: implement handler
    throw UnimplementedError();
  }
}

Response unitHandler(Request req) {
  return Response.ok(jsonEncode(Assets.events));
}
