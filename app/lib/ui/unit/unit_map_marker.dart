import 'package:dispatch/domain/models/unit/unit.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';
import 'package:google_maps_marker_widgets/google_maps_marker_widgets.dart';

import '../../domain/models/event/event.dart';
import '../map/view_models/map_view_model.dart';

class UnitMapMarker extends StatelessWidget {
  UnitMapMarker({
    super.key,
    required this._unit,
    required this._viewModel,
    this.onDoubleTap,
  }) : markerId = MarkerId(_unit.callsign);

  final Unit _unit;

  /// Latitude.
  double get lat => _unit.location.latitude;

  /// Longitude.
  double get lng => _unit.location.longitude;

  final MarkerId markerId;

  // FIXME use _viewModel for setting selected unit
  final MapViewModel _viewModel;

  void addToMap(MarkerWidgetsController markerWidgetsController) {
    markerWidgetsController.addMarkerWidget(
      markerWidget: MarkerWidget(markerId: markerId, child: this),
      marker: Marker(
        markerId: markerId,
        anchor: Offset(0.5, 0.5),
        position: LatLng(_unit.location.latitude, _unit.location.longitude),
      ),
    );
  }

  /// Path to the image used as this [Event]'s icon.
  String get _iconAsset =>
      switch (_unit.vehicleType) {
    VehicleType.dca => 'assets/images/dca.png',
    VehicleType.rrv => 'assets/images/rrv.png',
    VehicleType.helicopter => 'assets/images/tvaa.jpg',
    VehicleType.criticalCareCar => 'assets/images/hems-car.png',
    // FIXME: give the CFR a unique image.
    VehicleType.communityFirstResponder => 'assets/images/rrv.png',
  };

  AssetMapBitmap _markerIcon(String asset) => AssetMapBitmap(asset, height: 40);

  // TODO move onTap to markerWidget
  /// Gets an [AdvancedMarker] for showing this [Unit] on a map.
  AdvancedMarker get advancedMapMarker =>
      AdvancedMarker(
        onTap: () => debugPrint('Tapped AdvancedMarker for ${_unit.callsign}'),
        markerId: markerId,
        position: LatLng(lat, lng),
        // infoWindow: InfoWindow(
        //   title: _unit.callsign,
        //   snippet: _unit.vehicleType.name,
        // ),
      );

  Widget get _body => Image.asset(_iconAsset, width: 60,);

  MarkerWidget get markerWidget =>
      MarkerWidget(markerId: markerId, child: _body);

  final void Function()? onDoubleTap;

  @override
  Widget build(BuildContext context) {
    return _body;
  }
}
