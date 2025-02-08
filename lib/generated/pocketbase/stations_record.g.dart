// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stations_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StationsRecord _$StationsRecordFromJson(Map<String, dynamic> json) =>
    StationsRecord(
      id: json['id'] as String,
      created: pocketBaseDateTimeFromJson(json['created'] as String),
      updated: pocketBaseDateTimeFromJson(json['updated'] as String),
      collectionId: json['collectionId'] as String,
      collectionName: json['collectionName'] as String,
      lat: (json['lat'] as num?)?.toDouble(),
      lang: (json['lang'] as num?)?.toDouble(),
      avatar: json['avatar'] as String?,
      name: json['name'] as String?,
    );

Map<String, dynamic> _$StationsRecordToJson(StationsRecord instance) =>
    <String, dynamic>{
      'id': instance.id,
      'created': pocketBaseDateTimeToJson(instance.created),
      'updated': pocketBaseDateTimeToJson(instance.updated),
      'collectionId': instance.collectionId,
      'collectionName': instance.collectionName,
      'lat': instance.lat,
      'lang': instance.lang,
      'avatar': instance.avatar,
      'name': instance.name,
    };
