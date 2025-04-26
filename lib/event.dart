import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

/// An emergency event that the ambulance service has become aware of.
class Event {
  Event({required this.address}) : location = _locationFromAddress(address);

  /// The street address of the emergency.
  final String address;

  /// The latitude and longitude of the emergency.
  final LatLng location;

  /// Returns the latitude and longitude of a given street [address].
  static LatLng _locationFromAddress(String address) {
    // TODO: implement _locationFromAddress
    return LatLng(0, 0);
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
