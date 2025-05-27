import 'package:dispatch/domain/models/unit/unit.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../map.dart';
import 'vehicle_type.dart';

extension UnitMapMarker on Unit {
  /// Path to the image used as this [Event]'s icon.
  String get _iconAsset => switch (vehicleType) {
    VehicleType.dca => 'assets/images/dca.png',
    VehicleType.rrv => 'assets/images/rrv.png',
    VehicleType.helicopter => 'assets/images/tvaa.jpg',
    VehicleType.criticalCareCar => 'assets/images/hems-car.png',
    // FIXME: give the CFR a unique image.
    VehicleType.communityFirstResponder => 'assets/images/rrv.png',
  };

  /// Gets a [Marker] for showing this [Unit] on a map.
  Marker get mapMarker => Marker(
    markerId: MarkerId(callsign),
    position: LatLng(location.latitude.degrees, location.longitude.degrees),
    icon: markerIcon(_iconAsset),
    infoWindow: InfoWindow(
      title: '$callsign (${vehicleType.name})',
      snippet: location.toString(),
    ),
  );
}
