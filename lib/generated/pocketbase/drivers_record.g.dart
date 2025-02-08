// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'drivers_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DriversRecord _$DriversRecordFromJson(Map<String, dynamic> json) =>
    DriversRecord(
      id: json['id'] as String,
      created: pocketBaseDateTimeFromJson(json['created'] as String),
      updated: pocketBaseDateTimeFromJson(json['updated'] as String),
      collectionId: json['collectionId'] as String,
      collectionName: json['collectionName'] as String,
      name: json['name'] as String?,
      license_number: json['license_number'] as String?,
      experience_years: (json['experience_years'] as num?)?.toDouble(),
      phone: json['phone'] as String?,
      status:
          $enumDecodeNullable(_$DriversRecordStatusEnumEnumMap, json['status']),
    );

Map<String, dynamic> _$DriversRecordToJson(DriversRecord instance) =>
    <String, dynamic>{
      'id': instance.id,
      'created': pocketBaseDateTimeToJson(instance.created),
      'updated': pocketBaseDateTimeToJson(instance.updated),
      'collectionId': instance.collectionId,
      'collectionName': instance.collectionName,
      'name': instance.name,
      'license_number': instance.license_number,
      'experience_years': instance.experience_years,
      'phone': instance.phone,
      'status': _$DriversRecordStatusEnumEnumMap[instance.status],
    };

const _$DriversRecordStatusEnumEnumMap = {
  DriversRecordStatusEnum.available: 'available',
  DriversRecordStatusEnum.assigned: 'assigned',
  DriversRecordStatusEnum.onTrip: 'on-trip',
};
