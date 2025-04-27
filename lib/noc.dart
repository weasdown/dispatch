import 'event.dart';

/// Nature of Call.
class NOC {
  NOC(this.category, this.description);

  final Category category;

  final String description;
}

/// Full list of all the available Nature of Call statuses.
List<NOC> nocs = List.unmodifiable([
  NOC(Category.one, 'C1 Arrest/Peri Arrest C1'),
  // TODO add all NOCs
]);
