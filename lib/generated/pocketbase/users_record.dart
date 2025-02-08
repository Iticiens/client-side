// GENERATED CODE - DO NOT MODIFY BY HAND
// *****************************************************
// POCKETBASE_UTILS
// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint

// ignore_for_file: unused_import

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:collection/collection.dart' as _i4;
import 'package:json_annotation/json_annotation.dart' as _i1;
import 'package:json_annotation/json_annotation.dart';
import 'package:pocketbase/pocketbase.dart' as _i3;

import 'auth_record.dart' as _i2;
import 'date_time_json_methods.dart';
import 'empty_values.dart' as _i5;

part 'users_record.g.dart';

enum UsersRecordFieldsEnum {
  id,
  created,
  updated,
  collectionId,
  collectionName,
  username,
  email,
  emailVisibility,
  verified,

  /// THIS FIELD IS ONLY FOR CREATING AN AUTH TYPE RECORD
  password,

  /// THIS FIELD IS ONLY FOR CREATING AN AUTH TYPE RECORD
  passwordConfirm,
  name,
  avatar,
  client,
  drivers,
  role,
  stations,
  expand
}

enum UsersRecordRoleEnum {
  @_i1.JsonValue('client')
  client,
  @_i1.JsonValue('driver')
  driver,
  @_i1.JsonValue('admin')
  admin
}

@_i1.JsonSerializable()
final class UsersRecord extends _i2.AuthRecord {
  UsersRecord({
    required super.id,
    this.stations,
    this.expand,
    required super.created,
    required super.updated,
    required super.collectionId,
    required super.collectionName,
    required super.username,
    required super.email,
    required super.emailVisibility,
    required super.verified,
    this.name,
    this.avatar,
    this.client,
    this.drivers,
    this.role,
  });

  factory UsersRecord.fromJson(Map<String, dynamic> json) =>
      _$UsersRecordFromJson(json);

  factory UsersRecord.fromRecordModel(_i3.RecordModel recordModel) {
    final extendedJsonMap = {
      ...recordModel.data,
      UsersRecordFieldsEnum.id.name: recordModel.id,
      UsersRecordFieldsEnum.created.name: recordModel.created,
      UsersRecordFieldsEnum.updated.name: recordModel.updated,
      UsersRecordFieldsEnum.collectionId.name: recordModel.collectionId,
      UsersRecordFieldsEnum.collectionName.name: recordModel.collectionName,
      UsersRecordFieldsEnum.expand.name: recordModel.expand,
    };
    return UsersRecord.fromJson(extendedJsonMap);
  }

  final String? name;

  final String? avatar;

  final String? client;

  final String? drivers;
  final List<String>? stations;
  final Map<String, dynamic>? expand;

  final UsersRecordRoleEnum? role;

  static const $collectionId = '_pb_users_auth_';

  static const $collectionName = 'users';

  Map<String, dynamic> toJson() => _$UsersRecordToJson(this);

  UsersRecord copyWith({
    String? username,
    String? email,
    List<String>? stations,
    Map<String, dynamic>? expand,
    bool? emailVisibility,
    bool? verified,
    String? name,
    String? avatar,
    String? client,
    String? drivers,
    UsersRecordRoleEnum? role,
  }) {
    return UsersRecord(
      id: id,
      created: created,
      updated: updated,
      collectionId: collectionId,
      collectionName: collectionName,
      username: username ?? this.username,
      email: email ?? this.email,
      emailVisibility: emailVisibility ?? this.emailVisibility,
      verified: verified ?? this.verified,
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
      client: client ?? this.client,
      drivers: drivers ?? this.drivers,
      role: role ?? this.role,
    );
  }

  Map<String, dynamic> takeDiff(UsersRecord other) {
    final thisInJsonMap = toJson();
    final otherInJsonMap = other.toJson();
    final Map<String, dynamic> result = {};
    final _i4.DeepCollectionEquality deepCollectionEquality =
        _i4.DeepCollectionEquality();
    for (final mapEntry in thisInJsonMap.entries) {
      final thisValue = mapEntry.value;
      final otherValue = otherInJsonMap[mapEntry.key];
      if (!deepCollectionEquality.equals(
        thisValue,
        otherValue,
      )) {
        result.addAll({mapEntry.key: otherValue});
      }
    }
    return result;
  }

  @override
  List<Object?> get props => [
        ...super.props,
        name,
        avatar,
        client,
        expand,
        stations,
        drivers,
        role,
      ];

  static Map<String, dynamic> forCreateRequest({
    required String username,
    required String email,
    required bool emailVisibility,
    required bool verified,
    String? name,
    String? avatar,
    String? client,
    String? drivers,
    UsersRecordRoleEnum? role,
    List<String>? stations,
    Map<String, dynamic>? expand,
  }) {
    final jsonMap = UsersRecord(
      id: '',
      created: _i5.EmptyDateTime(),
      updated: _i5.EmptyDateTime(),
      collectionId: $collectionId,
      collectionName: $collectionName,
      username: username,
      email: email,
      stations: stations,
      expand: expand,
      emailVisibility: emailVisibility,
      verified: verified,
      name: name,
      avatar: avatar,
      client: client,
      drivers: drivers,
      role: role,
    ).toJson();
    final Map<String, dynamic> result = {};

    result.addAll({
      UsersRecordFieldsEnum.username.name:
          jsonMap[UsersRecordFieldsEnum.username.name]
    });
    result.addAll({
      UsersRecordFieldsEnum.email.name:
          jsonMap[UsersRecordFieldsEnum.email.name]
    });
    result.addAll({
      UsersRecordFieldsEnum.emailVisibility.name:
          jsonMap[UsersRecordFieldsEnum.emailVisibility.name]
    });
    result.addAll({
      UsersRecordFieldsEnum.verified.name:
          jsonMap[UsersRecordFieldsEnum.verified.name]
    });
    if (name != null) {
      result.addAll({
        UsersRecordFieldsEnum.name.name:
            jsonMap[UsersRecordFieldsEnum.name.name]
      });
    }
    if (avatar != null) {
      result.addAll({
        UsersRecordFieldsEnum.avatar.name:
            jsonMap[UsersRecordFieldsEnum.avatar.name]
      });
    }
    if (expand != null) {
      result.addAll({
        UsersRecordFieldsEnum.expand.name:
            jsonMap[UsersRecordFieldsEnum.expand.name]
      });
    }
    if (stations != null) {
      result.addAll({
        UsersRecordFieldsEnum.stations.name:
            jsonMap[UsersRecordFieldsEnum.stations.name]
      });
    }
    if (client != null) {
      result.addAll({
        UsersRecordFieldsEnum.client.name:
            jsonMap[UsersRecordFieldsEnum.client.name]
      });
    }
    if (drivers != null) {
      result.addAll({
        UsersRecordFieldsEnum.drivers.name:
            jsonMap[UsersRecordFieldsEnum.drivers.name]
      });
    }
    if (role != null) {
      result.addAll({
        UsersRecordFieldsEnum.role.name:
            jsonMap[UsersRecordFieldsEnum.role.name]
      });
    }
    return result;
  }
}
