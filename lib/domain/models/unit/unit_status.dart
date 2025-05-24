/// @docImport 'unit.dart';
library;

/// Possible statuses for a [Unit] to show its current activity.
enum UnitStatus {
  ab('AB', 'Available Base'),
  ra('RA', 'Returning Available'),
  dp('DP', 'Dispatched'),
  mo('MO', 'Mobile'),
  as('AS', 'At Scene'),
  wp('WP', 'With Patient'),
  ls('LS', 'Left Scene'),
  ah('AH', 'At Hospital'),
  ho('HO', 'Handover'),
  vc('VC', 'Vehicle Clear'),
  os('OS', 'Out of Service');

  const UnitStatus(this.abbreviation, this.name);

  final String abbreviation;

  final String name;
}
