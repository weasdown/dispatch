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

  List<NOC> get nocs => switch (this) {
    Category.one => catOneNOCs,
    Category.two => catTwoNOCs,
    Category.three => catThreeNOCs,
    Category.four => catFourNOCs,
    Category.five => List.empty(),
  };

  final int number;

  final Priority priority;

  String toJson() => name;

  @override
  String toString() => 'C$number';
}
