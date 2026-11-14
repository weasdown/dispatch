// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'unit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Unit _$UnitFromJson(Map<String, dynamic> json) => Unit(
  callsign: json['callsign'] as String,
  location: LatLng.fromJson(json['location'] as Map<String, dynamic>),
  vehicleType:
      $enumDecodeNullable(_$VehicleTypeEnumMap, json['vehicleType']) ??
      VehicleType.dca,
  personnel: (json['personnel'] as List<dynamic>)
      .map((e) => CrewMember.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$UnitToJson(Unit instance) => <String, dynamic>{
  'callsign': instance.callsign,
  'location': instance.location,
  'personnel': instance.personnel,
  'vehicleType': _$VehicleTypeEnumMap[instance.vehicleType]!,
};

const _$VehicleTypeEnumMap = {
  VehicleType.dca: 'dca',
  VehicleType.rrv: 'rrv',
  VehicleType.helicopter: 'helicopter',
  VehicleType.criticalCareCar: 'criticalCareCar',
  VehicleType.communityFirstResponder: 'communityFirstResponder',
  VehicleType.coResponder: 'coResponder',
};
