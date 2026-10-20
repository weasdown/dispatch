import 'package:uuid/uuid.dart';

import '../../../domain/models/location/address.dart';
import 'gp_practice.dart';
import 'person.dart';

final class Patient implements Person {
  Patient._({
    required this.id,
    this.name,
    this.age,
    this.dateOfBirth,
    this.gpPractice,
    this.homeAddress,
  });

  Patient({
    this.name,
    this.age,
    this.dateOfBirth,
    this.gpPractice,
    this.homeAddress,
  }) : id = Uuid().v4();

  Patient copyWith({
    String? name,
    int? age,
    DateTime? dateOfBirth,
    GPPractice? gpPractice,
    Address? homeAddress,
  }) => Patient._(
    id: id,
    name: name ?? this.name,
    age: age ?? this.age,
    dateOfBirth: dateOfBirth ?? this.dateOfBirth,
    gpPractice: gpPractice ?? this.gpPractice,
    homeAddress: homeAddress ?? this.homeAddress,
  );

  @override
  bool operator ==(Object other) =>
      (other is Patient) &&
      (other.id == id) &&
      (other.name == name) &&
      (other.age == age) &&
      (other.dateOfBirth == dateOfBirth) &&
      (other.gpPractice == gpPractice) &&
      (other.homeAddress == homeAddress);

  @override
  String? name;

  /// Person's age in integer years.
  int? age;

  /// Person's date of birth, usually displayed in the dd/mm/yyyy format.
  DateTime? dateOfBirth;

  GPPractice? gpPractice;

  @override
  int get hashCode =>
      Object.hashAll([id, name, age, dateOfBirth, homeAddress, gpPractice]);

  Address? homeAddress;

  final String id;
}
