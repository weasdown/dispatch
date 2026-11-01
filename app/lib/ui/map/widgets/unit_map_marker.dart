import 'package:flutter_map/flutter_map.dart';
import 'package:gap/gap.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' hide Marker;
import 'package:google_maps_marker_widgets/google_maps_marker_widgets.dart';
import 'package:latlong2/latlong.dart' as ll2;
import 'package:material_ui/material_ui.dart';

import '../../../domain/models/event/event.dart';
import '../../../domain/models/unit/unit.dart';
import '../../unit/unit_status_colour.dart';

class UnitMapMarker extends StatelessWidget {
  const UnitMapMarker({super.key, required this._unit});

  final double height = 60;

  final Unit _unit;

  final double width = 52;

  Marker flutterMapMarker(BuildContext context) => Marker(
    point: ll2.LatLng(lat, lng),
    height: height,
    width: width,
    child: _body(context),
  );

  /// Latitude.
  double get lat => _unit.location.latitude;

  /// Longitude.
  double get lng => _unit.location.longitude;

  // // FIXME change _viewModel to correct class and use for setting selected unit
  // final SingleEventScreenViewModel _viewModel;

  /// Path to the image used as this [Event]'s icon.
  String get _iconAsset => switch (_unit.vehicleType) {
    VehicleType.dca => 'assets/images/dca.png',
    VehicleType.rrv => 'assets/images/rrv.png',
    VehicleType.helicopter => 'assets/images/tvaa.jpg',
    VehicleType.criticalCareCar => 'assets/images/hems-car.png',
    // FIXME: give the CFR and co-responder unique images.
    VehicleType.communityFirstResponder ||
    VehicleType.coResponder => 'assets/images/rrv.png',
  };

  Widget _body(BuildContext context) => GestureDetector(
    onTap: _onTap,
    onDoubleTap: _onDoubleTap,
    child: Container(
      // height: 100,
      // width: 80,
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Gap(4),
          Container(
            color: _unit.status.backgroundColour,
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: Text(
                _unit.callsign,
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: _unit.status.textColour,
                ),
                textAlign: TextAlign.center,
                softWrap: false,
              ),
            ),
          ),

          // Gap(4),
          Image.asset(
            _iconAsset,
            height: 35,
            // scale: 0.5,
            width: 50,
            // scale: 0.2,
          ),
        ],
      ),
    ),
  );

  void _onDoubleTap() {
    debugPrint('Double tapped AdvancedMarker for ${_unit.callsign}');
  }

  void _onTap() {
    debugPrint('Tapped AdvancedMarker for ${_unit.callsign}');
    // _viewModel.updateUnit(_unit);
  }

  @override
  Widget build(BuildContext context) {
    final String icon = _iconAsset;
    debugPrint('Unit icon: $icon');
    return _body(context);
  }
}

class UnitGoogleMapsMarker extends UnitMapMarker {
  UnitGoogleMapsMarker({super.key, required super.unit})
    : markerId = MarkerId(unit.callsign);

  // void addToMap(MarkerWidgetsController markerWidgetsController) {
  //   markerWidgetsController.addMarkerWidget(
  //     markerWidget: MarkerWidget(markerId: markerId, child: this),
  //     marker: Marker(
  //       markerId: markerId,
  //       anchor: Offset(0.5, 0.5),
  //       position: LatLng(_unit.location.latitude, _unit.location.longitude),
  //     ),
  //   );
  // }

  // AssetMapBitmap _markerIcon(String asset) => AssetMapBitmap(asset, height: 40);

  // TODO move onTap to markerWidget
  /// Gets an [AdvancedMarker] for showing this [Unit] on a map.
  AdvancedMarker get advancedMapMarker => AdvancedMarker(
    onTap: _onTap,
    markerId: markerId,
    position: LatLng(lat, lng),
    // infoWindow: InfoWindow(
    //   title: _unit.callsign,
    //   snippet: _unit.vehicleType.name,
    // ),
  );

  final MarkerId markerId;

  MarkerWidget markerWidget(BuildContext context) =>
      MarkerWidget(markerId: markerId, child: _body(context));

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
