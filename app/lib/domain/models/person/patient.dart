import 'gp_practice.dart';
import 'person.dart';

final class Patient implements Person {
  Patient();

  @override
  String? name;

  /// Person's age in integer years.
  int? age;

  /// Person's date of birth, usually displayed in the dd/mm/yyyy format.
  DateTime? dateOfBirth;

  GPPractice? gpPractice;
}
