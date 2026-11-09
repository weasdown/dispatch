import 'package:latlong2/latlong.dart';

typedef Route = List<LatLng>;

extension RouteMethods on Route {
  LatLng get destination => last;
}
