import 'dart:collection';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// An emergency event that the ambulance service has become aware of.
class Event {
  Event({required this.id, required this.address})
    : location = _locationFromAddress(address);

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

  /// Gets a [Marker] for showing this [Event] on a map.
  Marker get mapMarker => Marker(
    markerId: MarkerId(id.toString()),
    position: LatLng(lat, lng),
    infoWindow: InfoWindow(title: id.toString(), snippet: address),
  );
}

final List<Event> defaultEvents = [
  Event(id: 423123, address: '1 Broad Street, Oxford'),
  Event(id: 423124, address: '2 Wide Street, Oxford'),
  Event(id: 423125, address: '3 Deep Street, Oxford'),
  Event(id: 423126, address: '4 Long Street, Oxford'),
  Event(id: 423127, address: '5 Tall Street, Oxford'),
  Event(id: 423128, address: '6 Big Street, Oxford'),
];

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
