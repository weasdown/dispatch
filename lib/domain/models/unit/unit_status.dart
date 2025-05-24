/// @docImport 'unit.dart';
library;

/// Possible statuses for a [Unit] to show its current activity.
enum UnitStatus {
  ra('RA', 'Returning Available');
  // TODO add other status options

  const UnitStatus(this.abbreviation, this.name);

  final String abbreviation;

  final String name;
}
