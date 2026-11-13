import 'package:json_annotation/json_annotation.dart';

/// This allows the `Address` class to access private members in
/// the generated file. The value for this is *.g.dart, where
/// the star denotes the source file name.
part 'address.g.dart';

@JsonSerializable()
final class Address {
  const Address({
    this.flatNumberOrName,
    this.buildingName,
    this.buildingNumber,
    this.street,
    this.district,
    this.townOrCity,
    this.county,
    this.postcode,
    this.country,
  }) : // Building cannot have a name and a number
       assert(!(buildingName != null && buildingNumber != null));

  /// A necessary factory constructor for creating a new Address instance
  /// from a map. Pass the map to the generated `_$AddressFromJson()` constructor.
  /// The constructor is named after the source class, in this case, Address.
  factory Address.fromJson(Map<String, dynamic> json) =>
      _$AddressFromJson(json);

  final String? flatNumberOrName;

  final String? buildingName;

  /// E.g. 25 or 42a.
  final String? buildingNumber;

  final String? street;

  final String? district;

  final String? townOrCity;

  final String? county;

  final String? postcode;

  final String? country;

  String? get firstLine {
    final Iterable<String> nonNullParts = [
      flatNumberOrName,
      buildingNumber,
      buildingName,
      street,
    ].where((String? element) => element != null).cast<String>();
    return nonNullParts.isEmpty ? null : nonNullParts.join(', ');
  }

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$AddressToJson(this);

  // TODO define toString() override method

  // TODO implement Address.tryParse() static method
  static Address? tryParse(String value) {
    throw UnimplementedError(
      'Address.tryParse() static method is not yet implemented',
    );
  }

  @override
  String toString() {
    final Iterable<String> nonNullParts = [
      firstLine,
      district,
      townOrCity,
      postcode,
    ].where((String? element) => element != null).cast<String>();
    return nonNullParts.isEmpty ? '' : nonNullParts.join(', ');
  }
}
