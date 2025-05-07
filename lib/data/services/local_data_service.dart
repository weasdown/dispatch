// Copyright 2024 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../domain/models/event.dart';
import '../../domain/models/unit.dart';
import '../../domain/models/user/user.dart';

class LocalDataService {
  List<Event> get events => [
    Event(
      id: 423124,
      category: Category.two,
      address: 'Sainsbury\'s Kidlington',
    ),
    Event(
      id: 423125,
      address: '47 Hamble Drive Abingdon',
      category: Category.three,
    ),
    Event(id: 423129, category: Category.one, address: 'Carfax Tower, Oxford'),
    Event(
      id: 423126,
      address: '25 Old Union Way, Thame',
      category: Category.four,
    ),
    Event(
      id: 423127,
      address: '6 The Greenway, Oxfordshire',
      category: Category.three,
    ),
    Event(id: 423128, address: 'Thatcham Station', category: Category.two),
  ];

  List<Unit> get units => _defaultUnits;

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
    location: LatLng(51.607539604000266, -1.237806756282358),
  ),
  Unit(
    callsign: 'NA283',
    location: LatLng(51.616072911907786, -1.2536017723108663),
  ),
  Unit(
    callsign: 'NA072',
    location: LatLng(51.8296012219854, -1.3134667111590494),
  ),
  Unit(
    callsign: 'NT431',
    location: LatLng(51.397809576171085, -1.3230646597735394),
    vehicleType: VehicleType.rrv,
  ),
  Unit(
    callsign: 'NR154',
    location: LatLng(51.66706110914126, -1.3082872829130447),
    vehicleType: VehicleType.criticalCareCar,
  ),
  Unit(
    callsign: 'NH58',
    location: LatLng(51.61832936052779, -1.0854888181805424),
    vehicleType: VehicleType.helicopter,
  ),
];
