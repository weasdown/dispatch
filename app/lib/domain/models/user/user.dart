class User {
  const User({required this.name, required this.esr, required this.picture});

  /// The user's ESR number.
  final int esr;

  /// The user's name.
  final String name;

  /// The user's picture URL.
  final String picture;
}
