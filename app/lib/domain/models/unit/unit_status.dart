/// @docImport 'unit.dart';
library;

/// Possible statuses for a [Unit] to show its current activity.
enum UnitStatus {
  pd('PD', 'Pre-Duty'),
  ab('AB', 'Available Base'),
  ds('DS', 'Dispatched to Standby'),
  av('AV', 'Available - Voice'),
  af('AF', 'Available - Foot'),
  am('AM', 'Available - MDT'),
  ra('RA', 'Available - Returning'),
  sb('SB', 'Available - Standby'),
  ms('MS', 'Mobile - Standby'),
  dp('DP', 'Dispatched'),
  mo('MO', 'Mobile'),
  as('AS', 'At Scene'),
  ls('LS', 'Left Scene'),
  ah('AH', 'At Hospital'),
  ho('HO', 'Handover'),
  vc('VC', 'Vehicle Clear'),
  rt('RT', 'Request Transport'),
  nt('NT', 'No Transport Required'),
  rv('RV', 'At Scene - RV Point'),
  wp('WP', 'With Patient'),
  ak('AK', 'Acknowledgement'),
  os('OS', 'Out of Service');

  const UnitStatus(this.abbreviation, this.name);

  final String abbreviation;

  final String name;
}
