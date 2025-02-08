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

part 'archive_record.g.dart';

enum ArchiveRecordFieldsEnum {
  id,
  created,
  updated,
  collectionId,
  collectionName,
  trip_id,
  completed_at,
  notes
}

@_i1.JsonSerializable()
final class ArchiveRecord extends _i2.BaseRecord {
  ArchiveRecord({
    required super.id,
    required super.created,
    required super.updated,
    required super.collectionId,
    required super.collectionName,
    this.trip_id,
    this.completed_at,
    this.notes,
  });

  factory ArchiveRecord.fromJson(Map<String, dynamic> json) =>
      _$ArchiveRecordFromJson(json);

  factory ArchiveRecord.fromRecordModel(_i3.RecordModel recordModel) {
    final extendedJsonMap = {
      ...recordModel.data,
      ArchiveRecordFieldsEnum.id.name: recordModel.id,
      ArchiveRecordFieldsEnum.created.name: recordModel.created,
      ArchiveRecordFieldsEnum.updated.name: recordModel.updated,
      ArchiveRecordFieldsEnum.collectionId.name: recordModel.collectionId,
      ArchiveRecordFieldsEnum.collectionName.name: recordModel.collectionName,
    };
    return ArchiveRecord.fromJson(extendedJsonMap);
  }

  final String? trip_id;

  @_i1.JsonKey(
    toJson: pocketBaseNullableDateTimeToJson,
    fromJson: pocketBaseNullableDateTimeFromJson,
  )
  final DateTime? completed_at;

  final String? notes;

  static const $collectionId = 'k54rktw0frlia1f';

  static const $collectionName = 'Archive';

  Map<String, dynamic> toJson() => _$ArchiveRecordToJson(this);

  ArchiveRecord copyWith({
    String? trip_id,
    DateTime? completed_at,
    String? notes,
  }) {
    return ArchiveRecord(
      id: id,
      created: created,
      updated: updated,
      collectionId: collectionId,
      collectionName: collectionName,
      trip_id: trip_id ?? this.trip_id,
      completed_at: completed_at ?? this.completed_at,
      notes: notes ?? this.notes,
    );
  }

  Map<String, dynamic> takeDiff(ArchiveRecord other) {
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
        trip_id,
        completed_at,
        notes,
      ];

  static Map<String, dynamic> forCreateRequest({
    String? trip_id,
    DateTime? completed_at,
    String? notes,
  }) {
    final jsonMap = ArchiveRecord(
      id: '',
      created: _i5.EmptyDateTime(),
      updated: _i5.EmptyDateTime(),
      collectionId: $collectionId,
      collectionName: $collectionName,
      trip_id: trip_id,
      completed_at: completed_at,
      notes: notes,
    ).toJson();
    final Map<String, dynamic> result = {};
    if (trip_id != null) {
      result.addAll({
        ArchiveRecordFieldsEnum.trip_id.name:
            jsonMap[ArchiveRecordFieldsEnum.trip_id.name]
      });
    }
    if (completed_at != null) {
      result.addAll({
        ArchiveRecordFieldsEnum.completed_at.name:
            jsonMap[ArchiveRecordFieldsEnum.completed_at.name]
      });
    }
    if (notes != null) {
      result.addAll({
        ArchiveRecordFieldsEnum.notes.name:
            jsonMap[ArchiveRecordFieldsEnum.notes.name]
      });
    }
    return result;
  }
}
