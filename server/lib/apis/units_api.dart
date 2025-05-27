import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../config/assets.dart';
import 'api.dart';

/// Implements a simple units API.
final class UnitsApi extends Api {
  @override
  // TODO: implement router
  Router get router =>
      throw UnimplementedError('UnitsApi.router is not yet implemented.');
}

Response unitHandler(Request req) {
  return Response.ok(jsonEncode(Assets.events));
}
