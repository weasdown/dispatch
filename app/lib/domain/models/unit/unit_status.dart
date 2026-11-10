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

  /// Unit statuses are sorted as follows:
  /// - First: available statuses, with VC first
  /// - Second: en route statuses, with DP before MO
  /// - Patient committed statuses, in order of real-life flow (e.g. AS before AH)
  @override
  int compareTo(UnitStatus other) {
    // The definitive sorting of unit status options.
    final List<UnitStatus> sorted = [
      // Available
      UnitStatus.vc,
      UnitStatus.ra,
      UnitStatus.ab,
      UnitStatus.oneR,
      UnitStatus.af,
      UnitStatus.ak,
      UnitStatus.am,
      UnitStatus.av,

      // Standby
      UnitStatus.ds,
      UnitStatus.ms,
      UnitStatus.sb,

      // En route
      UnitStatus.dp,
      UnitStatus.mo,
      UnitStatus.rv,

      // Patient committed
      UnitStatus.as,
      UnitStatus.rt,
      UnitStatus.nt,
      UnitStatus.wp,
      UnitStatus.ls,
      UnitStatus.ah,
      UnitStatus.ho,

      UnitStatus.pd,

      UnitStatus.os,
    ];

    assert(
      sorted.length == UnitStatus.values.length,
      'sorted list must have exactly the same length as the number of UnitStatus options',
    );

    return sorted.indexOf(this).compareTo(sorted.indexOf(other));
  }

  /// True if dispatched or mobile, otherwise false.
  bool get isEnRoute => switch (this) {
    UnitStatus.dp || UnitStatus.mo => true,
    _ => false,
  };

  /// True if at scene, request transport, with patient, left scene, at hospital
  /// or handover, otherwise false.
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
