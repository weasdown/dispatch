import 'event/category.dart';
import 'event/priority.dart';
import 'noc.dart';

interface class EventStatus {
  const EventStatus(this.category, this.description);

  /// Creates an emergency ambulance [EventStatus].
  const factory EventStatus.nhs999(Category category) =
      PathwaysDisposition._nhs999;

  const EventStatus.preAlert()
    : category = Category.none,
      description = _preAlert;

  @override
  bool operator ==(Object other) =>
      other is EventStatus &&
      (other.category == category) &&
      (other.description == description);

  final Category category;

  final String description;

  @override
  int get hashCode => Object.hash(category, description);

  static const String _preAlert = 'Pre-Alert';

  Priority get priority => category.priority;

  @override
  String toString() => description;
}

base class PathwaysDisposition extends EventStatus {
  const PathwaysDisposition._(super.category, super.description);

  const PathwaysDisposition._nhs999(Category category)
    : this._(category, 'NHS999');
}

/// Nature of Call.
abstract class NOC extends EventStatus {
  const NOC(super.category, super.description) : specify = false;

  const NOC.withSpecify(super.category, super.description) : specify = true;

  // TODO implement detail attribute for "(specify...)" NOCs.
  // /// The extra details provided in response to a "Specify..." prompt.
  // final String detail;

  // TODO remove specify attribute.
  /// True if an extra description of the incident needs to be provided, false otherwise.
  final bool specify;

  static List<NOC> get cat1 => catOneNOCs;

  static List<NOC> get cat2 => catTwoNOCs;

  static List<NOC> get cat3 => catThreeNOCs;

  static List<NOC> get cat4 => catFourNOCs;

  String toJson() => toString();

  @override
  String toString() {
    final int catNumber = category.number;
    final String specifyText = specify ? ' (specify...)' : '';
    return 'CAT $catNumber - $description$specifyText C$catNumber';
  }
}
