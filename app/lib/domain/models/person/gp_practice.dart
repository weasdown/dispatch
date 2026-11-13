import '../location/address.dart';

final class GPPractice {
  GPPractice({this.name, this.address, this.gpName, this.phoneNumber});

  factory GPPractice.fromJson(Map<String, dynamic> json) {
    throw UnimplementedError('GPPractice.fromJson() is not yet implemented.');
  }

  final Address? address;

  /// The individual doctor who cares for the patient.
  final String? gpName;

  final String? name;

  final String? phoneNumber;

  // TODO implement GPPractice.tryParse() static method
  static GPPractice? tryParse(Map<String, dynamic> value) {
    throw UnimplementedError(
      'GPPractice.tryParse() static method is not yet implemented',
    );
  }
}
