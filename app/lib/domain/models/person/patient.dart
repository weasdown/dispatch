import 'package:uuid/uuid.dart';

import '../../../domain/models/location/address.dart';
import 'gp_practice.dart';
import 'person.dart';

final class Patient implements Person {
  Patient({
    this.name,
    this.age,
    this.dateOfBirth,
    this.gpPractice,
    this.homeAddress,
  }) : id = Uuid().v4();

  @override
  String? name;

  /// Person's age in integer years.
  int? age;

  /// Person's date of birth, usually displayed in the dd/mm/yyyy format.
  DateTime? dateOfBirth;

  GPPractice? gpPractice;

  Address? homeAddress;

  final String id;
}
