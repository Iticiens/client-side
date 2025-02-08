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

part 'truckes_record.g.dart';

enum TruckesRecordFieldsEnum {
  id,
  created,
  updated,
  collectionId,
  collectionName,
  type,
  max_weight,
  max_volume,
  max_dist,
  plate_number,
  status
}

enum TruckesRecordStatusEnum {
  @_i1.JsonValue('available')
  available,
  @_i1.JsonValue('assigned')
  assigned,
  @_i1.JsonValue('in_transit')
  inTransit
}

@_i1.JsonSerializable()
final class TruckesRecord extends _i2.BaseRecord {
  TruckesRecord({
    required super.id,
    required super.created,
    required super.updated,
    required super.collectionId,
    required super.collectionName,
    this.type,
    this.max_weight,
    this.max_volume,
    this.max_dist,
    this.plate_number,
    this.status,
  });

  factory TruckesRecord.fromJson(Map<String, dynamic> json) =>
      _$TruckesRecordFromJson(json);

  factory TruckesRecord.fromRecordModel(_i3.RecordModel recordModel) {
    final extendedJsonMap = {
      ...recordModel.data,
      TruckesRecordFieldsEnum.id.name: recordModel.id,
      TruckesRecordFieldsEnum.created.name: recordModel.created,
      TruckesRecordFieldsEnum.updated.name: recordModel.updated,
      TruckesRecordFieldsEnum.collectionId.name: recordModel.collectionId,
      TruckesRecordFieldsEnum.collectionName.name: recordModel.collectionName,
    };
    return TruckesRecord.fromJson(extendedJsonMap);
  }

  final String? type;

  final double? max_weight;

  final double? max_volume;

  final double? max_dist;

  final String? plate_number;

  final TruckesRecordStatusEnum? status;

  static const $collectionId = '2llkpu3ca9z7obx';

  static const $collectionName = 'truckes';

  Map<String, dynamic> toJson() => _$TruckesRecordToJson(this);

  TruckesRecord copyWith({
    String? type,
    double? max_weight,
    double? max_volume,
    double? max_dist,
    String? plate_number,
    TruckesRecordStatusEnum? status,
  }) {
    return TruckesRecord(
      id: id,
      created: created,
      updated: updated,
      collectionId: collectionId,
      collectionName: collectionName,
      type: type ?? this.type,
      max_weight: max_weight ?? this.max_weight,
      max_volume: max_volume ?? this.max_volume,
      max_dist: max_dist ?? this.max_dist,
      plate_number: plate_number ?? this.plate_number,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> takeDiff(TruckesRecord other) {
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
        type,
        max_weight,
        max_volume,
        max_dist,
        plate_number,
        status,
      ];

  static Map<String, dynamic> forCreateRequest({
    String? type,
    double? max_weight,
    double? max_volume,
    double? max_dist,
    String? plate_number,
    TruckesRecordStatusEnum? status,
  }) {
    final jsonMap = TruckesRecord(
      id: '',
      created: _i5.EmptyDateTime(),
      updated: _i5.EmptyDateTime(),
      collectionId: $collectionId,
      collectionName: $collectionName,
      type: type,
      max_weight: max_weight,
      max_volume: max_volume,
      max_dist: max_dist,
      plate_number: plate_number,
      status: status,
    ).toJson();
    final Map<String, dynamic> result = {};
    if (type != null) {
      result.addAll({
        TruckesRecordFieldsEnum.type.name:
            jsonMap[TruckesRecordFieldsEnum.type.name]
      });
    }
    if (max_weight != null) {
      result.addAll({
        TruckesRecordFieldsEnum.max_weight.name:
            jsonMap[TruckesRecordFieldsEnum.max_weight.name]
      });
    }
    if (max_volume != null) {
      result.addAll({
        TruckesRecordFieldsEnum.max_volume.name:
            jsonMap[TruckesRecordFieldsEnum.max_volume.name]
      });
    }
    if (max_dist != null) {
      result.addAll({
        TruckesRecordFieldsEnum.max_dist.name:
            jsonMap[TruckesRecordFieldsEnum.max_dist.name]
      });
    }
    if (plate_number != null) {
      result.addAll({
        TruckesRecordFieldsEnum.plate_number.name:
            jsonMap[TruckesRecordFieldsEnum.plate_number.name]
      });
    }
    if (status != null) {
      result.addAll({
        TruckesRecordFieldsEnum.status.name:
            jsonMap[TruckesRecordFieldsEnum.status.name]
      });
    }
    return result;
  }
}
