// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'truckes_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TruckesRecord _$TruckesRecordFromJson(Map<String, dynamic> json) =>
    TruckesRecord(
      id: json['id'] as String,
      created: pocketBaseDateTimeFromJson(json['created'] as String),
      updated: pocketBaseDateTimeFromJson(json['updated'] as String),
      collectionId: json['collectionId'] as String,
      collectionName: json['collectionName'] as String,
      type: json['type'] as String?,
      max_weight: (json['max_weight'] as num?)?.toDouble(),
      max_volume: (json['max_volume'] as num?)?.toDouble(),
      max_dist: (json['max_dist'] as num?)?.toDouble(),
      plate_number: json['plate_number'] as String?,
      status:
          $enumDecodeNullable(_$TruckesRecordStatusEnumEnumMap, json['status']),
    );

Map<String, dynamic> _$TruckesRecordToJson(TruckesRecord instance) =>
    <String, dynamic>{
      'id': instance.id,
      'created': pocketBaseDateTimeToJson(instance.created),
      'updated': pocketBaseDateTimeToJson(instance.updated),
      'collectionId': instance.collectionId,
      'collectionName': instance.collectionName,
      'type': instance.type,
      'max_weight': instance.max_weight,
      'max_volume': instance.max_volume,
      'max_dist': instance.max_dist,
      'plate_number': instance.plate_number,
      'status': _$TruckesRecordStatusEnumEnumMap[instance.status],
    };

const _$TruckesRecordStatusEnumEnumMap = {
  TruckesRecordStatusEnum.available: 'available',
  TruckesRecordStatusEnum.assigned: 'assigned',
  TruckesRecordStatusEnum.inTransit: 'in_transit',
};
