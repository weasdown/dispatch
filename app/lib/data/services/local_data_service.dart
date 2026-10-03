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
    location: LatLng.degree(51.607539604000266, -1.237806756282358),
  ),
  Unit(callsign: 'NA402', location: LatLng.degree(51.605, -1.238)),
  Unit(
    callsign: 'NA283',
    location: LatLng.degree(51.616072911907786, -1.2536017723108663),
  ),
  Unit(
    callsign: 'NA072',
    location: LatLng.degree(51.8296012219854, -1.3134667111590494),
  ),
  Unit(
    callsign: 'NF159',
    location: LatLng.degree(51.62832936052779, -1.1854888181805424),
    vehicleType: VehicleType.communityFirstResponder,
  ),
  Unit(
    callsign: 'NR154',
    location: LatLng.degree(51.66706110914126, -1.3082872829130447),
    vehicleType: VehicleType.criticalCareCar,
  ),
  Unit(
    callsign: 'ND027',
    location: LatLng.degree(51.66182910219628, -0.9084334753014697),
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
    location: LatLng.degree(51.61832936052779, -1.0854888181805424),
    vehicleType: VehicleType.helicopter,
  ),
];

/// A default list of events.
final List<Event> _defaultEvents = [
  Event.preAlert(
    idNum: 123,
    address: 'Sainsbury\'s Kidlington',
    location: LatLng.degree(51.80902234666047, -1.2775596525947042),
  ),
  Event.preAlert(
    idNum: 135,
    address: '47 Hamble Drive, Abingdon',
    location: LatLng.degree(51.68256903771005, -1.2649875925459515),
  ),
  Event.withNOC(
    idNum: 3129,
    address: 'Carfax Tower, Oxford',
    location: LatLng.degree(51.752171158042344, -1.2581330894939455),
    noc: Cat2NOC.c2Stabbing(),
  )..assignedUnits = [_defaultUnits[2]],
  Event.withNOC(
    idNum: 3126,
    address: '25 Old Union Way, Thame',
    location: LatLng.degree(51.75068849682342, -0.9859928066375558),
    noc: Cat4NOC.medicalMinor(),
  )..assignedUnits = [_defaultUnits[1]],
  Event.withNOC(
      idNum: 3127,
      address: '6 The Greenway, Oxfordshire',
      location: LatLng.degree(51.59799446397092, -1.3537030950825775),
      noc: Cat1NOC.c1ArrestPeriArrest(),
    )
    ..assignedUnits = [
      _defaultUnits[0],
      _defaultUnits[4],
      _defaultUnits[6],
      _defaultUnits[7],
    ],
  Event.withNOC(
    idNum: 3128,
    address: 'Thatcham Station',
    location: LatLng.degree(51.393901, -1.242779),
    noc: Cat4NOC.mentalHealth(),
  )..assignedUnits = [_defaultUnits[5]],
  Event.withNOC(
    idNum: 3130,
    address: 'Next, Westgate Shopping Centre, Oxford',
    location: LatLng.degree(51.748863260384894, -1.261667647754695),
    noc: Cat3NOC.fallInjuriesUnknown(),
  )..assignedUnits = [_defaultUnits[3]],
];
