/// The priority assigned to an [Event].
enum Priority implements Comparable {
  /// Cat 1 / HCP/IFT Level 1
  zero(0),

  /// Cat 2 / HCP/IFT Level 2
  one(1),

  /// Cat 3
  two(2),

  /// Cat 4T
  three(3),

  /// Pre-alert
  four(4),

  /// Cat 4H (also known as Cat 5)
  five(5),

  /// HCP/IFT Level 3 - 1 Hour
  six(6),

  /// HCP/IFT Level 3 - 2 Hour
  seven(7),

  /// HCP/IFT Level 4 - 4 Hour
  eight(8),

  /// Routine/Transfer/Discharge
  nine(9);

  const Priority(this.number);

  final int number;

  /// Returns a value like a Comparator when comparing this to [other].
  /// That is, it returns a negative integer if this is ordered before [other], a positive integer if this is ordered after [other], and zero if this and [other] are ordered together.
  @override
  int compareTo(other) {
    if (other is! Priority) {
      throw UnsupportedError(
        'Cannot compare Priority $this against $other of type ${other.runtimeType}',
      );
    }

    if (other.number == number) {
      return 0;
    }
    // Higher number means lower priority
    else if (other.number > number) {
      return -1;
    }
    // Lower number means higher priority
    else {
      return 1;
    }
  }

  String toJson() => name;

  @override
  String toString() => 'P$number';
}
