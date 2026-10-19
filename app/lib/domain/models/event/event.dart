import 'dart:collection';

import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../location/address.dart';
import '../person/patient.dart';
import '../unit/unit.dart';
import 'category.dart';
import 'priority.dart';
import 'remark.dart';
import 'status.dart';

/// An emergency event that the ambulance service has become aware of.
class Event {
  Event._({
    required this.id,
    required this.address,
    required this.location,
    required this.status,
    required this._patients,
  }) : category = status.category {
    if (status == EventStatus.preAlert()) {
      assert(category == null);
    }

    if (category == null) {
      assert(_noc == null);
    }
  }

  Event copyWith({
    required Event oldEvent,
    LatLng? location,
    Address? address,
    EventStatus? status,
    List<Patient>? patients,
  }) => Event._(
    id: oldEvent.id,
    address: address ?? oldEvent.address,
    location: location ?? oldEvent.location,
    status: status ?? oldEvent.status,
    patients: patients ?? oldEvent.patients,
  );

  Event.preAlert({
    required int idNum,
    required Address address,
    required LatLng location,
  }) : this._(
         id: EventID(id: idNum),
         address: address,
         status: EventStatus.preAlert(),
         location: location,
         patients: [],
       );

  factory Event.fromJson(Map<String, dynamic> json) => switch (json) {
    {
      'idNum': int idNum,
      'address': Address address,
      'status': EventStatus status,
      'location': LatLng location,
      'patients': List<Patient> patients,
    } =>
      Event._(
        id: EventID(id: idNum),
        address: address,
        status: status,
        location: location,
        patients: patients,
      ),
    _ => throw const FormatException('Failed to load album.'),
  };

  factory Event.withNOC({
    required int idNum,
    required Address address,
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
  Address? address;

  /// Sets this event's [Event.noc] if it's not already set.
  void addNOC(NOC noc) {
    if (_noc == null) {
      _noc = noc;
      status = EventStatus.nhs999(noc.category!);
      category = noc.category;
    } else {
      throw Exception(
        'An Event\'s NOC can only be set once but was already set.',
      );
    }
  }

  void addPatient(Patient patient) => _patients.add(patient);

  void addRemark(Remark remark) {
    _remarks.add(remark);
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

  Category? category;

  bool get hasMultiplePatients => patients.length > 1;

  bool get hasNoPatient => patients.isEmpty;

  bool? get hasSinglePatient => patients.length == 1;

  /// A unique numerical identifier.
  final EventID id;

  String get idLastFour => id.lastFour;

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

  NumberOfPatients get numberOfPatients => switch (patients.length) {
    0 => NumberOfPatients.none,
    1 => NumberOfPatients.one,
    > 1 => NumberOfPatients.multiple,
    _ => throw Exception(
      'Got negative number of patients for event $idLastFour: ${patients.length}',
    ),
  };

  List<Patient> _patients;

  /// The person or people who will be cared for.
  List<Patient> get patients => _patients;

  Priority get priority => status.priority;

  final List<Remark> _remarks = [];

  UnmodifiableListView<Remark> get remarks => UnmodifiableListView(_remarks);

  EventStatus status;

  Map<String, dynamic> toJson() => {
    'id': id,
    'category': category?.toJson(),
    'noc': noc,
    'address': address,
    'assignedUnits': List<String>.from(
      assignedUnits.map((Unit assignedUnit) => assignedUnit.callsign),
    ),
  };

  @override
  String toString() => 'Event $id';

  void updatePatient(int index, Patient newPatient) {
    _patients[index] = newPatient;
  }
}

enum NumberOfPatients { none, one, multiple }

class EventID {
  EventID({required this.id}) : date = DateTime.now();

  final DateTime date;

  /// Sequential value that, with the [date], uniquely identifies this ID.
  final int id;

  /// Makes a four-digit number from the [id] by adding any required leading zeros.
  String get lastFour => id.toString().padLeft(4, '0');

  @override
  String toString() {
    final DateTime now = DateTime.now();
    // Ensure the month and day are two digits by adding leading 0 if required.
    final String day = now.day.toString().padLeft(2, "0");
    final String month = now.month.toString().padLeft(2, "0");
    return 'S${now.year}$month$day$lastFour';
  }
}
