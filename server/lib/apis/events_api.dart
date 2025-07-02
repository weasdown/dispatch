import 'dart:convert';

import 'package:dispatch/domain/models/event/event.dart';
import 'package:server/apis/endpoint.dart';
import 'package:shelf/shelf.dart';

import 'api.dart';

/// Implements a simple events API.
final class EventsApi extends Api {
  @override
  List<Endpoint> get endpoints => [_rootEndpoint];

  final List<Event> _events = [];

  // Root endpoint that returns a JSON of all currently stored events.
  Endpoint get _rootEndpoint => Endpoint(
    method: HTTPMethod.get,
    path: '/',
    handler: (Request request) {
      return Response.ok(
        json.encode(_events),
        headers: {'Content-Type': 'application/json'},
      );
    },
  );
}
