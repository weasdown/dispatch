import 'dart:collection';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

/// An emergency event that the ambulance service has become aware of.
class Event {
  Event({required this.id, required this.address})
    : location = _locationFromAddress(address) {
    debugPrint('Lat/lng for event $id: $lat, $lng');
  }

  final int id;

  /// The street address of the emergency.
  final String address;

  /// Latitude.
  double get lat => location.latitude;

  /// The latitude and longitude of the emergency.
  final LatLng location;

  /// Longitude.
  double get lng => location.longitude;

  // TODO: implement _locationFromAddress
  /// Returns the latitude and longitude of a given street [address].
  static LatLng _locationFromAddress(String address) {
    // Value is >= 0.0 and < 0.6, plus 51.
    double randomLat = 51 + Random().nextDouble() * 0.6;

    // Value is >= 0.0 and < 0.6, plus -1.25.
    double randomLng = -1.25 + Random().nextDouble() * 0.55;

    return LatLng(randomLat, randomLng);
  }
}

/// Storage for all the events that units will respond to.
class EventListModel extends ChangeNotifier {
  EventListModel({required List<Event> events}) {
    _events.addAll(events);
  }

  EventListModel.blank();

  /// Internal, private state of the event list.
  final List<Event> _events = [];

  /// An unmodifiable view of the events in the event list.
  UnmodifiableListView<Event> get events => UnmodifiableListView(_events);

  /// The current total number of events.
  int get numEvents => _events.length;

  /// Adds [event] to event list. This and [removeAll] are the only ways to
  /// modify the event list from the outside.
  void add(Event event) {
    _events.add(event);
    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }

  /// Removes all events from the event list.
  void removeAll() {
    _events.clear();
    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }
}
