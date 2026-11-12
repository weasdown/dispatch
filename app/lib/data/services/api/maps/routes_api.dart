import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:logging/logging.dart';

import '../../../../domain/models/location/waypoints.dart';
import '../../../../utils/result.dart';
import '../env.dart';

sealed class RoutesAPI {
  Future<Result<GoogleMapsRouteResponse>> getRoute(
    LatLng origin,
    LatLng destination,
  );

  Uri get root;
}

/// Implements the [Google Maps Routes API](https://developers.google.com/maps/documentation/routes).
final class GoogleMapsRoutesAPI implements RoutesAPI {
  String get apiKey => Environment.googleMapsApiKey;

  /// Get a route from a start point to a destination.
  ///
  /// See [Get a route](https://developers.google.com/maps/documentation/routes/compute_route_directions).
  @override
  Future<Result<GoogleMapsRouteResponse>> getRoute(
    LatLng origin,
    LatLng destination,
  ) async {
    /*
    curl -X POST -d '{
    "origin":{
      "address": "1600 Amphitheatre Parkway, Mountain View, CA"
    },
    "destination":{
      "address": "450 Serra Mall, Stanford, CA"
    }
  }' \
  -H 'Content-Type: application/json' -H 'X-Goog-Api-Key: API_KEY' \
  -H 'X-Goog-FieldMask: routes.duration,routes.distanceMeters' \
  'https://routes.googleapis.com/directions/v2:computeRoutes'
*/

    _log.severe('GoogleMapsRoutesAPI.getRoute() is not yet implemented.');

    final Map<String, String> headers = {
      'X-Goog-Api-Key': apiKey,
      'X-Goog-FieldMask': 'routes.duration,routes.distanceMeters,routes.polyline.encodedPolyline',
    };

    final String body = json.encode({
      // "origin": {"address": "1600 Amphitheatre Parkway, Mountain View, CA"},
      "origin": origin.queryFields,
      // "destination": {"address": "450 Serra Mall, Stanford, CA"},
      "destination": destination.queryFields,
    });

    final http.Response response = await http.post(
      root,
      headers: headers,
      body: body,
    );

    if (response.statusCode != 200) {
      // TODO convert base Exception to more appropriate class
      return Result.error(
        Exception(
          'Unexpected response with status code ${response.statusCode}. Response body: ${response.body}',
        ),
      );
    }

    /*
    {
      "routes": [
        {
          "distanceMeters": 25135,
          "duration": "1898s",
          "polyline": {
            "encodedPolyline": "{j~yHlprFJtCFB?TCBb@xFPnEHrDFd@BNL@HRCZGHGB?dAFrA`@jGLhCz@fKf@|GP|Bn@hMPbEF~ILhC\\|ClAtJ^zDHzEL~A^bCx@nCfA|DLx@Fx@HzDBjFB|@tA~HpBnIf@h@VHBFn@?LBlCUxAIrFBnD_@bC]rCKrA?pKd@|Cb@lC`@nCV~ATf@ORKRFLZ?`@IZSJC?}@pBgErMqBrFsAfEs@xC_@pB_BnKu@dEu@pFKrACxB?bFErAKjBUvCY|BOhA{@|DyA|E}ArEwAhD{ArDuArE_ApDg@bD[vDOlC]tKSrD_@|DsAhMAb@A^@VIREBIh@IXc@hJGvB@rCDfCGdMUbS]dK?zBDz@XbDApAMtAcBjLYnCKjCDnKo@vTAbCTxDLjBFzAG`F[jJA|DB`BTzD^tCx@hFF~@L`Ff@~FBdAI`JOdGKhCCjBB~ATlBjCxMTvArCvVTtBHnBB~BGfHBpB`@xG`BjR~@lNXrFL|CFlFAfHAvCD`En@hJRrGNfHFnAJpAp@dFr@~Hb@bDv@lFX|BrAvPVxDl@xK|@~JT|EXbANRBPLdB|@fHXjGVxCl@zDr@tC`D`LjF|T`AzEPfALlAHdAFhBFLCLDTJ@BPGNC@RxCXhCv@dLj@hNFl@HB@NIHf@tFPnBJJARABN|@LCHNjA[d@B^T`@l@f@fA`@nAfAzEnBzJd@`DNvCJbFZAAfIDnDClI@rGGnEMxBs@bGs@zEY~BCnALlEVbEdAnIVtDBnB?pBGrEChGDfCh@xKNjCJlENnBTxAtAzHp@dFL`BbAvP`@zGd@zGdA~Ln@rI@jAXbDlBjO\\nDFvBCdLH|FRnDXdCb@rBtAtETj@x@~AzAbCz@pBt@rCVrBHbDG`CMvDGfDh@xJTzH@lBIhBm@nEGjAElFMpA]fBi@xBQxAKzAC`BL~GAjHQnDWpCOjAS|Bu@xGMjBGfCB`Bn@~NFhECnBI`C@vIExEUbGErNCvDM`FSfB]hBsAdGK~@CbBLbENbD?jA]hFArCRbLXfI\\~GDrEFpD^pGCr@LfCBt@?|@QnDKbB]dDM|BCrBFjCTfCh@fFApBSrKSxIQhCO`BqBbNI`AAp@JdARtAj@|Bj@~Ah@`BLr@?f@Ib@QPWF]EqAi@a@Ga@HYRa@x@g@xBaAzFw@`EQlAElADj@DTTl@h@z@^`@t@f@HLJZXzDLt@Nr@`AvCPdAJvDP~Bx@fGJlAFzB?dAKlCSnBq@vEOjAG|A?jD`Bd@xCp@v@`@bCtBrAz@lB|@`BjAjBn@zBPTBj@VX\\Hr@"
          }
        }
      ]
    }
     */
    final String respBody = response.body;
    _log.fine('Response body: $respBody');
    // final Waypoints route = [];

    final GoogleMapsRouteResponse routeResponse =
        GoogleMapsRouteResponse.fromJson(
          routesJSON: json.decode(response.body),
        );

    final String polyline =
        routeResponse.routes.first.polyline!['encodedPolyline'] as String;
    _log.fine('Polyline: "${polyline.replaceAll("\\\\", "\\")}"');

    return Result.ok(routeResponse);
  }

  Logger get _log => Logger('GoogleMapsRoutesAPI')..level = Level.ALL;

  @override
  Uri get root =>
      Uri.parse('https://routes.googleapis.com/directions/v2:computeRoutes');
}

extension QueryFields on LatLng {
  Map<String, dynamic> get queryFields => {
    "location": {
      "latLng": {"latitude": latitude, "longitude": longitude},
    },
  };
}

/// Example response:
///
/// ```json
/// {
///   "routes": [
///     {
///       "distanceMeters": 25135,
///       "duration": "1898s",
///       "polyline": {
///         "encodedPolyline": "{j~yHlprFJtCFB?TCBb@xFPnEHrDFd@BNL@HRCZGHGB?dAFrA`@jGLhCz@fKf@|GP|Bn@hMPbEF~ILhC\\|ClAtJ^zDHzEL~A^bCx@nCfA|DLx@Fx@HzDBjFB|@tA~HpBnIf@h@VHBFn@?LBlCUxAIrFBnD_@bC]rCKrA?pKd@|Cb@lC`@nCV~ATf@ORKRFLZ?`@IZSJC?}@pBgErMqBrFsAfEs@xC_@pB_BnKu@dEu@pFKrACxB?bFErAKjBUvCY|BOhA{@|DyA|E}ArEwAhD{ArDuArE_ApDg@bD[vDOlC]tKSrD_@|DsAhMAb@A^@VIREBIh@IXc@hJGvB@rCDfCGdMUbS]dK?zBDz@XbDApAMtAcBjLYnCKjCDnKo@vTAbCTxDLjBFzAG`F[jJA|DB`BTzD^tCx@hFF~@L`Ff@~FBdAI`JOdGKhCCjBB~ATlBjCxMTvArCvVTtBHnBB~BGfHBpB`@xG`BjR~@lNXrFL|CFlFAfHAvCD`En@hJRrGNfHFnAJpAp@dFr@~Hb@bDv@lFX|BrAvPVxDl@xK|@~JT|EXbANRBPLdB|@fHXjGVxCl@zDr@tC`D`LjF|T`AzEPfALlAHdAFhBFLCLDTJ@BPGNC@RxCXhCv@dLj@hNFl@HB@NIHf@tFPnBJJARABN|@LCHNjA[d@B^T`@l@f@fA`@nAfAzEnBzJd@`DNvCJbFZAAfIDnDClI@rGGnEMxBs@bGs@zEY~BCnALlEVbEdAnIVtDBnB?pBGrEChGDfCh@xKNjCJlENnBTxAtAzHp@dFL`BbAvP`@zGd@zGdA~Ln@rI@jAXbDlBjO\\nDFvBCdLH|FRnDXdCb@rBtAtETj@x@~AzAbCz@pBt@rCVrBHbDG`CMvDGfDh@xJTzH@lBIhBm@nEGjAElFMpA]fBi@xBQxAKzAC`BL~GAjHQnDWpCOjAS|Bu@xGMjBGfCB`Bn@~NFhECnBI`C@vIExEUbGErNCvDM`FSfB]hBsAdGK~@CbBLbENbD?jA]hFArCRbLXfI\\~GDrEFpD^pGCr@LfCBt@?|@QnDKbB]dDM|BCrBFjCTfCh@fFApBSrKSxIQhCO`BqBbNI`AAp@JdARtAj@|Bj@~Ah@`BLr@?f@Ib@QPWF]EqAi@a@Ga@HYRa@x@g@xBaAzFw@`EQlAElADj@DTTl@h@z@^`@t@f@HLJZXzDLt@Nr@`AvCPdAJvDP~Bx@fGJlAFzB?dAKlCSnBq@vEOjAG|A?jD`Bd@xCp@v@`@bCtBrAz@lB|@`BjAjBn@zBPTBj@VX\\Hr@"
///       }
///     }
///   ]
/// }
/// ```
final class GoogleMapsRouteResponse {
  const GoogleMapsRouteResponse({required this.routes});

  factory GoogleMapsRouteResponse.fromJson({
    required Map<String, dynamic> routesJSON,
  }) => switch (routesJSON) {
    {'routes': List<dynamic> routesJSONs} => GoogleMapsRouteResponse(
      routes: List<Map<String, dynamic>>.from(routesJSONs)
          .map(
            (Map<String, dynamic> routeJSON) =>
                Route.fromJson(routesJSON: routeJSON),
          )
          .toList(),
    ),
    _ => throw FormatException(
      'Failed to load Google Maps route response. Response body: $routesJSON',
    ),
  };

  final List<Route> routes;

  @override
  String toString() =>
      'GoogleMapsRouteResponse with ${routes.length} route${routes.length != 1 ? 's' : ''}';
}

/// Example response:
///
/// ```json
/// {
///   "distanceMeters": 25135,
///   "duration": "1898s",
///   "polyline": {
///     "encodedPolyline": "{j~yHlprFJtCFB?TCBb@xFPnEHrDFd@BNL@HRCZGHGB?dAFrA`@jGLhCz@fKf@|GP|Bn@hMPbEF~ILhC\\|ClAtJ^zDHzEL~A^bCx@nCfA|DLx@Fx@HzDBjFB|@tA~HpBnIf@h@VHBFn@?LBlCUxAIrFBnD_@bC]rCKrA?pKd@|Cb@lC`@nCV~ATf@ORKRFLZ?`@IZSJC?}@pBgErMqBrFsAfEs@xC_@pB_BnKu@dEu@pFKrACxB?bFErAKjBUvCY|BOhA{@|DyA|E}ArEwAhD{ArDuArE_ApDg@bD[vDOlC]tKSrD_@|DsAhMAb@A^@VIREBIh@IXc@hJGvB@rCDfCGdMUbS]dK?zBDz@XbDApAMtAcBjLYnCKjCDnKo@vTAbCTxDLjBFzAG`F[jJA|DB`BTzD^tCx@hFF~@L`Ff@~FBdAI`JOdGKhCCjBB~ATlBjCxMTvArCvVTtBHnBB~BGfHBpB`@xG`BjR~@lNXrFL|CFlFAfHAvCD`En@hJRrGNfHFnAJpAp@dFr@~Hb@bDv@lFX|BrAvPVxDl@xK|@~JT|EXbANRBPLdB|@fHXjGVxCl@zDr@tC`D`LjF|T`AzEPfALlAHdAFhBFLCLDTJ@BPGNC@RxCXhCv@dLj@hNFl@HB@NIHf@tFPnBJJARABN|@LCHNjA[d@B^T`@l@f@fA`@nAfAzEnBzJd@`DNvCJbFZAAfIDnDClI@rGGnEMxBs@bGs@zEY~BCnALlEVbEdAnIVtDBnB?pBGrEChGDfCh@xKNjCJlENnBTxAtAzHp@dFL`BbAvP`@zGd@zGdA~Ln@rI@jAXbDlBjO\\nDFvBCdLH|FRnDXdCb@rBtAtETj@x@~AzAbCz@pBt@rCVrBHbDG`CMvDGfDh@xJTzH@lBIhBm@nEGjAElFMpA]fBi@xBQxAKzAC`BL~GAjHQnDWpCOjAS|Bu@xGMjBGfCB`Bn@~NFhECnBI`C@vIExEUbGErNCvDM`FSfB]hBsAdGK~@CbBLbENbD?jA]hFArCRbLXfI\\~GDrEFpD^pGCr@LfCBt@?|@QnDKbB]dDM|BCrBFjCTfCh@fFApBSrKSxIQhCO`BqBbNI`AAp@JdARtAj@|Bj@~Ah@`BLr@?f@Ib@QPWF]EqAi@a@Ga@HYRa@x@g@xBaAzFw@`EQlAElADj@DTTl@h@z@^`@t@f@HLJZXzDLt@Nr@`AvCPdAJvDP~Bx@fGJlAFzB?dAKlCSnBq@vEOjAG|A?jD`Bd@xCp@v@`@bCtBrAz@lB|@`BjAjBn@zBPTBj@VX\\Hr@"
///   }
/// }
/// ```
final class Route {
  const Route({
    required this.distanceMeters,
    required this.duration,
    required this.polyline,
  });

  factory Route.fromJson({required Map<String, dynamic> routesJSON}) =>
      switch (routesJSON) {
        {
          'distanceMeters': int distanceMeters,
          'duration': String duration,
          'polyline': Map<String, dynamic> polyline,
        } =>
          Route(
            distanceMeters: distanceMeters,
            duration: duration,
            polyline: polyline,
          ),
        _ => throw const FormatException('Failed to load Route.'),
      };

  final int? distanceMeters;
  final String? duration;
  final Map<String, dynamic>? polyline;

  Waypoints? get points => polyline?["encodedPolyline"];
}
