import 'dart:convert';

import 'package:dispatch/domain/models/unit/unit.dart';
import 'package:logging/logging.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../config/assets.dart';
import '../config/constants.dart';
import '../json_response.dart';
import 'api.dart';

/// Allows the user to create and update units.
class UnitApi implements Api {
  @override
  Logger get log => Logger('UnitApi');

  @override
  Router get router {
    final router = Router();

    /// Get all units.
    router.get('/', (Request request) {
      log.fine('Getting all units');
      return JsonResponse.ok(_units);
    });

    /// Get an unit by its callsign.
    router.get('/<id>', (Request request, String callsign) {
      final unit = _units
          .where((unit) => unit.callsign.toString() == callsign)
          .firstOrNull;

      if (unit == null) {
        return Response.notFound('Invalid callsign');
      }

      return JsonResponse.ok(unit);
    });

    /// Save a new unit.
    router.post('/', (Request request) async {
      final body = await request.readAsString();

      late final Map<String, dynamic>? unitJSON;
      try {
        unitJSON = json.decode(body);
      } on FormatException catch (e) {
        return Response.badRequest(
          body: 'Invalid request body: $e',
          headers: Constants.contentTypeJSON,
        );
      }

      late final Unit? unit;
      try {
        unit = Unit.fromJson(unitJSON!);
      } on Exception catch (e) {
        return Response.badRequest(
          body: 'Invalid request body: $e',
          headers: Constants.contentTypeJSON,
        );
      }

      if (_unitAlreadyInDatabase(unit.callsign)) {
        return Response.badRequest(
          body:
              'Unit with callsign ${unit.callsign} already exists in the database.',
        );
      }

      _units.add(unit); // Store unit
      log.fine('Added new unit to _units');
      log.fine('Now ${_units.length} units in _units');

      late final String? encodedEvent;
      try {
        encodedEvent = json.encode(unit);
      } on JsonUnsupportedObjectError catch (e) {
        return Response.internalServerError(
          body: 'Failed to encode built unit for response: $e.',
        );
      }

      // Respond with newly created unit
      return Response(
        201, // created
        body: encodedEvent,
        headers: Constants.contentTypeJSON,
      );
    });

    return router;
  }

  bool _unitAlreadyInDatabase(String callsign) =>
      _units.where((Unit dbUnit) => dbUnit.callsign == callsign).isNotEmpty;

  final List<Unit> _units = Assets.units;
}
