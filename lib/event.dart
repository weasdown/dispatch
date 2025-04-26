import 'dart:collection';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// An emergency event that the ambulance service has become aware of.
class Event {
  Event({required this.id, required this.category, required this.address})
    : location = _locationFromAddress(address);

  /// A [Category] one call.
  Event.cat1({required this.id, required this.address, required this.location})
    : category = Category.one;

  /// A [Category] two call.
  Event.cat2({required this.id, required this.address, required this.location})
    : category = Category.two;

  /// A [Category] three call.
  Event.cat3({required this.id, required this.address, required this.location})
    : category = Category.three;

  /// A [Category] four call.
  Event.cat4({required this.id, required this.address, required this.location})
    : category = Category.four;

  /// A unique numerical identifier.
  final int id;

  /// The street address of the emergency.
  final String address;

  final Category category;

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
  Marker get mapMarker {
    final String id = this.id.toString();
    return Marker(
      markerId: MarkerId(id),
      position: LatLng(lat, lng),
      infoWindow: InfoWindow(
        title: 'Event $id (cat ${category.number})',
        snippet: address,
      ),
    );
  }
}

final List<Event> defaultEvents = [
  Event(id: 423123, category: Category.one, address: '1 Broad Street, Oxford'),
  Event(id: 423124, category: Category.two, address: '2 Wide Street, Oxford'),
  Event(id: 423125, category: Category.three, address: '3 Deep Street, Oxford'),
  Event(id: 423126, category: Category.four, address: '4 Long Street, Oxford'),
  Event(id: 423127, category: Category.three, address: '5 Tall Street, Oxford'),
  Event(id: 423128, category: Category.two, address: '6 Big Street, Oxford'),
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

/// The category assigned to an [Event].
enum Category {
  one('1'),
  two('2'),
  three('3'),
  four('4');

  const Category(this.number);

  final String number;
}
