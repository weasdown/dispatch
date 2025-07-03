import 'dart:convert';

import 'package:dispatch/data/services/local_data_service.dart';
import 'package:dispatch/domain/models/unit/unit.dart';
import 'package:dispatch/domain/models/unit/vehicle_type.dart';
import 'package:shelf/shelf.dart';

import 'api.dart';
import 'endpoint.dart';
import 'http_api.dart';

/// Implements a simple units API.
final class UnitApi extends Api with HttpApi {
  UnitApi({required this.localDataService});

  @override
  String get baseRoute => '/units';

  @override
  List<Endpoint> get endpoints => [_rootEndpoint, getUnitByCallsign];

  /// Gets a unit by its callsign.
  Endpoint get getUnitByCallsign => Endpoint(
    method: HTTPMethod.get,
    parentRoute: baseRoute,
    route: '/<callsign>',
    handler: (Request request, String callsign) {
      print('\nRunning UnitApi.getUnitByCallsign');
      final Unit? unit = localDataService.units
          .where((Unit unit) => unit.callsign == callsign)
          .firstOrNull;

      if (unit == null) {
        return Response.notFound('No unit found with callsign $callsign');
      }

      return Response.ok(
        json.encode(unit),
        headers: {'Content-Type': 'application/json'},
      );
    },
  );

  // FIXME fix UnitApi.getUnitByVehicleType
  /// Gets a unit by its [Unit.vehicleType].
  Endpoint get getUnitByVehicleType => Endpoint(
    method: HTTPMethod.get,
    parentRoute: baseRoute,
    route: '/<vehicleType>',
    handler: (Request request, String vehicleType) {
      print('\nRunning UnitApi.getUnitByVehicleType');
      final Unit? unit = localDataService.units
          .where((Unit unit) => unit.vehicleType.name == vehicleType)
          .firstOrNull;

      if (unit == null) {
        return Response.notFound('No unit found with vehicleType $vehicleType');
      }

      return respondOkJSON(unit);
    },
  );

  final LocalDataService localDataService;

  // Root endpoint that returns a JSON of all currently stored events.
  Endpoint get _rootEndpoint => Endpoint(
    method: HTTPMethod.get,
    parentRoute: baseRoute,
    route: '/',
    handler: (Request request) {
      print('\nRunning UnitApi._rootEndpoint');
      return Response.ok(
        json.encode(localDataService.units),
        headers: {'Content-Type': 'application/json'},
      );
    },
  );
}
