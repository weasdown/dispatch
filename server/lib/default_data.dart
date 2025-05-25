import 'package:dispatch/domain/models/event.dart';
import 'package:dispatch/domain/models/unit/unit.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// Some example [Unit]s.
List<Unit> defaultUnits = [
  Unit(callsign: 'NA312', location: LatLng(51.5, 0.51)),
  Unit(callsign: 'NA212', location: LatLng(51.7, 0.54)),
  Unit(callsign: 'NR101', location: LatLng(52.5, 0.46)),
  Unit(callsign: 'NT497', location: LatLng(51.0, 0.034)),
];

/// Some example [Event]s.
List<Event> defaultEvents = [
  Event.preAlert(id: 12345, address: '22 Barley Street, Oxford'),
  Event.preAlert(id: 12455, address: '153 Acacia Avenue, Milton Keynes'),
];
