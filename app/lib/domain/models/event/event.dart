// import 'package:flutter/material.dart';

// import 'package:flutter_google_maps_webservices/geocoding.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';

// import '../../../api/maps/geocoding.dart';
// import '../../map.dart';
// import 'package:flutter/foundation.dart';
import 'package:latlng/latlng.dart';

import '../status.dart';
import '../unit/unit.dart';
import 'category.dart';

/// An emergency event that the ambulance service has become aware of.
class Event {
  Event._({required this.id, required this.address, required this.status})
    : category = status.category {
    if (status == EventStatus.preAlert()) {
      assert(category == Category.none);
    }

    if (category == Category.none) {
      assert(_noc == null);
    }
  }

  Event.preAlert({required int id, required String address})
    : this._(id: id, address: address, status: EventStatus.preAlert());

  factory Event.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {'id': int id, 'address': String address, 'status': EventStatus status} =>
        Event._(id: id, address: address, status: status),
      _ => throw const FormatException('Failed to load album.'),
    };
  }

  factory Event.withNOC({
    required int id,
    required String address,
    required NOC noc,
  }) {
    Event newEvent = Event.preAlert(id: id, address: address);
    newEvent.addNOC(noc);
    return newEvent;
  }

  // /// Private constructor
  // Event._({
  //   required this.id,
  //   required this.category,
  //   required this.address,
  //   // required this.callerLocationUncertainty,
  // });

  // /// Private 'factory'
  // static Future<Event> _create({
  //   required int id,
  //   required Category category,
  //   required String address,
  //   required num callerLocationUncertainty,
  // }) async {
  //   // Call the private constructor
  //   Event event = Event._(
  //     id: id,
  //     category: category,
  //     address: address,
  //     callerLocationUncertainty: callerLocationUncertainty,
  //   );
  //
  //   // Get precise location from address.
  //   event.location = await event._locationFromAddress();
  //
  //   // Return the event.
  //   return event;
  // }
  //
  // /// A [Category] one call.
  // static Future<Event> cat1({
  //   required int id,
  //   required String address,
  //   required num callerLocationUncertainty,
  // }) async => await Event._create(
  //   id: id,
  //   category: Category.one,
  //   address: address,
  //   callerLocationUncertainty: callerLocationUncertainty,
  // );
  //
  // /// A [Category] two call.
  // static Future<Event> cat2({
  //   required int id,
  //   required String address,
  //   required num callerLocationUncertainty,
  // }) async => await Event._create(
  //   id: id,
  //   category: Category.two,
  //   address: address,
  //   callerLocationUncertainty: callerLocationUncertainty,
  // );
  //
  // /// A [Category] three call.
  // static Future<Event> cat3({
  //   required int id,
  //   required String address,
  //   required num callerLocationUncertainty,
  // }) async => await Event._create(
  //   id: id,
  //   category: Category.three,
  //   address: address,
  //   callerLocationUncertainty: callerLocationUncertainty,
  // );
  //
  // /// A [Category] four call.
  // static Future<Event> cat4({
  //   required int id,
  //   required String address,
  //   required num callerLocationUncertainty,
  // }) async => await Event._create(
  //   id: id,
  //   category: Category.four,
  //   address: address,
  //   callerLocationUncertainty: callerLocationUncertainty,
  // );

  /// The street address of the emergency.
  String address;

  /// Sets this event's [Event.noc] if it's not already set.
  void addNOC(NOC noc) {
    if (_noc == null) {
      _noc = noc;
      status = EventStatus.nhs999(noc.category);
      category = noc.category;
    } else {
      throw Exception(
        'An Event\'s NOC can only be set once but was already set.',
      );
    }
  }

  /// The ambulances and other units assigned to this event.
  List<Unit> assignedUnits = List.empty(growable: true);

  // String get assignedUnitsText =>
  //     assignedUnits.isEmpty
  //         ? 'Assigned: None'
  //         : 'Assigned: ${assignedUnits.map((Unit unit) => unit.callsign).join('\n')}';

  // Circle get callerLocationCircle => Circle(
  //   circleId: CircleId(id.toString()),
  //   fillColor: Colors.orange.shade200.withAlpha(100),
  //   center: LatLng(location.lat, location.lng),
  //   radius: callerLocationUncertainty * 1000,
  //   strokeWidth: 0,
  // );

  // /// The radius within which the caller could be, in km.
  // num callerLocationUncertainty;

  Category category;

  /// A unique numerical identifier.
  final int id;

  /// The latitude and longitude of the emergency.
  late LatLng location;

  // /// Returns the latitude and longitude of a given street [address].
  // Future<Location> _locationFromAddress() async {
  //   GeocodingResponse info = await geocoding.searchByAddress(address);
  //   GeocodingResult result = info.results[0];
  //   Location location = result.geometry.location;
  //
  //   return location;
  // }

  /// Nature of Call.
  NOC? _noc;

  /// Nature of Call.
  NOC? get noc => _noc;

  EventStatus status;

  Map<String, dynamic> toJson() => {
    'id': id,
    'category': category.toJson(),
    'noc': noc,
    'address': address,
    'assignedUnits': List<String>.from(
      assignedUnits.map((Unit assignedUnit) => assignedUnit.callsign),
    ),
  };

  @override
  String toString() => 'Event $id';
}
