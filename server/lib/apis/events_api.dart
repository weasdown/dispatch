import 'dart:convert';

import 'package:dispatch/data/services/local_data_service.dart';
import 'package:dispatch/domain/models/event/event.dart';
import 'package:server/apis/endpoint.dart';
import 'package:shelf/shelf.dart';

import 'api.dart';
import 'http_api.dart';

/// Implements a simple events API.
final class EventApi extends Api with HttpApi {
  EventApi({required LocalDataService localDataService})
    : _localDataService = localDataService;

  @override
  String get baseRoute => '/event';

  @override
  List<Endpoint> get endpoints => [rootEndpoint, getEventById];

  /// Gets an event by its id.
  Endpoint get getEventById => Endpoint(
    method: HTTPMethod.get,
    parentRoute: baseRoute,
    route: '/<id>',
    handler: (Request request, String id) {
      final Event? event = _localDataService.events
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

  final LocalDataService _localDataService;

  // Root endpoint that returns a JSON of all currently stored events.
  Endpoint get rootEndpoint => Endpoint(
    method: HTTPMethod.get,
    parentRoute: baseRoute,
    route: '/',
    handler: (Request request) {
      return Response.ok(
        json.encode(_localDataService.events),
        headers: {'Content-Type': 'application/json'},
      );
    },
  );
}
