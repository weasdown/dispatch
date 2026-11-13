import 'dart:convert';

import 'package:dispatch/domain/models/event/event.dart';
import 'package:dispatch/domain/models/event/noc.dart';
import 'package:dispatch/domain/models/location/address.dart';
import 'package:latlong2/latlong.dart';
import 'package:logging/logging.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../config/constants.dart';
import 'api.dart';

/// Allows the user to create and update events.
class EventApi implements Api {
  EventApi() {
    // Create a default event
    _events.add(
      Event.withNOC(
        idNum: nextIDNum,
        address: Address(
          flatNumberOrName: 'Next',
          buildingName: 'Westgate Shopping Centre',
          townOrCity: 'Oxford',
        ),
        location: LatLng(51.748863260384894, -1.261667647754695),
        noc: Cat3NOC.fallInjuriesUnknown(),
      ),
    );
  }

  int _currentIDNum = 0;

  // TODO convert to storing events in a SQL database.
  /// Events are kept in memory for demo purposes.
  final List<Event> _events = List.empty(growable: true);

  @override
  Logger get log => Logger('EventApi');

  /// Used to generate IDs for events.
  int get nextIDNum {
    _currentIDNum = _currentIDNum += 1;
    return _currentIDNum;
  }

  @override
  Router get router {
    final router = Router();

    /// Get all events.
    router.get('/', (Request request) {
      return Response.ok(
        json.encode(_events),
        headers: Constants.contentTypeJSON,
      );
    });

    /// Get an event by its ID.
    router.get('/<id>', (Request request, String id) {
      final event = _events
          .where((event) => event.id.toString() == id)
          .firstOrNull;

      if (event == null) {
        return Response.notFound('Invalid ID');
      }

      return Response.ok(
        json.encode(event),
        headers: Constants.contentTypeJSON,
      );
    });

    /// Save a new event.
    router.post('/', (Request request) async {
      final body = await request.readAsString();

      late final Map<String, dynamic>? eventJSON;
      try {
        eventJSON = json.decode(body);
      } on FormatException catch (e) {
        return Response.badRequest(
          body: 'Invalid request body: $e',
          headers: Constants.contentTypeJSON,
        );
      }

      final event = Event.fromJson(eventJSON!, nextIDNum);

      // Store booking
      _events.add(event);

      // Respond with newly created event
      return Response(
        201, // created
        body: json.encode(event),
        headers: Constants.contentTypeJSON,
      );
    });

    return router;
  }
}
