import 'dart:async';
import 'dart:collection';

import 'package:latlong2/latlong.dart';
import 'package:logging/logging.dart';

import '../location/address.dart';
import '../person/patient.dart';
import '../unit/unit.dart';
import '../unit/unit_status.dart';
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
    required this._status,
    required this._patients,
  }) : _accepted = false,
       category = _status.category {
    if (status == EventStatus.preAlert()) {
      assert(category == null);
    }

    if (category == null) {
      assert(_noc == null);
    }
  }

  Event copyWith({
    Address? address,
    LatLng? location,
    EventStatus? status,
    List<Patient>? patients,
  }) => Event._(
    id: id,
    address: address ?? this.address,
    location: location ?? this.location,
    status: status ?? this.status,
    patients: patients ?? this.patients,
  );

  Event.preAlert({
    required int idNum,
    required Address? address,
    LatLng? location,
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
    _ => throw const FormatException('Failed to load Event.'),
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

  void accept() => _accepted = true;

  /// True if the user has ever clicked the Accept Event button to add this event to the database.
  bool get accepted => _accepted;
  bool _accepted;

  /// The street address of the emergency.
  Address? address;

  /// Sets this event's [Event.noc] if it's not already set.
  void addNOC(NOC noc) {
    if (_noc == null) {
      _noc = noc;
      _status = EventStatus.nhs999(noc.category!);
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

  void addUnitHistory({
    required Unit unit,
    required UnitStatus status,
    DateTime? time,
  }) {
    _unitHistory.add(
      UnitHistoryEntry(
        unit: unit,
        status: status,
        time: time ?? DateTime.now(),
      ),
    );
  }

  /// Dispatches [unit] to this event.
  ///
  /// Returns a [Timer] for auto-mobilisation of the unit.
  /// Once the timer fires (after [Unit.autoMobiliseDuration] seconds), the unit's status will be automatically set as mobile ([UnitStatus.mo])
  Timer dispatchUnit(Unit unit) {
    assignedUnits.add(unit);
    addUnitHistory(unit: unit, status: UnitStatus.dp, time: DateTime.now());
    return unit.dispatchToEvent(event: this);
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
  LatLng? location;

  final _log = Logger('Event')..level = Level.ALL;

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

  /// Sets the nature of call (NOC - [_noc]) for this [Event].
  ///
  /// The NOC * only be set if there is not a NOC already set, or if the new NOC is a C1.
  /// However, overwriting of an existing NOC with a non-Cat 1 NOC is still allowed to cater for misclicks.
  void setNOC(NOC noc) {
    if (_noc != null) {
      if (noc.priority == Priority.zero) {
        _log.info(
          'Existing NOC (${_noc!.description}) being overwritten with NOC ${noc.description}',
        );
      } else {
        _log.warning(
          'Existing NOC (${_noc!.description}) being overwritten with non-C1 NOC ${noc.description}',
        );
      }
    }
    // _noc == null
    else {
      _log.info('NOC being set to ${noc.description}');
    }

    _noc = noc;
    _updateStatus();
    _log.fine('New event status: ${status.description}');

    category = noc.category;
  }

  void standdownUnit(Unit unit) {
    _log.fine('Standing down unit ${unit.callsign} from event $idLastFour');
    final bool unitWasAssigned = assignedUnits.remove(unit);
    if (!unitWasAssigned) {
      _log.warning(
        'Unit ${unit.callsign} was not assigned to event $idLastFour',
      );
    }

    if (unit.assignedEvent == this) {
      unit.standdown();
    }
  }

  EventStatus get status => _status;
  EventStatus _status;

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

  List<UnitHistoryEntry> get unitHistory => _unitHistory;
  final List<UnitHistoryEntry> _unitHistory = List.empty(growable: true);

  void updatePatient(int index, Patient newPatient) {
    _patients[index] = newPatient;
  }

  void _updateStatus() {
    if (noc == null) {
      throw ArgumentError.notNull('noc');
    }
    _status = EventStatus(
      category: noc!.category,
      description: noc!.description,
    );
  }
}

enum NumberOfPatients { none, one, multiple }

class EventID implements Comparable<EventID> {
  EventID({required this.id}) : date = DateTime.now();

  @override
  int compareTo(EventID other) => _numberPart.compareTo(other._numberPart);

  final DateTime date;

  /// Sequential value that, with the [date], uniquely identifies this ID.
  final int id;

  /// Makes a four-digit number from the [id] by adding any required leading zeros.
  String get lastFour => id.toString().padLeft(4, '0');

  int get _numberPart => int.parse(toString().substring(1));

  String toJson() => toString();

  @override
  String toString() {
    final DateTime now = DateTime.now();
    // Ensure the month and day are two digits by adding leading 0 if required.
    final String day = now.day.toString().padLeft(2, "0");
    final String month = now.month.toString().padLeft(2, "0");
    return 'S${now.year}$month$day$lastFour';
  }
}
