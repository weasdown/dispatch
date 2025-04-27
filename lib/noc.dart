import 'event.dart';

/// Nature of Call.
class NOC {
  NOC(this.category, this.description);

  final Category category;

  final String description;

  static List<NOC> get cat1 =>
      nocs.where((NOC noc) => noc.category == Category.one).toList();

  static List<NOC> get cat2 =>
      nocs.where((NOC noc) => noc.category == Category.two).toList();

  static List<NOC> get cat3 =>
      nocs.where((NOC noc) => noc.category == Category.three).toList();

  static List<NOC> get cat4 =>
      nocs.where((NOC noc) => noc.category == Category.four).toList();
}

/// Full list of all the available Nature of Call statuses.
List<NOC> nocs = List.unmodifiable([
  NOC(Category.one, 'C1 Arrest/Peri Arrest C1'),
  // TODO add all NOCs
]);
