import '../event.dart';

interface class Status {
  const Status(this.category, this.description);

  /// Creates an emergency ambulance [Status].
  const factory Status.nhs999(Category category) = PathwaysDisposition._nhs999;

  const Status.preAlert() : category = null, description = _preAlert;

  @override
  bool operator ==(Object other) =>
      other is Status &&
      (other.category == category) &&
      (other.description == description);

  final Category? category;

  final String description;

  @override
  int get hashCode => Object.hash(category, description);

  static const String _preAlert = 'Pre-Alert';

  @override
  String toString() => description;
}

base class PathwaysDisposition extends Status {
  const PathwaysDisposition._(super.category, super.description);

  const PathwaysDisposition._nhs999(Category category)
    : this._(category, 'NHS999');
}

/// Nature of Call.
abstract class NOC extends Status {
  const NOC(super.category, super.description) : specify = false;

  const NOC.withSpecify(super.category, super.description) : specify = true;

  // TODO implement detail attribute for "(specify...)" NOCs.
  // /// The extra details provided in response to a "Specify..." prompt.
  // final String detail;

  @override
  Category get category => super.category!;

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

  const Cat2NOC.allergicReaction() : this._(description: 'Allergic Reaction');
  const Cat2NOC.bleedingSpecify()
    : super.withSpecify(Category.two, 'Bleeding (Specify...)');
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

final class Cat3NOC extends NOC {
  const Cat3NOC._({required description}) : super(Category.three, description);

  const Cat3NOC.abdominalFlankPain()
    : this._(description: 'Abdominal/Flank Pain');
  const Cat3NOC.alcoholRelated() : this._(description: 'Alcohol Related');
  const Cat3NOC.concernForWelfare()
    : this._(description: 'Concern for Welfare');
  const Cat3NOC.deathExpectedUnder18()
    : this._(description: 'Death Expected <18');
  const Cat3NOC.deathUnexpectedAllAges()
    : this._(description: 'Death Unexpected all ages');
  const Cat3NOC.c3ETHANE()
    : super.withSpecify(Category.three, 'C3 ETHANE (Specify...)');
  const Cat3NOC.fallInjuriesUnknown()
    : this._(description: 'Fall, Injuries unknown');
  const Cat3NOC.headache() : this._(description: 'Headache');
  const Cat3NOC.heatColdExposure() : this._(description: 'Heat/Cold Exposure');
  const Cat3NOC.overdose() : this._(description: 'Overdose');
  const Cat3NOC.section136() : this._(description: 'Section 136');
  const Cat3NOC.suicide() : this._(description: 'Suicide');
}

final class Cat4NOC extends NOC {
  const Cat4NOC._({required description}) : super(Category.four, description);

  const Cat4NOC.animalInsectsBitesOrStingsMinor()
    : this._(description: 'Animal/Insects Bites or Stings (minor)');
  const Cat4NOC.assaultDomestic() : this._(description: 'Assault/Domestic');
  const Cat4NOC.deathExpectedOver18()
    : this._(description: 'Death Expected >18');
  const Cat4NOC.fallsNonInjury() : this._(description: 'Falls, Non-Injury');
  const Cat4NOC.fireRequestToStandby()
    : this._(description: 'Fire Request to Standby');
  const Cat4NOC.hcpOrIFTLevel3Or4()
    : this._(description: 'HCP or IFT Level 3 or 4');
  const Cat4NOC.informationOnly() : this._(description: 'Information Only');
  const Cat4NOC.majorIncidentStandby()
    : this._(description: 'Major Incident Standby');
  const Cat4NOC.medicalMinor()
    : super.withSpecify(Category.four, 'Medical Minor');
  const Cat4NOC.mentalHealth() : this._(description: 'Mental Health');
  const Cat4NOC.minorBleeding() : this._(description: 'Minor Bleeding');
  const Cat4NOC.nauseaVomiting() : this._(description: 'Nausea/Vomiting');
  const Cat4NOC.social() : this._(description: 'Social');
  const Cat4NOC.trauma() : super.withSpecify(Category.four, 'Trauma');
}

/// Full list of all the available Nature of Call statuses.
const List<NOC> nocs = [
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

/// [Category] 3 nature of calls.
const List<Cat3NOC> catThreeNOCs = [
  Cat3NOC.abdominalFlankPain(),
  Cat3NOC.alcoholRelated(),
  Cat3NOC.concernForWelfare(),
  Cat3NOC.deathExpectedUnder18(),
  Cat3NOC.deathUnexpectedAllAges(),
  Cat3NOC.c3ETHANE(),
  Cat3NOC.fallInjuriesUnknown(),
  Cat3NOC.headache(),
  Cat3NOC.heatColdExposure(),
  Cat3NOC.overdose(),
  Cat3NOC.section136(),
  Cat3NOC.suicide(),
];

/// [Category] 4 nature of calls.
const List<Cat4NOC> catFourNOCs = [
  Cat4NOC.animalInsectsBitesOrStingsMinor(),
  Cat4NOC.assaultDomestic(),
  Cat4NOC.deathExpectedOver18(),
  Cat4NOC.fallsNonInjury(),
  Cat4NOC.fireRequestToStandby(),
  Cat4NOC.hcpOrIFTLevel3Or4(),
  Cat4NOC.informationOnly(),
  Cat4NOC.majorIncidentStandby(),
  Cat4NOC.medicalMinor(),
  Cat4NOC.mentalHealth(),
  Cat4NOC.minorBleeding(),
  Cat4NOC.nauseaVomiting(),
  Cat4NOC.social(),
  Cat4NOC.trauma(),
];
