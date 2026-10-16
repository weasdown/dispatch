import 'person.dart';

final class Patient implements Person {
  Patient({required this.name});

  @override
  final String name;

  /// Person's age in integer years.
  late final int? age;
}
