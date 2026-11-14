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

  Map<String, dynamic> toJson() => {
    "name": name,
    "address": address?.toJson(),
    "gpName": gpName,
    "phoneNumber": phoneNumber,
  };

  static GPPractice? tryParse(Map<String, dynamic>? value) {
    if (value == null) {
      return null;
    }

    return GPPractice(
      name: value['name'],
      address: Address.tryParse(value['address']),
      gpName: value['gpName'],
      phoneNumber: value['phoneNumber'],
    );
  }
}
