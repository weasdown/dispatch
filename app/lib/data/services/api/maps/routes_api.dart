import 'package:latlong2/latlong.dart';

import '../../../../domain/models/location/route.dart';
import '../../../../utils/result.dart';

sealed class RoutesAPI {
  Future<Result<Route>> getRoute(LatLng start, LatLng destination);
}

/// Implements the [Google Maps Routes API](https://developers.google.com/maps/documentation/routes).
final class GoogleMapsRoutesAPI implements RoutesAPI {
  /// Get a route from a start point to a destination.
  ///
  /// See [Get a route](https://developers.google.com/maps/documentation/routes/compute_route_directions).
  @override
  Future<Result<Route>> getRoute(LatLng start, LatLng destination) {
    // TODO: implement getRoute
    throw UnimplementedError(
      'GoogleMapsRoutesAPI.getRoute() is not yet implemented.',
    );
  }
}
