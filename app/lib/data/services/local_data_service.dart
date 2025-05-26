// Copyright 2024 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:latlng/latlng.dart';

import '../../domain/models/event/event.dart';
import '../../domain/models/noc.dart';
import '../../domain/models/unit/unit.dart';
import '../../domain/models/user/user.dart';

class LocalDataService {
  LocalDataService() : _events = _defaultEvents, _units = _defaultUnits;

  final List<Event> _events;

  List<Event> get events => _events;

  final List<Unit> _units;

  List<Unit> get units => _units;

  User get user {
    return const User(
      name: 'Sofie',
      esr: 12353248763,
      // For demo purposes we use a local asset
      picture: 'assets/user.jpg',
    );
  }
}

/// A default list of units.
final List<Unit> _defaultUnits = [
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

/// A default list of events.
final List<Event> _defaultEvents = [
  Event.preAlert(id: 423124, address: 'Sainsbury\'s Kidlington'),
  Event.preAlert(id: 423125, address: '47 Hamble Drive Abingdon'),
  Event.withNOC(
    id: 423129,
    address: 'Carfax Tower, Oxford',
    noc: Cat2NOC.c2Stabbing(),
  )..assignedUnits = [_defaultUnits[2]],
  Event.withNOC(
    id: 423126,
    address: '25 Old Union Way, Thame',
    noc: Cat4NOC.medicalMinor(),
  )..assignedUnits = [_defaultUnits[1]],
  Event.withNOC(
      id: 423127,
      address: '6 The Greenway, Oxfordshire',
      noc: Cat1NOC.c1ArrestPeriArrest(),
    )
    ..assignedUnits = [
      _defaultUnits[0],
      _defaultUnits[4],
      _defaultUnits[6],
      _defaultUnits[7],
    ],
  Event.withNOC(
    id: 423128,
    address: 'Thatcham Station',
    noc: Cat4NOC.mentalHealth(),
  )..assignedUnits = [_defaultUnits[5]],
  Event.withNOC(
    id: 423130,
    address: 'Next, Westgate Shopping Centre, Oxford',
    noc: Cat3NOC.fallInjuriesUnknown(),
  )..assignedUnits = [_defaultUnits[3]],
];
