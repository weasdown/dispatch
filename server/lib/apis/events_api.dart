import 'dart:convert';
import 'dart:math';

import 'package:dispatch/domain/models/event/event.dart';
import 'package:dispatch/domain/models/noc.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../config/assets.dart';
import 'api.dart';

/// Implements a simple events API.
final class EventsApi extends Api {
  @override
  Router get router {
    final router = Router();

    /// Handles requests of all types (GET, POST, etc, including WebSocket requests) at the path '/'.
    router.all('/', (Request request) {
      print('eventHandler received request: ${request.headers}');
      List<Event> events = Assets.events;
      int randomInt = Random().nextInt(10000000);
      events.add(
        Event.withNOC(
          id: randomInt,
          address: 'TEST-$randomInt, Test St, Testfordshire',
          noc: Cat4NOC.nauseaVomiting(),
        ),
      );

      String payload = json.encode(events);
      print('\n- Replying with payload: $payload\n');

      final Response response = Response.ok(
        payload,
        headers: {'Content-Type': 'application/json'},
      );
      print('response headers: ${response.headersAll}');
      return response;
    });

    return router;
  }
}

// Response eventHandler(Request req) {
//   print('eventHandler received request: ${req.headers}');
//   Response response = Response.ok(jsonEncode(Assets.events));
//   print('response: ${response.headersAll}');
//   return response;
// }
