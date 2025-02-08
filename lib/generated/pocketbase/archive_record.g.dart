// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'archive_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ArchiveRecord _$ArchiveRecordFromJson(Map<String, dynamic> json) =>
    ArchiveRecord(
      id: json['id'] as String,
      created: pocketBaseDateTimeFromJson(json['created'] as String),
      updated: pocketBaseDateTimeFromJson(json['updated'] as String),
      collectionId: json['collectionId'] as String,
      collectionName: json['collectionName'] as String,
      trip_id: json['trip_id'] as String?,
      completed_at:
          pocketBaseNullableDateTimeFromJson(json['completed_at'] as String),
      notes: json['notes'] as String?,
    );

Map<String, dynamic> _$ArchiveRecordToJson(ArchiveRecord instance) =>
    <String, dynamic>{
      'id': instance.id,
      'created': pocketBaseDateTimeToJson(instance.created),
      'updated': pocketBaseDateTimeToJson(instance.updated),
      'collectionId': instance.collectionId,
      'collectionName': instance.collectionName,
      'trip_id': instance.trip_id,
      'completed_at': pocketBaseNullableDateTimeToJson(instance.completed_at),
      'notes': instance.notes,
    };
