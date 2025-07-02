import 'package:latlng/latlng.dart';

import '../domain/models/event/event.dart';
import '../domain/models/noc.dart';
import '../domain/models/unit/unit.dart';
import '../domain/models/unit/vehicle_type.dart';

/// Class to store default event and unit data.
abstract final class Defaults {
  /// A default list of events.
  static final List<Event> events = [
    Event.preAlert(id: 423124.toString(), address: 'Sainsbury\'s Kidlington'),
    Event.preAlert(id: 423125.toString(), address: '47 Hamble Drive Abingdon'),
    Event.withNOC(
      id: 423129.toString(),
      address: 'Carfax Tower, Oxford',
      noc: Cat2NOC.c2Stabbing(),
    )..dispatchUnit(units[2]),
    Event.withNOC(
      id: 423126.toString(),
      address: '25 Old Union Way, Thame',
      noc: Cat4NOC.medicalMinor(),
    )..dispatchUnit(units[1]),
    Event.withNOC(
      id: 423127.toString(),
      address: '6 The Greenway, Oxfordshire',
      noc: Cat1NOC.c1ArrestPeriArrest(),
    )..dispatchUnits([units[0], units[4], units[6], units[7]]),
    Event.withNOC(
      id: 423128.toString(),
      address: 'Thatcham Station',
      noc: Cat4NOC.mentalHealth(),
    )..dispatchUnit(units[5]),
    Event.withNOC(
      id: 423130.toString(),
      address: 'Next, Westgate Shopping Centre, Oxford',
      noc: Cat3NOC.fallInjuriesUnknown(),
    )..dispatchUnit(units[3]),
  ];

  /// A default list of units.
  static final List<Unit> units = [
    Unit(
      callsign: 'NA136',
      location: LatLng(
        Angle.degree(51.607539604000266),
        Angle.degree(-1.237806756282358),
      ),
    ),
    Unit(
      callsign: 'NA402',
      location: LatLng(Angle.degree(51.605), Angle.degree(-1.238)),
    ),
    Unit(
      callsign: 'NA283',
      location: LatLng(
        Angle.degree(51.616072911907786),
        Angle.degree(-1.2536017723108663),
      ),
    ),
    Unit(
      callsign: 'NA072',
      location: LatLng(
        Angle.degree(51.8296012219854),
        Angle.degree(-1.3134667111590494),
      ),
    ),
    Unit(
      callsign: 'NF159',
      location: LatLng(
        Angle.degree(51.62832936052779),
        Angle.degree(-1.1854888181805424),
      ),
      vehicleType: VehicleType.communityFirstResponder,
    ),
    Unit(
      callsign: 'NR154',
      location: LatLng(
        Angle.degree(51.66706110914126),
        Angle.degree(-1.3082872829130447),
      ),
      vehicleType: VehicleType.criticalCareCar,
    ),
    Unit(
      callsign: 'NT431',
      location: LatLng(
        Angle.degree(51.397809576171085),
        Angle.degree(-1.3230646597735394),
      ),
      vehicleType: VehicleType.rrv,
    ),
    Unit(
      callsign: '0024',
      location: LatLng(
        Angle.degree(51.61832936052779),
        Angle.degree(-1.0854888181805424),
      ),
      vehicleType: VehicleType.helicopter,
    ),
  ];
}
