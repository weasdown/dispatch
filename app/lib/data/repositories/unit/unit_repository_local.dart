import 'dart:convert';
import 'dart:io';
import 'dart:math' show Random;

import 'package:latlong2/latlong.dart';
import 'package:logging/logging.dart';

import '../../../data/services/api/maps/routes_api.dart';
import '../../../domain/models/event/event.dart';
import '../../../domain/models/unit/unit.dart';
import '../../../utils/result.dart';
import '../../services/local_data_service.dart';
import 'unit_repository.dart';

/// Local implementation of UnitRepository
class UnitRepositoryLocal extends UnitRepository {
  UnitRepositoryLocal({required this._localDataService}) {
    // UnitRepositoryLocal._getRoute();
  }

  // Only create default unit once.
  bool _isInitialized = false;

  final _units = List<Unit>.empty(growable: true);
  final LocalDataService _localDataService;

  @override
  Future<Result<List<Unit>>> get allUnits => unitsList;

  List<String> get _callsigns =>
      _units.map((Unit unit) => unit.callsign).toList();

  // FIXME remove this method - testing only.
  // ignore: unused_element
  static Future<Result<GoogleMapsRouteResponse>> _getRoute() async {
    _log.fine('Getting route');
    final RoutesAPI routesAPI = GoogleMapsRoutesAPI();
    final Result<GoogleMapsRouteResponse> routeResult = await routesAPI
        .getRoute(
          // LatLng(51.606581509132056, -1.2469909787825841), // Didcot base
          LatLng(
            51.59163472547848,
            -1.427988579419376,
          ), // Smith's Wharf, Wantage
          LatLng(51.57771040270499, -1.567853251019548), // White horse
        );

    switch (routeResult) {
      case Ok<GoogleMapsRouteResponse>():
        _log.finer('Parsed routeResult: ${routeResult.value}');
      case Error<GoogleMapsRouteResponse>():
        _log.warning('Failed to parse routeResult: ${routeResult.error}');
    }

    return routeResult;
  }

  Unit? _getUnitByCallsign(String callsign) =>
      _units.where((Unit unit) => unit.callsign == callsign).firstOrNull;

  static Logger get _log => Logger('UnitRepositoryLocal')..level = Level.ALL;

  /// Gets a [Result.ok] holding a random unit from `_units`.
  @override
  Future<Result<Unit?>> get selectedUnit async =>
      Result.ok(_units[Random().nextInt(_units.length)]);

  @override
  Future<Result<void>> standdownUnit(Unit unit) async {
    final Unit? foundUnit = _getUnitByCallsign(unit.callsign);
    if (foundUnit == null) {
      return Result<void>.error(UnitNotFoundException(callsign: unit.callsign));
    }

    final Event? assignedEvent = foundUnit.assignedEvent;
    if (assignedEvent == null) {
      return Result<void>.error(NoAllocatedEventException(unit: unit));
    }

    log.fine(
      'Standing down ${unit.callsign} from event ${assignedEvent.idLastFour}',
    );
    return Result<void>.ok(foundUnit.standdown());
  }

  @override
  Future<Result<Unit>> unitByCallsign(String callsign) async {
    final unit = _getUnitByCallsign(callsign);
    return (unit != null)
        ? Result.ok(unit)
        : Result.error(Exception('Unit not found'));
  }

  Future<Result<List<Unit>>> get unitsList async {
    // Initialize the repository with a default unit.
    if (!_isInitialized) {
      _units.addAll(_localDataService.units);
      _isInitialized = true;
    }

    return Result.ok(_units);
  }

  // TODO finish adding data in unit_routes.json
  @override
  Map<String, List<LatLng>> unitRoutes() {
    // {
    //   "NT431": {
    //     "start": "Didcot RC",
    //     "points": [...],
    //   },
    //   ...
    // }
    final File routesFile = File('lib/data/services/api/maps/unit_routes.json');
    final Map<String, dynamic> routesJSON = json.decode(
      routesFile.readAsStringSync(),
    );

    final Map<String, List<LatLng>> unitRoutes = routesJSON.map((
      String callsign,
      dynamic data,
    ) {
      final _UnitPointsData unitPointsData = _UnitPointsData.fromJson(
        pointsDataJSON: data as Map<String, dynamic>,
      );
      final List<LatLng> pointsData = List<LatLng>.from(
        unitPointsData.points.map(
          (Map<String, double> pointEntry) =>
              LatLng(pointEntry['lat']!, pointEntry['long']!),
        ),
      );
      return MapEntry(callsign, pointsData);
    });

    return unitRoutes;
  }

  /// Mapping of unit callsigns to how long the unit will take to arrive.
  @override
  Map<String, Duration> unitTravelTimes() => {
    'NF159': Duration(minutes: 5),
    'NA136': Duration(minutes: 12),
    'NA402': Duration(minutes: 18),
    'NT431': Duration(minutes: 20),
    '0024': Duration(minutes: 22),
  };

  @override
  Future<Result<void>> updateUnit(String callsign, Unit newUnit) async {
    _log.finer('Updating unit $callsign');
    if (!_callsigns.contains(callsign)) {
      return Result<void>.error(UnitNotFoundException(callsign: callsign));
    }

    final int unitIndex = _units.indexWhere(
      (Unit unit) => unit.callsign == callsign,
    );
    _units[unitIndex] = newUnit;
    updatedUnitStreamController.sink.add(newUnit);
    return Result.ok(null);
  }
}

class _UnitPointsData {
  _UnitPointsData({required this.start, required this.points});

  final String start;
  final List<Map<String, double>> points;

  factory _UnitPointsData.fromJson({
    required Map<String, dynamic> pointsDataJSON,
  }) => switch (pointsDataJSON) {
    {'start': String start, 'points': List<dynamic> points} => _UnitPointsData(
      start: start,
      points: List<Map<String, double>>.from(
        points.map(
          (dynamic point) =>
              (point as Map<String, dynamic>).cast<String, double>(),
        ),
      ),
    ),
    _ => throw FormatException(
      'Failed to load _UnitPointsData is a ${pointsDataJSON.runtimeType}, with ${pointsDataJSON['points']!.runtimeType} points.',
    ),
  };
}
