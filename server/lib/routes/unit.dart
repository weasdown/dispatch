import 'dart:convert';

import 'package:dispatch/domain/models/unit/unit.dart';
import 'package:logging/logging.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../config/assets.dart';
import '../config/constants.dart';
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
      return Response.ok(
        json.encode(_units),
        headers: Constants.contentTypeJSON,
      );
    });

    // /// Get an unit by its callsign.
    // router.get('/<id>', (Request request, String id) {
    //   final unit = _units.where((unit) => unit.id.toString() == id).firstOrNull;
    //
    //   if (unit == null) {
    //     return Response.notFound('Invalid ID');
    //   }
    //
    //   return Response.ok(json.encode(unit), headers: Constants.contentTypeJSON);
    // });

    // /// Save a new unit.
    // router.post('/', (Request request) async {
    //   final body = await request.readAsString();
    //
    //   late final Map<String, dynamic>? unitJSON;
    //   try {
    //     unitJSON = json.decode(body);
    //   } on FormatException catch (e) {
    //     return Response.badRequest(
    //       body: 'Invalid request body: $e',
    //       headers: Constants.contentTypeJSON,
    //     );
    //   }
    //
    //   late final Unit? unit;
    //   try {
    //     unit = Unit.fromJson(unitJSON!, nextIDNum);
    //   } on Exception catch (e) {
    //     return Response.badRequest(
    //       body: 'Invalid request body: $e',
    //       headers: Constants.contentTypeJSON,
    //     );
    //   }
    //
    //   _units.add(unit); // Store unit
    //
    //   late final String? encodedEvent;
    //   try {
    //     encodedEvent = json.encode(unit);
    //   } on JsonUnsupportedObjectError catch (e) {
    //     return Response.internalServerError(
    //       body: 'Failed to encode built unit for response: $e.',
    //     );
    //   }
    //
    //   // Respond with newly created unit
    //   return Response(
    //     201, // created
    //     body: encodedEvent,
    //     headers: Constants.contentTypeJSON,
    //   );
    // });

    return router;
  }

  final List<Unit> _units = Assets.units;
}
