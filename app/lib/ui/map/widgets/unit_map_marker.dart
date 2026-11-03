import 'package:flutter_map/flutter_map.dart';
import 'package:gap/gap.dart';
import 'package:latlong2/latlong.dart';
import 'package:material_ui/material_ui.dart';

import '../../../domain/models/event/event.dart';
import '../../../domain/models/unit/unit.dart';
import '../../../ui/map/view_models/map_view_model.dart';
import '../../events/view_models/all_events_view_model.dart';
import '../../unit/unit_status_colour.dart';
import '../../unit/view_models/units_view_model.dart';
import '../../unit/widgets/unit_context_menu.dart';

final class UnitMapMarker {
  const UnitMapMarker({
    required this._unit,
    required this.menuController,
    required this._eventsViewModel,
    required this._unitsViewModel,
    required this._mapViewModel,
  });

  final double height = 60;

  final Unit _unit;

  final double width = 52;

  final ContextMenuController menuController;

  Marker marker(BuildContext context) => Marker(
    point: LatLng(lat, lng),
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

  Widget _body(BuildContext context) => UnitContextMenuRegion(
    unit: _unit,
    controller: menuController,
    eventsViewModel: _eventsViewModel,
    unitsViewModel: _unitsViewModel,
    mapViewModel: _mapViewModel,
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

  final AllEventsViewModel _eventsViewModel;

  // TODO convert to MapViewModel
  final MapViewModel _mapViewModel;

  final UnitsViewModel _unitsViewModel;
}
