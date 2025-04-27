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
  NOC(Category.one, 'CAT 1 - C1 Arrest/Peri Arrest C1'),
  NOC(Category.one, 'CAT 1 - Choking C1'),
  NOC(Category.one, 'CAT 1 - Drowning/Water Incident C1'),
  NOC(Category.one, 'CAT 1 - Hanging C1'),
  NOC(Category.one, 'CAT 1 - Fitting now C1'),
  NOC(Category.one, 'CAT 1 - Level 1 HCP C1'),
  NOC(Category.one, 'CAT 1 - Level 1 IFT C1'),
  NOC(Category.one, 'CAT 1 - Life Threatening Asthma C1'),
  NOC(Category.one, 'CAT 1 - Obstetric Emergency C1'),
  NOC(Category.one, 'CAT 1 - Potential Anaphylaxis C1'),
  NOC(Category.one, 'CAT 1 - Severe Bleeding under 5yrs C1'),
  NOC(Category.one, 'CAT 1 - Unconscious pregnant >20 weeks C1'),
  NOC(Category.one, 'CAT 1 - Unconscious under 16yrs C1'),
  // TODO add all NOCs
]);
