import 'package:dispatch/data/defaults.dart';
import 'package:dispatch/domain/models/event/event.dart';
import 'package:dispatch/domain/models/unit/unit.dart';

abstract final class Assets {
  static final List<Event> events = Defaults.events;

  static final List<Unit> units = Defaults.units;

  // // TODO remove compass_app server example code.
  // static const _activities = '../app/assets/activities.json';
  // static const _destinations = '../app/assets/destinations.json';
  //
  // static final List<Destination> destinations =
  //     (json.decode(File(Assets._destinations).readAsStringSync()) as List)
  //         .map((element) => Destination.fromJson(element))
  //         .toList();
  // static final List<Activity> activities =
  //     (json.decode(File(Assets._activities).readAsStringSync()) as List)
  //         .map((element) => Activity.fromJson(element))
  //         .toList();
}
