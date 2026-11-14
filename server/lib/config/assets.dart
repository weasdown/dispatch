import 'dart:convert';
import 'dart:io';

import 'package:dispatch/domain/models/event/event.dart';
import 'package:dispatch/domain/models/unit/unit.dart';

abstract final class Assets {
  static const _events = '../app/assets/events.json';
  static const _units = '../app/assets/units.json';

  static final List<Event> activities = (json.decode(
    File(Assets._events).readAsStringSync(),
  ) as List).map((event) => Event.fromJson(event, event['id'])).toList();

  static final List<Unit> units = (json.decode(
    File(Assets._units).readAsStringSync(),
  ) as List).map((unit) => Unit.fromJson(unit)).toList();
}
