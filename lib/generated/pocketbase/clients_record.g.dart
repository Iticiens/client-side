// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'clients_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ClientsRecord _$ClientsRecordFromJson(Map<String, dynamic> json) =>
    ClientsRecord(
      id: json['id'] as String,
      created: pocketBaseDateTimeFromJson(json['created'] as String),
      updated: pocketBaseDateTimeFromJson(json['updated'] as String),
      collectionId: json['collectionId'] as String,
      collectionName: json['collectionName'] as String,
      name: json['name'] as String?,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
    );

Map<String, dynamic> _$ClientsRecordToJson(ClientsRecord instance) =>
    <String, dynamic>{
      'id': instance.id,
      'created': pocketBaseDateTimeToJson(instance.created),
      'updated': pocketBaseDateTimeToJson(instance.updated),
      'collectionId': instance.collectionId,
      'collectionName': instance.collectionName,
      'name': instance.name,
      'email': instance.email,
      'phone': instance.phone,
    };
