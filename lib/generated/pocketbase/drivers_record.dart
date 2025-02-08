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

part 'drivers_record.g.dart';

enum DriversRecordFieldsEnum {
  id,
  created,
  updated,
  collectionId,
  collectionName,
  name,
  license_number,
  experience_years,
  phone,
  status
}

enum DriversRecordStatusEnum {
  @_i1.JsonValue('available')
  available,
  @_i1.JsonValue('assigned')
  assigned,
  @_i1.JsonValue('on-trip')
  onTrip
}

@_i1.JsonSerializable()
final class DriversRecord extends _i2.BaseRecord {
  DriversRecord({
    required super.id,
    required super.created,
    required super.updated,
    required super.collectionId,
    required super.collectionName,
    this.name,
    this.license_number,
    this.experience_years,
    this.phone,
    this.status,
  });

  factory DriversRecord.fromJson(Map<String, dynamic> json) =>
      _$DriversRecordFromJson(json);

  factory DriversRecord.fromRecordModel(_i3.RecordModel recordModel) {
    final extendedJsonMap = {
      ...recordModel.data,
      DriversRecordFieldsEnum.id.name: recordModel.id,
      DriversRecordFieldsEnum.created.name: recordModel.created,
      DriversRecordFieldsEnum.updated.name: recordModel.updated,
      DriversRecordFieldsEnum.collectionId.name: recordModel.collectionId,
      DriversRecordFieldsEnum.collectionName.name: recordModel.collectionName,
    };
    return DriversRecord.fromJson(extendedJsonMap);
  }

  final String? name;

  final String? license_number;

  final double? experience_years;

  final String? phone;

  final DriversRecordStatusEnum? status;

  static const $collectionId = 'k1cxa2ins6lcgqz';

  static const $collectionName = 'drivers';

  Map<String, dynamic> toJson() => _$DriversRecordToJson(this);

  DriversRecord copyWith({
    String? name,
    String? license_number,
    double? experience_years,
    String? phone,
    DriversRecordStatusEnum? status,
  }) {
    return DriversRecord(
      id: id,
      created: created,
      updated: updated,
      collectionId: collectionId,
      collectionName: collectionName,
      name: name ?? this.name,
      license_number: license_number ?? this.license_number,
      experience_years: experience_years ?? this.experience_years,
      phone: phone ?? this.phone,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> takeDiff(DriversRecord other) {
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
        license_number,
        experience_years,
        phone,
        status,
      ];

  static Map<String, dynamic> forCreateRequest({
    String? name,
    String? license_number,
    double? experience_years,
    String? phone,
    DriversRecordStatusEnum? status,
  }) {
    final jsonMap = DriversRecord(
      id: '',
      created: _i5.EmptyDateTime(),
      updated: _i5.EmptyDateTime(),
      collectionId: $collectionId,
      collectionName: $collectionName,
      name: name,
      license_number: license_number,
      experience_years: experience_years,
      phone: phone,
      status: status,
    ).toJson();
    final Map<String, dynamic> result = {};
    if (name != null) {
      result.addAll({
        DriversRecordFieldsEnum.name.name:
            jsonMap[DriversRecordFieldsEnum.name.name]
      });
    }
    if (license_number != null) {
      result.addAll({
        DriversRecordFieldsEnum.license_number.name:
            jsonMap[DriversRecordFieldsEnum.license_number.name]
      });
    }
    if (experience_years != null) {
      result.addAll({
        DriversRecordFieldsEnum.experience_years.name:
            jsonMap[DriversRecordFieldsEnum.experience_years.name]
      });
    }
    if (phone != null) {
      result.addAll({
        DriversRecordFieldsEnum.phone.name:
            jsonMap[DriversRecordFieldsEnum.phone.name]
      });
    }
    if (status != null) {
      result.addAll({
        DriversRecordFieldsEnum.status.name:
            jsonMap[DriversRecordFieldsEnum.status.name]
      });
    }
    return result;
  }
}
