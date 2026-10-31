/// @docImport 'unit.dart';
library;

/// Possible statuses for a [Unit] to show its current activity.
enum UnitStatus implements Comparable<UnitStatus> {
  oneR('1R', 'Cat 1 only'),
  ab('AB', 'Available Base'),
  af('AF', 'Available - Foot'),
  ah('AH', 'At Hospital'),
  ak('AK', 'Acknowledgement'),
  am('AM', 'Available - MDT'),
  as('AS', 'At Scene'),
  av('AV', 'Available - Voice'),
  dp('DP', 'Dispatched'),
  ds('DS', 'Dispatch to Standby'),
  ho('HO', 'Handover'),
  ls('LS', 'Left Scene'),
  mo('MO', 'Mobile'),
  ms('MS', 'Mobile - Standby'),
  nt('NT', 'No Transport Required'),
  os('OS', 'Out of Service'),
  pd('PD', 'Pre-Duty'),
  ra('RA', 'Returning Available'),
  rt('RT', 'Request Transport'),
  rv('RV', 'At Scene - RV Point'),
  sb('SB', 'Available - Standby'),
  vc('VC', 'Vehicle Clear'),
  wp('WP', 'With Patient');

  const UnitStatus(this.abbreviation, this.name);

  final String abbreviation;

  // TODO implement UnitStatus.compareTo() to enable sorting of units by status
  /// Unit statuses are sorted as follows:
  /// - First: available statuses, with VC first
  /// - Second: en route statuses, with DP before MO
  /// - Patient committed statuses, in order of real-life flow (e.g. AS before AH)
  @override
  int compareTo(UnitStatus other) {
    throw UnimplementedError();
  }

  bool get isPatientCommitted => switch (this) {
    UnitStatus.as ||
    UnitStatus.rt ||
    UnitStatus.wp ||
    UnitStatus.ls ||
    UnitStatus.ah ||
    UnitStatus.ho => true,
    _ => false,
  };

  final String name;
}
