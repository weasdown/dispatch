extension StringExtensions on String {
  /// Returns the same `String` but with the first letter capitalised.
  String capitalise() => '${this[0].toUpperCase()}${substring(1)}';
}
