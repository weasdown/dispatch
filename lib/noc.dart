import 'event.dart';

/// Nature of Call.
class NOC {
  NOC(this.category, this.description);

  final Category category;

  final String description;

  static List<NOC> get cat1 => Category.one.nocs;

  static List<NOC> get cat2 => Category.two.nocs;

  static List<NOC> get cat3 => Category.three.nocs;

  static List<NOC> get cat4 => Category.four.nocs;
}

/// Full list of all the available Nature of Call statuses.
List<NOC> nocs = List.unmodifiable([
  NOC(Category.one, 'C1 Arrest/Peri Arrest C1'),
  // TODO add all NOCs
]);
