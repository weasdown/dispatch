import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../status.dart';
import '../unit/unit.dart';
import 'category.dart';
import 'priority.dart';

/// An emergency event that the ambulance service has become aware of.
class Event {
  Event._({
    required this.id,
    required this.address,
    required this.location,
    required this.status,
  }) : category = status.category {
    if (status == EventStatus.preAlert()) {
      assert(category == Category.none);
    }

    if (category == Category.none) {
      assert(_noc == null);
    }
  }

  Event.preAlert({
    required int idNum,
    required String address,
    required LatLng location,
  }) : this._(
         id: _id(idNum),
         address: address,
         status: EventStatus.preAlert(),
         location: location,
       );

  factory Event.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'id': String id,
        'address': String address,
        'status': EventStatus status,
        'location': LatLng location,
      } =>
        Event._(id: id, address: address, status: status, location: location),
      _ => throw const FormatException('Failed to load album.'),
    };
  }

  factory Event.withNOC({
    required int idNum,
    required String address,
    required LatLng location,
    required NOC noc,
  }) {
    Event newEvent = Event.preAlert(
      idNum: idNum,
      address: address,
      location: location,
    );
    newEvent.addNOC(noc);
    return newEvent;
  }

  // TODO remove commented chunks
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

  static String _id(int idNum) {
    // Ensure the idNum is four digits by adding leading 0s if required.
    final String idNumString = idNum.toString().padLeft(4, "0");

    final DateTime now = DateTime.now();
    // Ensure the month and day are two digits by adding leading 0 if required.
    final String day = now.day.toString().padLeft(2, "0");
    final String month = now.month.toString().padLeft(2, "0");
    return 'S${now.year}$month$day$idNumString';
  }

  /// A unique numerical identifier.
  final String id;

  String get idLastFour => id.substring(id.length - 4);

  /// The latitude and longitude of the emergency.
  LatLng location;

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

  Priority get priority => status.priority;

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
