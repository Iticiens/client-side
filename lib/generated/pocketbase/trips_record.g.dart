// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trips_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TripsRecord _$TripsRecordFromJson(Map<String, dynamic> json) => TripsRecord(
      id: json['id'] as String,
      created: pocketBaseDateTimeFromJson(json['created'] as String),
      updated: pocketBaseDateTimeFromJson(json['updated'] as String),
      collectionId: json['collectionId'] as String,
      collectionName: json['collectionName'] as String,
      truck_id: json['truck_id'] as String?,
      newdriver: json['newdriver'] as String?,
      expand: json['expand'] as Map<String, dynamic>?,
      driver: json['driver'] as String?,
      order_id: json['order_id'] as String?,
      arrival_time:
          pocketBaseNullableDateTimeFromJson(json['arrival_time'] as String),
      departure_time:
          pocketBaseNullableDateTimeFromJson(json['departure_time'] as String),
      status:
          $enumDecodeNullable(_$TripsRecordStatusEnumEnumMap, json['status']),
      stations: (json['stations'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$TripsRecordToJson(TripsRecord instance) =>
    <String, dynamic>{
      'id': instance.id,
      'created': pocketBaseDateTimeToJson(instance.created),
      'updated': pocketBaseDateTimeToJson(instance.updated),
      'collectionId': instance.collectionId,
      'collectionName': instance.collectionName,
      'truck_id': instance.truck_id,
      'newdriver': instance.newdriver,
      'expand': instance.expand,
      'driver': instance.driver,
      'order_id': instance.order_id,
      'arrival_time': pocketBaseNullableDateTimeToJson(instance.arrival_time),
      'departure_time':
          pocketBaseNullableDateTimeToJson(instance.departure_time),
      'status': _$TripsRecordStatusEnumEnumMap[instance.status],
      'stations': instance.stations,
    };

const _$TripsRecordStatusEnumEnumMap = {
  TripsRecordStatusEnum.scheduled: 'scheduled',
  TripsRecordStatusEnum.inProgress: 'in_progress',
  TripsRecordStatusEnum.completed: 'completed',
};
