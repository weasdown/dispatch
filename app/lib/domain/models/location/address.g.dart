// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'address.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Address _$AddressFromJson(Map<String, dynamic> json) => Address(
  flatNumberOrName: json['flatNumberOrName'] as String?,
  buildingName: json['buildingName'] as String?,
  buildingNumber: json['buildingNumber'] as String?,
  street: json['street'] as String?,
  district: json['district'] as String?,
  townOrCity: json['townOrCity'] as String?,
  county: json['county'] as String?,
  postcode: json['postcode'] as String?,
  country: json['country'] as String?,
);

Map<String, dynamic> _$AddressToJson(Address instance) => <String, dynamic>{
  'flatNumberOrName': ?instance.flatNumberOrName,
  'buildingName': ?instance.buildingName,
  'buildingNumber': ?instance.buildingNumber,
  'street': ?instance.street,
  'district': ?instance.district,
  'townOrCity': ?instance.townOrCity,
  'county': ?instance.county,
  'postcode': ?instance.postcode,
  'country': ?instance.country,
};
