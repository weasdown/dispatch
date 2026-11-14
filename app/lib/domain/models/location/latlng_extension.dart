import 'package:latlong2/latlong.dart';

extension LatLngJson on LatLng {
  static LatLng fromJson(List<double> json) => LatLng(json[0], json[1]);

  List<double> toJson() => [latitude, longitude];
}
