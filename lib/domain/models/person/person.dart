abstract class Person {
  Person({required this.name, required this.address});

  /// Where the person is **currently** located.
  final String address;

  /// The person's name.
  final String name;
}
