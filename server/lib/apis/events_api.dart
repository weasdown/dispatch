import 'dart:convert';

import 'package:dispatch/data/services/local_data_service.dart';
import 'package:dispatch/domain/models/event/event.dart';
import 'package:shelf/shelf.dart';

import 'api.dart';
import 'endpoint.dart';
import 'http_api.dart';

/// Implements a simple events API.
final class EventApi extends Api with HttpApi {
  EventApi({required this.localDataService});

  Handler get _allEvents => (Request request) {
    print('\nRunning EventApi._rootEndpoint');
    return Response.ok(
      json.encode(localDataService.events),
      headers: {'Content-Type': 'application/json'},
    );
  };

  @override
  String get baseRoute => '/events';

  @override
  List<Endpoint> get endpoints => [rootEndpoint, getEventById];

  /// Gets an event by its id.
  Endpoint get getEventById => Endpoint(
    method: HTTPMethod.get,
    parentRoute: baseRoute,
    route: '/<id>',
    handler: (Request request, String id) {
      print('\nRunning EventApi._getEventById');
      final Event? event = localDataService.events
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

  final LocalDataService localDataService;

  // Root endpoint that returns a JSON of all currently stored events.
  Endpoint get rootEndpoint => Endpoint(
    method: HTTPMethod.get,
    parentRoute: baseRoute,
    route: '/',
    handler: _allEvents,
  );
}
