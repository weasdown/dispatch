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

  factory Event.fromJson(Map<String, dynamic> json) => switch (json) {
    {
      'id': int id,
      'status': Map<String, dynamic> status,
      'address': String address,
      'assignedCallsigns': List<dynamic> assignedCallsigns,
    } =>
      () {
        return Event._(
            id: id,
            address: address,
            status: EventStatus.fromJson(status),
          ) // FIXME fix setting of assignedCallsigns/assignedUnits
          ..assignedCallsigns = List<String>.from(assignedCallsigns);
      }(),
    _ => throw const FormatException('Failed to load event.'),
  };

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

  void addUnit(Unit unit) {
    if (!_assignedUnits.contains(unit)) {
      _assignedUnits.add(unit);
    }
  }

  /// Assigns a unit
  void dispatchUnit(Unit unit) {
    _assignedUnits.add(unit);
    unit.dispatchTo(this);
  }

  void dispatchUnits(List<Unit> units) {
    for (Unit unit in units) {
      dispatchUnit(unit);
    }
  }

  // TODO keep this is sync with assignedUnits, converting assignedUnits to a getter that pulls Units from the server based on these callsigns.
  /// The callsigns of the ambulances and other units assigned to this event.
  List<String> assignedCallsigns = List.empty(growable: true);

  final List<Unit> _assignedUnits = List.empty(growable: true);

  /// The ambulances and other units assigned to this event.
  List<Unit> get assignedUnits => _assignedUnits;

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
    'status': status.toJson(),
    'address': address,
    'assignedCallsigns': assignedCallsigns,
    // TODO remove assignedUnits map to get callsigns
    // List<String>.from(
    //   assignedUnits.map((Unit assignedUnit) => assignedUnit.callsign),
    // ),
  };

  @override
  String toString() => 'Event $id';
}
