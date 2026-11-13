import 'package:flutter_map/flutter_map.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:material_ui/material_ui.dart';

import '../../../domain/models/location/scas_locations.dart';

extension SCASLocationMarker on SCASLocation {
  Marker get marker => throw UnsupportedError(
    'marker getter is unsupported for abstract SCASLocation',
  );

  Color get markerColour => throw UnsupportedError(
    'markerColour getter is unsupported for abstract SCASLocation',
  );
}

extension AmbulanceStationMarker on AmbulanceStation {
  Marker get marker {
    final double height = 20;
    final double width = 20;
    return Marker(
      height: height,
      width: width,
      point: latlng,
      child: Container(
        color: markerColour,
        child: Icon(Symbols.ambulance, color: Colors.black, size: height - 4),
      ),
    );
  }

  Color get markerColour => Colors.grey.shade200;
}

extension EmergencyOperationsCentreMarker on EmergencyOperationsCentre {
  Marker get marker => Marker(
    point: latlng,
    child: Icon(Icons.location_on, color: markerColour, size: 20),
  );

  Color get markerColour => Colors.blue;
}
