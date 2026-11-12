// ignore_for_file: avoid_print

/// Example of getting a route between two lat-long points using the `computeRoute` method of the [Google Maps Routes API](https://developers.google.com/maps/documentation/routes).
library;

import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

import '../../../../domain/models/location/waypoints.dart';
import 'routes_api.dart';

void main() async {
  final LatLng origin = LatLng(
    51.606581509132056,
    -1.2469909787825841,
  ); // Didcot base
  final LatLng destination = LatLng(
    51.57771040270499,
    -1.567853251019548,
  ); // White horse

  final Map<String, String> envVars = Platform.environment;

  final String apiKey = envVars['GOOGLE_MAPS_API_KEY']!;
  print('apiKey: "$apiKey"');

  final Map<String, String> headers = {
    'X-Goog-Api-Key': apiKey,
    'X-Goog-FieldMask':
        'routes.duration,routes.distanceMeters,routes.polyline.encodedPolyline',
  };

  final String body = json.encode({
    // "origin": {"address": "1600 Amphitheatre Parkway, Mountain View, CA"},
    "origin": origin.queryFields,
    // "destination": {"address": "450 Serra Mall, Stanford, CA"},
    "destination": destination.queryFields,
  });

  final http.Response response = await http.post(
    Uri.parse('https://routes.googleapis.com/directions/v2:computeRoutes'),
    headers: headers,
    body: body,
  );

  if (response.statusCode != 200) {
    // TODO convert base Exception to more appropriate class
    throw Exception(
      'Unexpected response with status code ${response.statusCode}. Response body: ${response.body}',
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
  // print('Response body: $respBody');

  final GoogleMapsRouteResponse routeResponse =
      GoogleMapsRouteResponse.fromJson(routesJSON: json.decode(respBody));

  print('Route response: $routeResponse');

  final Waypoints points = GoogleMapsRoutesAPI().decodePolyline(
    routeResponse.routes.first.polyline!["encodedPolyline"],
  );

  print(points);
}
