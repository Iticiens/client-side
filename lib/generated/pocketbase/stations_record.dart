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

part 'stations_record.g.dart';

enum StationsRecordFieldsEnum {
  id,
  created,
  updated,
  collectionId,
  collectionName,
  lat,
  lang,
  avatar,
  name
}

@_i1.JsonSerializable()
final class StationsRecord extends _i2.BaseRecord {
  StationsRecord({
    required super.id,
    required super.created,
    required super.updated,
    required super.collectionId,
    required super.collectionName,
    this.lat,
    this.lang,
    this.avatar,
    this.name,
  });

  factory StationsRecord.fromJson(Map<String, dynamic> json) =>
      _$StationsRecordFromJson(json);

  factory StationsRecord.fromRecordModel(_i3.RecordModel recordModel) {
    final extendedJsonMap = {
      ...recordModel.data,
      StationsRecordFieldsEnum.id.name: recordModel.id,
      StationsRecordFieldsEnum.created.name: recordModel.created,
      StationsRecordFieldsEnum.updated.name: recordModel.updated,
      StationsRecordFieldsEnum.collectionId.name: recordModel.collectionId,
      StationsRecordFieldsEnum.collectionName.name: recordModel.collectionName,
    };
    return StationsRecord.fromJson(extendedJsonMap);
  }

  final double? lat;

  final double? lang;

  final String? avatar;

  final String? name;

  static const $collectionId = '03d9b9bwb3auw0p';

  static const $collectionName = 'stations';

  Map<String, dynamic> toJson() => _$StationsRecordToJson(this);

  StationsRecord copyWith({
    double? lat,
    double? lang,
    String? avatar,
    String? name,
  }) {
    return StationsRecord(
      id: id,
      created: created,
      updated: updated,
      collectionId: collectionId,
      collectionName: collectionName,
      lat: lat ?? this.lat,
      lang: lang ?? this.lang,
      avatar: avatar ?? this.avatar,
      name: name ?? this.name,
    );
  }

  Map<String, dynamic> takeDiff(StationsRecord other) {
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
        lat,
        lang,
        avatar,
        name,
      ];

  static Map<String, dynamic> forCreateRequest({
    double? lat,
    double? lang,
    String? avatar,
    String? name,
  }) {
    final jsonMap = StationsRecord(
      id: '',
      created: _i5.EmptyDateTime(),
      updated: _i5.EmptyDateTime(),
      collectionId: $collectionId,
      collectionName: $collectionName,
      lat: lat,
      lang: lang,
      avatar: avatar,
      name: name,
    ).toJson();
    final Map<String, dynamic> result = {};
    if (lat != null) {
      result.addAll({
        StationsRecordFieldsEnum.lat.name:
            jsonMap[StationsRecordFieldsEnum.lat.name]
      });
    }
    if (lang != null) {
      result.addAll({
        StationsRecordFieldsEnum.lang.name:
            jsonMap[StationsRecordFieldsEnum.lang.name]
      });
    }
    if (avatar != null) {
      result.addAll({
        StationsRecordFieldsEnum.avatar.name:
            jsonMap[StationsRecordFieldsEnum.avatar.name]
      });
    }
    if (name != null) {
      result.addAll({
        StationsRecordFieldsEnum.name.name:
            jsonMap[StationsRecordFieldsEnum.name.name]
      });
    }
    return result;
  }
}
