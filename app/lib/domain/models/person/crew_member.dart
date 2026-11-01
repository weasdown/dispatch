/// @docImport '../unit/unit.dart';
library;

import 'person.dart';

/// A [Person] who could be crewed on a [Unit].
base class CrewMember implements Person {
  const CrewMember({required this.name, required this.esr});

  /// An NHS-wide unique identifier specific to this person.
  final ESR esr;

  /// The crew member's name.
  @override
  final String name;

  Map<String, dynamic> toJson() => {'name': name, 'esr': esr};

  @override
  String toString() => '$name, $esr';
}

/// An eight-digit number that uniquely identifies a staff member across the whole NHS.
typedef ESR = int;

extension ESRNumberOfDigits on ESR {
  static int get numberOfDigits => 8;
}
