/// @docImport 'unit.dart';
library;

/// Possible statuses for a [Unit] to show its current activity.
enum UnitStatus {
  ab('AB', 'Available Base'),
  ra('RA', 'Returning Available'),
  dp('DP', 'Dispatched'),
  ds('DS', 'Dispatched to Standby'),
  mo('MO', 'Mobile'),
  ms('MS', 'Mobile to Standby'),
  as('AS', 'At Scene'),
  wp('WP', 'With Patient'),
  ls('LS', 'Left Scene'),
  ah('AH', 'At Hospital'),
  ho('HO', 'Handover'),
  vc('VC', 'Vehicle Clear'),
  os('OS', 'Out of Service'),
  pd('PD', 'Pre-Duty');

  const UnitStatus(this.abbreviation, this.name);

  final String abbreviation;

  final String name;
}
