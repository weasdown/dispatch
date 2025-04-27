import 'event.dart';

/// Nature of Call.
class NOC {
  const NOC(this.category, this.description);

  final Category category;

  final String description;

  static List<NOC> get cat1 => catOneNOCs;

  static List<NOC> get cat2 => catTwoNOCs;

  static List<NOC> get cat3 => catThreeNOCs;

  static List<NOC> get cat4 => catFourNOCs;
}

/// Full list of all the available Nature of Call statuses.
const List<NOC> nocs = [
  ...catOneNOCs,
  ...catTwoNOCs,
  ...catThreeNOCs,
  ...catFourNOCs,
];

/// [Category] 1 nature of calls.
const List<NOC> catOneNOCs = [
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
];

/// [Category] 2 nature of calls.
const List<NOC> catTwoNOCs = [
  NOC(Category.two, 'CAT 2 - Allergic Reaction C2'),
  NOC(Category.two, 'CAT 2 - Bleeding (specify...) C2'),
  NOC(Category.two, 'CAT 2 - C2 Breathing Problems C2'),
  NOC(Category.two, 'CAT 2 - Breathing Problem, under 5yrs C2'),
  NOC(Category.two, 'CAT 2 - Chest Pain/Cardiac Probs/Back Pain Upper C2'),
  NOC(Category.two, 'CAT 2 - Collapse, Breathing Normal C2'),
  NOC(Category.two, 'CAT 2 - Diabetic Probs C2'),
  NOC(Category.two, 'CAT 2 - Electrocution/Shock C2'),
  NOC(Category.two, 'CAT 2 - Firefighter/BA Emergency C2'),
  NOC(Category.two, 'CAT 2 - Imminent delivery, head out C2'),
  NOC(Category.two, 'CAT 2 - Level 2 HCP2 C2'),
  NOC(Category.two, 'CAT 2 - Level 2 IFT C2'),
  NOC(Category.two, 'CAT 2 - Major Incident Declared C2'),
  NOC(Category.two, 'CAT 2 - Maternity C2'),
  NOC(Category.two, 'CAT 2 - Medical MDC C3 if bypass C2'),
  NOC(Category.two, 'CAT 2 - Operation Consort C2'),
  NOC(Category.two, 'CAT 2 - PLATO Incident C2'),
  NOC(Category.two, 'CAT 2 - Potential Shock under 5yrs C2'),
  NOC(Category.two, 'CAT 2 - RTC Ejection C2'),
  NOC(Category.two, 'CAT 2 - RTC Entrapment C2'),
  NOC(Category.two, 'CAT 2 - RTC Roll Over C2'),
  NOC(Category.two, 'CAT 2 - Running Call C2'),
  NOC(Category.two, 'CAT 2 - Severe Burns C2'),
  NOC(Category.two, 'CAT 2 - C2 Stabbing C2'),
  NOC(Category.two, 'CAT 2 - Stroke/Neurological C2'),
  NOC(Category.two, 'CAT 2 - Trauma Major C2'),
  NOC(Category.two, 'CAT 2 - Unconscious C2'),
];

/// [Category] 3 nature of calls.
const List<NOC> catThreeNOCs = [
  NOC(Category.three, 'CAT 3 - Abdominal/Flank Pain C3'),
  NOC(Category.three, 'CAT 3 - Alcohol Related C3'),
  NOC(Category.three, 'CAT 3 - Concern for Welfare C3'),
  NOC(Category.three, 'CAT 3 - Death Expected <18 C3'),
  NOC(Category.three, 'CAT 3 - Death Unexpected all ages C3'),
  NOC(Category.three, 'CAT 3 - C3 ETHANE (Specify...) C3'),
  NOC(Category.three, 'CAT 3 - Fall, Injuries unknown C3'),
  NOC(Category.three, 'CAT 3 - Headache C3'),
  NOC(Category.three, 'CAT 3 - Heat/Cold Exposure C3'),
  NOC(Category.three, 'CAT 3 - Overdose C3'),
  NOC(Category.three, 'CAT 3 - Section 136 C3'),
  NOC(Category.three, 'CAT 3 - Suicide C3'),
];

/// [Category] 4 nature of calls.
const List<NOC> catFourNOCs = [
  NOC(Category.four, 'CAT 4 - Animal/Insects Bites or Stings (minor) C4'),
  NOC(Category.four, 'CAT 4 - Assault/Domestic C4'),
  NOC(Category.four, 'CAT 4 - Death Expected >18 C4'),
  NOC(Category.four, 'CAT 4 - Falls, Non-Injury C4'),
  NOC(Category.four, 'CAT 4 - Fire Request to Standby C4'),
  NOC(Category.four, 'CAT 4 - HCP or IFT Level 3 or 4 C4'),
  NOC(Category.four, 'CAT 4 - Information Only C4'),
  NOC(Category.four, 'CAT 4 - Major Incident Standby C4'),
  NOC(Category.four, 'CAT 4 - Medical Minor (Specify...) C4'),
  NOC(Category.four, 'CAT 4 - Mental Health C4'),
  NOC(Category.four, 'CAT 4 - Minor Bleeding C4'),
  NOC(Category.four, 'CAT 4 - Nausea/Vomiting C4'),
  NOC(Category.four, 'CAT 4 - Social C4'),
  NOC(Category.four, 'CAT 4 - Trauma (specify...) C4'),
];
