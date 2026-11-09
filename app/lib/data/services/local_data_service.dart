import 'dart:math';

import 'package:latlong2/latlong.dart';

import '../../domain/models/event/event.dart';
import '../../domain/models/event/noc.dart';
import '../../domain/models/event/remark.dart';
import '../../domain/models/location/address.dart';
import '../../domain/models/person/crew_member.dart';
import '../../domain/models/person/patient.dart';
import '../../domain/models/person/user.dart';
import '../../domain/models/unit/unit.dart';
import '../../domain/models/unit/unit_status.dart';

class LocalDataService {
  LocalDataService()
    : _events = _defaultEvents,
      _units = _DefaultUnits._defaultUnits,
      _crewMembers = _defaultCrewMembers {
    _setInitialUnitStatuses();
  }

  List<CrewMember> get crewMembers => _crewMembers;
  final List<CrewMember> _crewMembers;

  Event get defaultC1 => _DefaultEvents._defaultC1;

  /// A default list of crew members who can be crewed on units.
  static List<CrewMember> get _defaultCrewMembers {
    List<CrewMember> crewMembers = _generateCrewMembers();
    crewMembers = [
      CrewMember(name: 'Kacper Thompson', esr: 30554875),
      CrewMember(name: 'Dave Lavender', esr: 30188217),
      CrewMember(name: 'Bonnie Smith', esr: 23121051),
      CrewMember(name: 'Gus Enfield', esr: 21547762),
      CrewMember(name: 'Guy Robertson', esr: 29852687),
      CrewMember(name: 'Dave Baker', esr: 31190545),
      CrewMember(name: 'Hermione Somerset', esr: 35380046),
      CrewMember(name: 'Mary Western', esr: 23079010),
      CrewMember(name: 'Dave Maxwell', esr: 24735435),
      CrewMember(name: 'James Heath', esr: 35027425),
      CrewMember(name: 'John Neal', esr: 35061788),
      CrewMember(name: 'Dave Rose', esr: 28170436),
      CrewMember(name: 'Monica Fernandez', esr: 22757178),
      CrewMember(name: 'James Mitchell', esr: 30283198),
      CrewMember(name: 'Harry Willis', esr: 29922268),
      CrewMember(name: 'Elizabeth Bell', esr: 39168515),
      CrewMember(name: 'Paul Harman', esr: 27295772),
      CrewMember(name: 'Paul Jones', esr: 25831499),
      CrewMember(name: 'Sarah Thompson', esr: 31595474),
      CrewMember(name: 'Dave Lavender', esr: 36635661),
      CrewMember(name: 'Hannah Smith', esr: 26013173),
      CrewMember(name: 'Emma Enfield', esr: 29367603),
      CrewMember(name: 'Hannah Davies', esr: 35875222),
      CrewMember(name: 'Mary Baker', esr: 20321294),
      CrewMember(name: 'Amy Somerset', esr: 39224888),
      CrewMember(name: 'Olivia Western', esr: 31817929),
      CrewMember(name: 'Amy Maxwell', esr: 25700325),
      CrewMember(name: 'Olivia Neal', esr: 38539751),
      CrewMember(name: 'Lara Rose', esr: 28214012),
      CrewMember(name: 'Phil Gardner', esr: 33178751),
      CrewMember(name: 'Paul Fernandez', esr: 21340660),
      CrewMember(name: 'Harry Mitchell', esr: 37658476),
      CrewMember(name: 'Sarah Jones', esr: 30871949),
    ];
    // print(
    //   '\n\n*************** Built ${crewMembers.length} crew members ***************',
    // );
    // print(crewMembers.join('\n'));

    return crewMembers;
  }

  /// A default list of events.
  static List<Event> get _defaultEvents {
    List<Event> defaults = [
      Event.withNOC(
        idNum: 3130,
        address: Address(
          flatNumberOrName: 'Next',
          buildingName: 'Westgate Shopping Centre',
          townOrCity: 'Oxford',
        ),
        location: LatLng(51.748863260384894, -1.261667647754695),
        noc: Cat3NOC.fallInjuriesUnknown(),
      ),
      _DefaultEvents._greenwayC1,
      Event.preAlert(
        idNum: 3120,
        address: Address(buildingName: 'Sainsbury\'s Kidlington'),
        location: LatLng(51.80902234666047, -1.2775596525947042),
      ),
      Event.preAlert(
        idNum: 3121,
        address: Address(
          buildingNumber: '47',
          street: 'Hamble Drive',
          townOrCity: 'Abingdon',
        ),
        location: LatLng(51.68256903771005, -1.2649875925459515),
      ),
      Event.withNOC(
        idNum: 3129,
        address: Address(buildingName: 'Carfax Tower', townOrCity: 'Oxford'),
        location: LatLng(51.752171158042344, -1.2581330894939455),
        noc: Cat2NOC.c2Stabbing(),
      ),
      Event.withNOC(
        idNum: 3126,
        address: Address(
          buildingNumber: '25',
          street: 'Old Union Way',
          townOrCity: 'Thame',
        ),
        location: LatLng(51.75068849682342, -0.9859928066375558),
        noc: Cat4NOC.medicalMinor(),
      ),
      Event.withNOC(
        idNum: 3128,
        address: Address(buildingName: 'Thatcham Station'),
        location: LatLng(51.393901, -1.242779),
        noc: Cat4NOC.mentalHealth(),
      ),
    ];

    return defaults;
  }

  static final Patient _defaultPatient = Patient(name: 'Joe Bloggs');

  static final User _defaultUser = const User(
    name: 'Sophie Williamson',
    esr: 12353248763,
    // For demo purposes we use a local asset
    picture: 'assets/user.jpg',
  );

  final List<Event> _events;

  List<Event> get events => _events;

  /// Generates a random ESR number.
  static ESR _generateESR() {
    final Random random = Random();
    final int firstDigit = random.nextBool() ? 2 : 3;
    String esrString = firstDigit.toString();
    // Fill the rest of the eight digits with random digits.
    while (esrString.length < ESRNumberOfDigits.numberOfDigits) {
      esrString += random.nextInt(10).toString();
    }

    return int.parse(esrString);
  }

  // TODO refine _generateCrewMembers() in terms of name distribution, so it can be used instead of hard-coded values in _defaultCrewMembers
  static List<CrewMember> _generateCrewMembers(
    // [
    //   int numCrewMembersRequired = 20,
    // ]
  ) {
    final Random random = Random();
    final List<String> firstNames = [
      // Female
      'Olivia', 'Mary', 'Hannah', 'Amy', 'Sarah', 'Emma', 'Bonnie', 'Lara',
      'Hermione', 'Elizabeth', 'Monica',

      // Male
      'John', 'James', 'Dave', 'Will', 'Paul', 'Harry', 'Gus', 'Phil', 'Kacper',
    ];
    final List<String> surnames = [
      'Thompson',
      'Lavender',
      'Smith',
      'Enfield',
      'Robertson',
      'Davies',
      'Baker',
      'Somerset',
      'Western',
      'Maxwell',
      'Heath',
      'Neal',
      'Rose',
      'Gardner',
      'Fernandez',
      'Mitchell',
      'Willis',
      'Bell',
      'Harman',
      'Jones',
    ];
    // final int maxLength = surnames.length - 1;
    //
    // if (numCrewMembersRequired > maxLength) {
    //   throw ArgumentError.value(
    //     numCrewMembersRequired,
    //     'numCrewMembersRequired',
    //     'can only generate up to $maxLength crew members as ',
    //   );
    // }

    // // Start of filtered surnames section
    //
    // List<CrewMember> randomCrewMembers = [];
    // // Track use of surnames to avoid overusing any.
    // final Map<String, int> usedSurnames = Map.fromEntries(
    //   surnames.map((String surname) => MapEntry(surname, 0)),
    // );
    // while (randomCrewMembers.length < numCrewMembersRequired) {
    //   final String randomFirstName =
    //       firstNames[random.nextInt(firstNames.length)];
    //   String randomSurname = surnames[random.nextInt(surnames.length)];
    //   // TODO rather than limiting by absolute number of uses, limit by proportion of the total.
    //   // Don't use surnames more than twice.
    //   while (usedSurnames[randomSurname]! > 2) {
    //     // print(
    //     //   'Surname $randomSurname has been used ${usedSurnames[randomSurname]} times - getting another',
    //     // );
    //     randomSurname = surnames[random.nextInt(surnames.length)];
    //     // print('Trying $randomSurname instead');
    //   }
    //   usedSurnames[randomSurname] = usedSurnames[randomSurname]! + 1;
    //
    //   final CrewMember newCrewMember = CrewMember(
    //     name: '$randomFirstName $randomSurname',
    //     esr: _generateESR(),
    //   );
    //   randomCrewMembers.add(newCrewMember);
    // }
    //
    // // End of filtered surnames section

    final List<CrewMember> randomCrewMembers = List<CrewMember>.generate(
      // numCrewMembersRequired,
      surnames.length,
      (int index) {
        final String randomFirstName =
            firstNames[random.nextInt(firstNames.length)];
        final String surname = surnames[index];

        return CrewMember(
          name: '$randomFirstName $surname',
          esr: _generateESR(),
        );
      },
    );

    // print(
    //   '\n\n *************** Built ${randomCrewMembers.length} random crew members: ***************',
    // );
    // print(randomCrewMembers.join('\n'));

    return randomCrewMembers;
  }

  Event? getEvent(Event event) =>
      _events.where((dbEvent) => dbEvent == event).firstOrNull;

  // FIXME doesn't uniquely identify events as would find ones from other days with same last four.
  Event? getEventByID(String idLastFour) =>
      _events.where((dbEvent) => dbEvent.idLastFour == idLastFour).firstOrNull;

  Patient getPatient() => _defaultPatient;

  Unit? getUnit(Unit unit) =>
      _units.where((dbUnit) => dbUnit == unit).firstOrNull;

  User getUser() => _defaultUser;

  final List<Unit> _units;

  List<Unit> get units => _units;

  void _setInitialUnitStatuses() {
    // Make some units available.
    getUnit(_DefaultUnits.nf159)?.updateStatus(newStatus: UnitStatus.am);
    getUnit(_DefaultUnits.nd027)?.updateStatus(newStatus: UnitStatus.ab);
    getUnit(_DefaultUnits.nt431)?.updateStatus(newStatus: UnitStatus.ab);
    getUnit(_DefaultUnits.hm24)?.updateStatus(newStatus: UnitStatus.ab);

    // Assign some units to events.
    getUnit(_DefaultUnits.na283)
        ?.assignToEvent(event: getEventByID('3129')!, status: UnitStatus.as);
    getUnit(_DefaultUnits.na402)
        ?.assignToEvent(event: getEventByID('3126')!, status: UnitStatus.ls);
    getUnit(_DefaultUnits.nr154)
        ?.assignToEvent(event: getEventByID('3128')!, status: UnitStatus.as);
    getUnit(_DefaultUnits.na172)
        ?.assignToEvent(event: getEventByID('3130')!, status: UnitStatus.mo);
  }
}

DateTime _todayAtTime({required int hour, int? minute}) =>
    DateTime.now().copyWith(hour: hour, minute: minute ?? 0);

interface class _DefaultUnits {
  static Unit get na136 => Unit(
    callsign: 'NA136',
    location: LatLng(51.607539604000266, -1.237806756282358),
    personnel: _defaultCrewMembers.sublist(0, 2),
  )..updateShiftTimes(shiftStart: today0800, shiftEnd: today1800);
  static Unit get na402 => Unit(
    callsign: 'NA402',
    location: LatLng(51.605, -1.238),
    personnel: _defaultCrewMembers.sublist(2, 4),
  )..updateShiftTimes(shiftStart: today0800, shiftEnd: today1800);
  static Unit get na283 => Unit(
    callsign: 'NA283',
    location: LatLng(51.616072911907786, -1.2536017723108663),
    personnel: _defaultCrewMembers.sublist(4, 6),
  )..updateShiftTimes(shiftStart: today0800, shiftEnd: today1800);
  static Unit get na172 => Unit(
    callsign: 'NA172',
    location: LatLng(51.8296012219854, -1.3134667111590494),
    personnel: _defaultCrewMembers.sublist(6, 8),
  )..updateShiftTimes(shiftStart: today1000, shiftEnd: today2000);
  static Unit get nf159 => Unit(
    callsign: 'NF159',
    location: LatLng(51.62832936052779, -1.1854888181805424),
    vehicleType: VehicleType.communityFirstResponder,
    personnel: [_defaultCrewMembers[8]],
  )..updateShiftTimes(shiftStart: today1000, shiftEnd: today2200);
  static Unit get nr154 => Unit(
    callsign: 'NR154',
    location: LatLng(51.66706110914126, -1.3082872829130447),
    vehicleType: VehicleType.rrv,
    personnel: [_defaultCrewMembers[9]],
  )..updateShiftTimes(shiftStart: today1000, shiftEnd: today2000);
  static Unit get nd027 => Unit(
    callsign: 'ND027',
    location: LatLng(51.66182910219628, -0.9084334753014697),
    vehicleType: VehicleType.criticalCareCar,
    personnel: _defaultCrewMembers.sublist(10, 12),
  )..updateShiftTimes(shiftStart: today1000, shiftEnd: today2000);
  static Unit get nt431 => Unit(
    callsign: 'NT431',
    location: LatLng(51.397809576171085, -1.3230646597735394),
    vehicleType: VehicleType.rrv,
    personnel: [_defaultCrewMembers[12]],
  )..updateShiftTimes(shiftStart: today1000, shiftEnd: today2000);
  static Unit get hm24 => Unit(
    callsign: '0024',
    location: LatLng(51.61832936052779, -1.0854888181805424),
    vehicleType: VehicleType.helicopter,
    personnel: _defaultCrewMembers.sublist(13, 16),
  )..updateShiftTimes(shiftStart: today0800, shiftEnd: today2000);

  static DateTime get today0800 => _todayAtTime(hour: 8);
  static DateTime get today1000 => _todayAtTime(hour: 10);
  static DateTime get today1800 => _todayAtTime(hour: 18);
  static DateTime get today2000 => _todayAtTime(hour: 20);
  static DateTime get today2200 => _todayAtTime(hour: 22);

  static List<CrewMember> get _defaultCrewMembers =>
      LocalDataService._defaultCrewMembers;

  /// A default list of units.
  static List<Unit> get _defaultUnits => [
    _DefaultUnits.na136,
    _DefaultUnits.na402,
    _DefaultUnits.na283,
    _DefaultUnits.na172,
    _DefaultUnits.nf159,
    _DefaultUnits.nr154,
    _DefaultUnits.nd027,
    _DefaultUnits.nt431,
    _DefaultUnits.hm24,
  ];
}

interface class _DefaultEvents {
  static Event get _defaultC1 => Event.withNOC(
    idNum: 1025,
    address: Address(county: 'Oxfordshire'),
    location: LatLng(51.57770580851515, -1.5679285114893033),
    noc: Cat1NOC.c1ArrestPeriArrest(),
  );

  static Event get _greenwayC1 {
    final User user = LocalDataService._defaultUser;
    return Event.withNOC(
        idNum: 3127,
        address: Address(
          buildingNumber: '6',
          street: 'The Greenway',
          county: 'Oxfordshire',
        ),
        location: LatLng(51.59799446397092, -1.3537030950825775),
        noc: Cat1NOC.c1ArrestPeriArrest(),
      )
      .._addRemarks([
        Remark(
          author: user,
          message: 'CPR was already in progress before the call was started.',
        ),
        Remark(author: user, message: 'NA136 DP Didcot RC'),
        Remark(author: user, message: 'NF159 DP Smith\'s Wharf, Wantage'),
        Remark(author: user, message: 'ND027 DP Stokenchurch HEMS base'),
        Remark(author: user, message: 'NT431 DP Oxford City RC'),
      ])
      ..addPatient(LocalDataService._defaultPatient)
    // // FIXME dispatch doesn't work here
    // ..dispatchUnit(DefaultUnits.nt431())
    ;
  }
}
