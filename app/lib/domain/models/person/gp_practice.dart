import '../location/address.dart';

final class GPPractice {
  GPPractice({this.name, this.address, this.gpName, this.phoneNumber});

  final Address? address;

  /// The individual doctor who cares for the patient.
  final String? gpName;

  final String? name;

  final String? phoneNumber;

  // TODO implement GPPractice.tryParse() static method
  static GPPractice? tryParse(String value) {
    throw UnimplementedError(
      'GPPractice.tryParse() static method is not yet implemented',
    );
  }
}
