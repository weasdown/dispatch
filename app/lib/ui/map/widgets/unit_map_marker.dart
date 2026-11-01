import 'package:flutter_map/flutter_map.dart';
import 'package:gap/gap.dart';
import 'package:latlong2/latlong.dart';
import 'package:logging/logging.dart';
import 'package:material_ui/material_ui.dart';

import '../../../domain/models/event/event.dart';
import '../../../domain/models/unit/unit.dart';
import '../../events/view_models/all_events_view_model.dart';
import '../../unit/unit_status_colour.dart';
import '../../unit/view_models/units_view_model.dart';
import '../../unit/widgets/unit_context_menu.dart';

final class UnitMapMarker {
  const UnitMapMarker({
    required this._unit,
    required this._eventsViewModel,
    required this._unitsViewModel,
  });

  final double height = 60;

  final Unit _unit;

  final double width = 52;

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

  Logger get _log {
    final Logger log = Logger('UnitMapMarker (${_unit.callsign})');
    log.level = Level.ALL;
    return log;
  }

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
    eventsViewModel: _eventsViewModel,
    unitsViewModel: _unitsViewModel,
    child: GestureDetector(
      // onSecondaryTap: _onRightClick,
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
    ),
  );

  void _onDoubleTap() {
    _log.fine('Double tapped map marker for ${_unit.callsign}');
  }

  void _onTap() {
    _log.fine('Tapped map marker for ${_unit.callsign}');
    // _viewModel.updateUnit(_unit);
  }

  final AllEventsViewModel _eventsViewModel;

  final UnitsViewModel _unitsViewModel;
}
