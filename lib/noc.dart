import 'event.dart';

/// Nature of Call.
abstract class NOC {
  const NOC(this.category, this.description) : specify = false;

  const NOC.withSpecify(this.category, this.description) : specify = true;

  final Category category;

  final String description;

  // TODO implement detail attribute for "(specify...)" NOCs.
  // /// The extra details provided in response to a "Specify..." prompt.
  // final String detail;

  final bool specify;

  static List<NOC> get cat1 => catOneNOCs;

  static List<NOC> get cat2 => catTwoNOCs;

  static List<NOC> get cat3 => catThreeNOCs;

  static List<NOC> get cat4 => catFourNOCs;

  @override
  String toString() {
    final String catNumber = category.number;
    final String specifyText = specify ? ' (specify...)' : '';
    return 'CAT $catNumber - $description$specifyText C$catNumber';
  }
}

final class Cat1NOC extends NOC {
  const Cat1NOC._({required description}) : super(Category.one, description);

  const Cat1NOC.c1ArrestPeriArrest()
    : this._(description: 'C1 Arrest/Peri Arrest');
  const Cat1NOC.choking() : this._(description: 'Choking');
  const Cat1NOC.drowningWaterIncident()
    : this._(description: 'Drowning/Water Incident');
  const Cat1NOC.hanging() : this._(description: 'Hanging');
  const Cat1NOC.fittingNow() : this._(description: 'Fitting now');
  const Cat1NOC.level1HCP() : this._(description: 'Level 1 HCP');
  const Cat1NOC.level1IFT() : this._(description: 'Level 1 IFT');
  const Cat1NOC.lifeThreateningAsthma()
    : this._(description: 'Life Threatening Asthma');
  const Cat1NOC.obstetricEmergency()
    : this._(description: 'Obstetric Emergency');
  const Cat1NOC.potentialAnaphylaxis()
    : this._(description: 'Potential Anaphylaxis');
  const Cat1NOC.severeBleedingUnder5yrs()
    : this._(description: 'Severe Bleeding under 5yrs');
  const Cat1NOC.unconsciousPregnantOver20Weeks()
    : this._(description: 'Unconscious pregnant >20 weeks');
  const Cat1NOC.unconsciousUnder16yrs()
    : this._(description: 'Unconscious under 16yrs');
}

final class Cat2NOC extends NOC {
  const Cat2NOC._({required description}) : super(Category.two, description);

  const Cat2NOC._withSpecify({required description})
    : super.withSpecify(Category.two, description);

  const Cat2NOC.allergicReaction() : this._(description: 'Allergic Reaction');
  const Cat2NOC.bleedingSpecify() : this._withSpecify(description: 'Bleeding');
  const Cat2NOC.c2BreathingProblems()
    : this._(description: 'C2 Breathing Problems');
  const Cat2NOC.breathingProblemUnder5yrs()
    : this._(description: 'Breathing Problem, under 5yrs');
  const Cat2NOC.chestPainCardiacProbsBackPainUpper()
    : this._(description: 'Chest Pain/Cardiac Probs/Back Pain Upper');
  const Cat2NOC.collapseBreathingNormal()
    : this._(description: 'Collapse, Breathing Normal');
  const Cat2NOC.diabeticProbs() : this._(description: 'Diabetic Probs');
  const Cat2NOC.electrocutionShock()
    : this._(description: 'Electrocution/Shock');
  const Cat2NOC.firefighterBAEmergency()
    : this._(description: 'Firefighter/BA Emergency');
  const Cat2NOC.imminentDeliveryHeadOut()
    : this._(description: 'Imminent delivery, head out');
  const Cat2NOC.level2HCP2() : this._(description: 'Level 2 HCP2');
  const Cat2NOC.level2IFT() : this._(description: 'Level 2 IFT');
  const Cat2NOC.majorIncidentDeclared()
    : this._(description: 'Major Incident Declared');
  const Cat2NOC.maternity() : this._(description: 'Maternity');
  const Cat2NOC.medicalMDCC3IfBypass()
    : this._(description: 'Medical MDC C3 if bypass');
  const Cat2NOC.operationConsort() : this._(description: 'Operation Consort');
  const Cat2NOC.platoIncident() : this._(description: 'PLATO Incident');
  const Cat2NOC.potentialShockUnder5yrs()
    : this._(description: 'Potential Shock under 5yrs');
  const Cat2NOC.rtcEjection() : this._(description: 'RTC Ejection');
  const Cat2NOC.rtcEntrapment() : this._(description: 'RTC Entrapment');
  const Cat2NOC.rtcRollOver() : this._(description: 'RTC Roll Over');
  const Cat2NOC.runningCall() : this._(description: 'Running Call');
  const Cat2NOC.severeBurns() : this._(description: 'Severe Burns');
  const Cat2NOC.c2Stabbing() : this._(description: 'C2 Stabbing');
  const Cat2NOC.strokeNeurological()
    : this._(description: 'Stroke/Neurological');
  const Cat2NOC.traumaMajor() : this._(description: 'Trauma Major');
  const Cat2NOC.unconscious() : this._(description: 'Unconscious');
}

// TODO implement constructors for Cat3NOC.
final class Cat3NOC extends NOC {
  const Cat3NOC._({required description}) : super(Category.three, description);

  const Cat3NOC._withSpecify({required description})
    : super.withSpecify(Category.three, description);
}

// TODO implement constructors for Cat4NOC.
final class Cat4NOC extends NOC {
  const Cat4NOC._({required description}) : super(Category.four, description);

  const Cat4NOC._withSpecify({required description})
    : super.withSpecify(Category.four, description);
}

/// Full list of all the available Nature of Call statuses.
List<NOC> nocs = [
  ...catOneNOCs,
  ...catTwoNOCs,
  ...catThreeNOCs,
  ...catFourNOCs,
];

/// [Category] 1 nature of calls.
const List<Cat1NOC> catOneNOCs = [
  Cat1NOC.c1ArrestPeriArrest(),
  Cat1NOC.choking(),
  Cat1NOC.drowningWaterIncident(),
  Cat1NOC.hanging(),
  Cat1NOC.fittingNow(),
  Cat1NOC.level1HCP(),
  Cat1NOC.level1IFT(),
  Cat1NOC.lifeThreateningAsthma(),
  Cat1NOC.obstetricEmergency(),
  Cat1NOC.potentialAnaphylaxis(),
  Cat1NOC.severeBleedingUnder5yrs(),
  Cat1NOC.unconsciousPregnantOver20Weeks(),
  Cat1NOC.unconsciousUnder16yrs(),
];

/// [Category] 2 nature of calls.
const List<Cat2NOC> catTwoNOCs = [
  Cat2NOC.allergicReaction(),
  Cat2NOC.bleedingSpecify(),
  Cat2NOC.c2BreathingProblems(),
  Cat2NOC.breathingProblemUnder5yrs(),
  Cat2NOC.chestPainCardiacProbsBackPainUpper(),
  Cat2NOC.collapseBreathingNormal(),
  Cat2NOC.diabeticProbs(),
  Cat2NOC.electrocutionShock(),
  Cat2NOC.firefighterBAEmergency(),
  Cat2NOC.imminentDeliveryHeadOut(),
  Cat2NOC.level2HCP2(),
  Cat2NOC.level2IFT(),
  Cat2NOC.majorIncidentDeclared(),
  Cat2NOC.maternity(),
  Cat2NOC.medicalMDCC3IfBypass(),
  Cat2NOC.operationConsort(),
  Cat2NOC.platoIncident(),
  Cat2NOC.potentialShockUnder5yrs(),
  Cat2NOC.rtcEjection(),
  Cat2NOC.rtcEntrapment(),
  Cat2NOC.rtcRollOver(),
  Cat2NOC.runningCall(),
  Cat2NOC.severeBurns(),
  Cat2NOC.c2Stabbing(),
  Cat2NOC.strokeNeurological(),
  Cat2NOC.traumaMajor(),
  Cat2NOC.unconscious(),
];

// FIXME fix catThreeNOCs
/// [Category] 3 nature of calls.
const List<NOC> catThreeNOCs = [
  // NOC(Category.three, 'Abdominal/Flank Pain'),
  // NOC(Category.three, 'Alcohol Related'),
  // NOC(Category.three, 'Concern for Welfare'),
  // NOC(Category.three, 'Death Expected <18'),
  // NOC(Category.three, 'Death Unexpected all ages'),
  // NOC(Category.three, 'C3 ETHANE (Specify...)'),
  // NOC(Category.three, 'Fall, Injuries unknown'),
  // NOC(Category.three, 'Headache'),
  // NOC(Category.three, 'Heat/Cold Exposure'),
  // NOC(Category.three, 'Overdose'),
  // NOC(Category.three, 'Section 136'),
  // NOC(Category.three, 'Suicide'),
];

// FIXME fix catFourNOCs
/// [Category] 4 nature of calls.
const List<NOC> catFourNOCs = [
  // NOC(Category.four, 'Animal/Insects Bites or Stings (minor)'),
  // NOC(Category.four, 'Assault/Domestic'),
  // NOC(Category.four, 'Death Expected >18'),
  // NOC(Category.four, 'Falls, Non-Injury'),
  // NOC(Category.four, 'Fire Request to Standby'),
  // NOC(Category.four, 'HCP or IFT Level 3 or 4'),
  // NOC(Category.four, 'Information Only'),
  // NOC(Category.four, 'Major Incident Standby'),
  // NOC(Category.four, 'Medical Minor (Specify...)'),
  // NOC(Category.four, 'Mental Health'),
  // NOC(Category.four, 'Minor Bleeding'),
  // NOC(Category.four, 'Nausea/Vomiting'),
  // NOC(Category.four, 'Social'),
  // NOC(Category.four, 'Trauma (specify...)'),
];
