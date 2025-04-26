import 'dart:collection';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'map.dart';

/// An emergency event that the ambulance service has become aware of.
class Event {
  Event._({required this.id, required this.category, required this.address})
    : location = _locationFromAddress(address);

  /// A [Category] one call.
  Event.cat1({required int id, required String address})
    : this._(id: id, category: Category.one, address: address);

  /// A [Category] two call.
  Event.cat2({required int id, required String address})
    : this._(id: id, category: Category.two, address: address);

  /// A [Category] three call.
  Event.cat3({required int id, required String address})
    : this._(id: id, category: Category.three, address: address);

  /// A [Category] four call.
  Event.cat4({required int id, required String address})
    : this._(id: id, category: Category.four, address: address);

  /// A unique numerical identifier.
  final int id;

  /// The street address of the emergency.
  final String address;

  final Category category;

  // TODO vary the icon based on the category of event.
  /// Path to the image used as this [Event]'s icon.
  String? get _iconAsset => null;

  /// Latitude.
  double get lat => location.latitude;

  /// The latitude and longitude of the emergency.
  final LatLng location;

  /// Longitude.
  double get lng => location.longitude;

  // TODO: implement _locationFromAddress - use Geocoding API (see https://developers.google.com/maps/documentation/geocoding/start)
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
      icon:
          (_iconAsset != null)
              ? markerIcon(_iconAsset!)
              : BitmapDescriptor.defaultMarker,
      infoWindow: InfoWindow(
        title: 'Event $id (cat ${category.number})',
        snippet: address,
      ),
    );
  }
}

final List<Event> defaultEvents = [
  Event.cat1(id: 423123, address: '1 Broad Street, Oxford'),
  Event.cat2(id: 423124, address: '2 Wide Street, Oxford'),
  Event.cat3(id: 423125, address: '3 Deep Street, Oxford'),
  Event.cat4(id: 423126, address: '4 Long Street, Oxford'),
  Event.cat3(id: 423127, address: '5 Tall Street, Oxford'),
  Event.cat2(id: 423128, address: '6 Big Street, Oxford'),
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
  one('1', Colors.purple),
  two('2', Colors.red),
  three('3', Colors.yellow),
  four('4', Colors.green);

  const Category(this.number, this.colour);

  final String number;

  final Color colour;
}
