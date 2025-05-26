import '../status.dart';

/// The category assigned to an [Event].
enum Category {
  one('1'),
  two('2'),
  three('3'),
  four('4'),
  none('0');

  const Category(this.number);

  List<NOC> get nocs => switch (this) {
    Category.one => catOneNOCs,
    Category.two => catTwoNOCs,
    Category.three => catThreeNOCs,
    Category.four => catFourNOCs,
    Category.none => List.empty(),
  };

  final String number;

  String toJson() => name;

  @override
  String toString() => switch (this) {
    Category.none => 'Pre-Alert',
    _ => 'C$number',
  };
}
