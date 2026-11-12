import 'package:latlong2/latlong.dart';

typedef Waypoints = List<LatLng>;

extension RouteMethods on Waypoints {
  LatLng get destination => last;
}
