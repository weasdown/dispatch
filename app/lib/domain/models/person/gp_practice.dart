import '../location/address.dart';

final class GPPractice {
  GPPractice({this.name, this.address, this.gpName, this.phoneNumber});

  final Address? address;

  /// The individual doctor who cares for the patient.
  final String? gpName;

  final String? name;

  final String? phoneNumber;
}
