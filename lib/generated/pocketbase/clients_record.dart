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

import 'base_record.dart' as _i2;
import 'date_time_json_methods.dart';
import 'empty_values.dart' as _i5;

part 'clients_record.g.dart';

enum ClientsRecordFieldsEnum {
  id,
  created,
  updated,
  collectionId,
  collectionName,
  name,
  email,
  phone
}

@_i1.JsonSerializable()
final class ClientsRecord extends _i2.BaseRecord {
  ClientsRecord({
    required super.id,
    required super.created,
    required super.updated,
    required super.collectionId,
    required super.collectionName,
    this.name,
    this.email,
    this.phone,
  });

  factory ClientsRecord.fromJson(Map<String, dynamic> json) =>
      _$ClientsRecordFromJson(json);

  factory ClientsRecord.fromRecordModel(_i3.RecordModel recordModel) {
    final extendedJsonMap = {
      ...recordModel.data,
      ClientsRecordFieldsEnum.id.name: recordModel.id,
      ClientsRecordFieldsEnum.created.name: recordModel.created,
      ClientsRecordFieldsEnum.updated.name: recordModel.updated,
      ClientsRecordFieldsEnum.collectionId.name: recordModel.collectionId,
      ClientsRecordFieldsEnum.collectionName.name: recordModel.collectionName,
    };
    return ClientsRecord.fromJson(extendedJsonMap);
  }

  final String? name;

  final String? email;

  final String? phone;

  static const $collectionId = 't3w54uout8f8o8p';

  static const $collectionName = 'clients';

  Map<String, dynamic> toJson() => _$ClientsRecordToJson(this);

  ClientsRecord copyWith({
    String? name,
    String? email,
    String? phone,
  }) {
    return ClientsRecord(
      id: id,
      created: created,
      updated: updated,
      collectionId: collectionId,
      collectionName: collectionName,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
    );
  }

  Map<String, dynamic> takeDiff(ClientsRecord other) {
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
        email,
        phone,
      ];

  static Map<String, dynamic> forCreateRequest({
    String? name,
    String? email,
    String? phone,
  }) {
    final jsonMap = ClientsRecord(
      id: '',
      created: _i5.EmptyDateTime(),
      updated: _i5.EmptyDateTime(),
      collectionId: $collectionId,
      collectionName: $collectionName,
      name: name,
      email: email,
      phone: phone,
    ).toJson();
    final Map<String, dynamic> result = {};
    if (name != null) {
      result.addAll({
        ClientsRecordFieldsEnum.name.name:
            jsonMap[ClientsRecordFieldsEnum.name.name]
      });
    }
    if (email != null) {
      result.addAll({
        ClientsRecordFieldsEnum.email.name:
            jsonMap[ClientsRecordFieldsEnum.email.name]
      });
    }
    if (phone != null) {
      result.addAll({
        ClientsRecordFieldsEnum.phone.name:
            jsonMap[ClientsRecordFieldsEnum.phone.name]
      });
    }
    return result;
  }
}
