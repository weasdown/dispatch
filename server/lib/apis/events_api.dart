import 'dart:convert';

import 'package:dispatch/data/defaults.dart';
import 'package:dispatch/domain/models/event/event.dart';
import 'package:server/apis/endpoint.dart';
import 'package:shelf/shelf.dart';

import 'api.dart';

/// Implements a simple events API.
final class EventsApi extends Api {
  @override
  List<Endpoint> get endpoints => [_rootEndpoint, _getEventById];

  /// Gets an event by its id.
  Endpoint get _getEventById => Endpoint(
    method: HTTPMethod.get,
    route: '/<id>',
    handler: (Request request, String id) {
      final Event? event = _events
          .where((Event event) => event.id == id)
          .firstOrNull;

      if (event == null) {
        return Response.notFound('No event found with id $id');
      }

      return Response.ok(
        json.encode(event),
        headers: {'Content-Type': 'application/json'},
      );
    },
  );

  final List<Event> _events = Defaults.events;

  // Root endpoint that returns a JSON of all currently stored events.
  Endpoint get _rootEndpoint => Endpoint(
    method: HTTPMethod.get,
    route: '/',
    handler: (Request request) {
      return Response.ok(
        json.encode(_events),
        headers: {'Content-Type': 'application/json'},
      );
    },
  );
}
