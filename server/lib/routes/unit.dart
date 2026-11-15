import 'dart:convert';

import 'package:dispatch/domain/models/unit/unit.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../config/assets.dart';
import '../config/constants.dart';
import '../json_response.dart';
import 'api.dart';

/// Allows the user to create and update units.
class UnitApi extends Api {
  @override
  Router get router {
    final router = Router();

    /// Get all units.
    router.get('/', (Request request) {
      log.fine('Getting all units');
      return JsonResponse.ok(_units);
    });

    /// Get an unit by its callsign.
    router.get('/<callsign>', (Request request, String callsign) {
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

      if (_unitInDatabase(unit.callsign)) {
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

    /// Delete a unit from the database.
    router.delete('/<callsign>', (Request request, String callsign) {
      if (!_unitInDatabase(callsign)) {
        log.warning(
          'Could not delete $callsign as requested - not in database',
        );
        return JsonResponse.notFound('No unit found with callsign $callsign');
      }

      _units.removeWhere((Unit unit) => unit.callsign == callsign);
      log.fine('Deleted unit $callsign from the database as per user request.');

      return JsonResponse.ok('Unit $callsign deleted.');
    });

    return router;
  }

  bool _unitInDatabase(String callsign) =>
      _units.where((Unit dbUnit) => dbUnit.callsign == callsign).isNotEmpty;

  final List<Unit> _units = Assets.units;
}
