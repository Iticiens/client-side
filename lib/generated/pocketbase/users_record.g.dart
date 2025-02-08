// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'users_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UsersRecord _$UsersRecordFromJson(Map<String, dynamic> json) => UsersRecord(
      id: json['id'] as String,
      stations: (json['stations'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      expand: json['expand'] as Map<String, dynamic>?,
      created: pocketBaseDateTimeFromJson(json['created'] as String),
      updated: pocketBaseDateTimeFromJson(json['updated'] as String),
      collectionId: json['collectionId'] as String,
      collectionName: json['collectionName'] as String,
      username: json['username'] as String,
      email: json['email'] as String,
      emailVisibility: json['emailVisibility'] as bool,
      verified: json['verified'] as bool,
      name: json['name'] as String?,
      avatar: json['avatar'] as String?,
      client: json['client'] as String?,
      drivers: json['drivers'] as String?,
      role: $enumDecodeNullable(_$UsersRecordRoleEnumEnumMap, json['role']),
    );

Map<String, dynamic> _$UsersRecordToJson(UsersRecord instance) =>
    <String, dynamic>{
      'id': instance.id,
      'created': pocketBaseDateTimeToJson(instance.created),
      'updated': pocketBaseDateTimeToJson(instance.updated),
      'collectionId': instance.collectionId,
      'collectionName': instance.collectionName,
      'username': instance.username,
      'email': instance.email,
      'emailVisibility': instance.emailVisibility,
      'verified': instance.verified,
      'name': instance.name,
      'avatar': instance.avatar,
      'client': instance.client,
      'drivers': instance.drivers,
      'stations': instance.stations,
      'expand': instance.expand,
      'role': _$UsersRecordRoleEnumEnumMap[instance.role],
    };

const _$UsersRecordRoleEnumEnumMap = {
  UsersRecordRoleEnum.client: 'client',
  UsersRecordRoleEnum.driver: 'driver',
  UsersRecordRoleEnum.admin: 'admin',
};
