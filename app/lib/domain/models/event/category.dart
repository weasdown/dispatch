import 'noc.dart';
import 'priority.dart';
import 'status.dart';

/// The category assigned to an [Event].
enum Category {
  one(1, Priority.zero),
  two(2, Priority.one),
  three(3, Priority.two),
  four(4, Priority.three),
  five(5, Priority.five);

  const Category(this.number, this.priority);

  factory Category.fromJson(int number) => switch (number) {
    1 => Category.one,
    2 => Category.two,
    3 => Category.three,
    4 => Category.four,
    5 => Category.five,
    _ => throw ArgumentError.value(number, 'Invalid Category number'),
  };

  List<NOC> get nocs => switch (this) {
    Category.one => catOneNOCs,
    Category.two => catTwoNOCs,
    Category.three => catThreeNOCs,
    Category.four => catFourNOCs,
    Category.five => List.empty(),
  };

  final int number;

  final Priority priority;

  int toJson() => number;

  @override
  String toString() => 'C$number';
}
