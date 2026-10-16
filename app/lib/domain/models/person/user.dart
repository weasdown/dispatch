import 'person.dart';

class User implements Person {
  const User({required this.name, required this.esr, required this.picture});

  /// The user's ESR number.
  final int esr;

  /// The user's name.
  @override
  final String name;

  /// The user's picture asset.
  final String picture;
}
