// Copyright 2024 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import '../../domain/models/event/event.dart';
import '../../domain/models/unit/unit.dart';
import '../../domain/models/user/user.dart';
import '../defaults.dart';

class LocalDataService {
  LocalDataService() : _events = Defaults.events, _units = Defaults.units;

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
