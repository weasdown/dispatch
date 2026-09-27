import 'package:dispatch/domain/models/unit/unit.dart';
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';

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

  /// Gets an [AdvancedMarker] for showing this [Unit] on a map.
  AdvancedMarker get advancedMapMarker => AdvancedMarker(
    markerId: MarkerId(callsign),
    position: LatLng(location.latitude.degrees, location.longitude.degrees),
    icon: _markerIcon(_iconAsset),
    infoWindow: InfoWindow(
      title: '$callsign (${vehicleType.name})',
      snippet: '${location.latitude.degrees}, ${location.longitude.degrees}',
    ),
  );

  AssetMapBitmap _markerIcon(String asset) => AssetMapBitmap(asset, height: 40);
}
