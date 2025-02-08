// GENERATED CODE - DO NOT MODIFY BY HAND
// *****************************************************
// POCKETBASE_UTILS
// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint

// ignore_for_file: unused_import

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:collection/collection.dart' as _i4;
import 'package:iot/models/trip.dart';
import 'package:json_annotation/json_annotation.dart' as _i1;
import 'package:json_annotation/json_annotation.dart';
import 'package:pocketbase/pocketbase.dart' as _i3;

import 'base_record.dart' as _i2;
import 'date_time_json_methods.dart';
import 'empty_values.dart' as _i5;

part 'trips_record.g.dart';

enum TripsRecordFieldsEnum {
  id,
  created,
  updated,
  collectionId,
  collectionName,
  truck_id,
  driver,
  order_id,
  arrival_time,
  departure_time,
  status,
  expand,
  newdriver,
  stations
}

enum TripsRecordStatusEnum {
  @_i1.JsonValue('scheduled')
  scheduled,
  @_i1.JsonValue('in_progress')
  inProgress,
  @_i1.JsonValue('completed')
  completed
}

@_i1.JsonSerializable()
final class TripsRecord extends _i2.BaseRecord {
  TripsRecord({
    required super.id,
    required super.created,
    required super.updated,
    required super.collectionId,
    required super.collectionName,
    this.truck_id,
    this.newdriver,
    this.expand,
    this.driver,
    this.order_id,
    this.arrival_time,
    this.departure_time,
    this.status,
    this.stations,
  });

  factory TripsRecord.fromJson(Map<String, dynamic> json) =>
      _$TripsRecordFromJson(json);

  factory TripsRecord.fromRecordModel(_i3.RecordModel recordModel) {
    final extendedJsonMap = {
      ...recordModel.data,
      TripsRecordFieldsEnum.id.name: recordModel.id,
      TripsRecordFieldsEnum.created.name: recordModel.created,
      TripsRecordFieldsEnum.updated.name: recordModel.updated,
      TripsRecordFieldsEnum.collectionId.name: recordModel.collectionId,
      TripsRecordFieldsEnum.collectionName.name: recordModel.collectionName,
      TripsRecordFieldsEnum.expand.name: recordModel.expand,
    };
    return TripsRecord.fromJson(extendedJsonMap);
  }

  final String? truck_id;
  final String? newdriver;
  final Map<String, dynamic>? expand;
  final String? driver;

  final String? order_id;

  @_i1.JsonKey(
    toJson: pocketBaseNullableDateTimeToJson,
    fromJson: pocketBaseNullableDateTimeFromJson,
  )
  final DateTime? arrival_time;

  @_i1.JsonKey(
    toJson: pocketBaseNullableDateTimeToJson,
    fromJson: pocketBaseNullableDateTimeFromJson,
  )
  final DateTime? departure_time;

  final TripsRecordStatusEnum? status;

  final List<String>? stations;

  static const $collectionId = '2dmb4e1tmwx53e1';

  static const $collectionName = 'trips';

  Map<String, dynamic> toJson() => _$TripsRecordToJson(this);

  TripsRecord copyWith({
    String? truck_id,
    String? driver,
    String? order_id,
    DateTime? arrival_time,
    String? newdriver,
    DateTime? departure_time,
    TripsRecordStatusEnum? status,
    List<String>? stations,
  }) {
    return TripsRecord(
      id: id,
      newdriver: newdriver ?? this.newdriver,
      created: created,
      updated: updated,
      collectionId: collectionId,
      collectionName: collectionName,
      truck_id: truck_id ?? this.truck_id,
      driver: driver ?? this.driver,
      order_id: order_id ?? this.order_id,
      arrival_time: arrival_time ?? this.arrival_time,
      departure_time: departure_time ?? this.departure_time,
      status: status ?? this.status,
      expand: expand ?? this.expand,
      stations: stations ?? this.stations,
    );
  }

  Map<String, dynamic> takeDiff(TripsRecord other) {
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
        truck_id,
        driver,
        order_id,
        arrival_time,
        departure_time,
        status,
        expand,
        newdriver,
        stations,
      ];

  static Map<String, dynamic> forCreateRequest({
    String? truck_id,
    String? driver,
    String? order_id,
    DateTime? arrival_time,
    String? newdriver,
    Map<String, dynamic>? expand,
    DateTime? departure_time,
    TripsRecordStatusEnum? status,
    List<String>? stations,
  }) {
    final jsonMap = TripsRecord(
      id: '',
      created: _i5.EmptyDateTime(),
      updated: _i5.EmptyDateTime(),
      collectionId: $collectionId,
      collectionName: $collectionName,
      truck_id: truck_id,
      expand: expand,
      newdriver: newdriver,
      driver: driver,
      order_id: order_id,
      arrival_time: arrival_time,
      departure_time: departure_time,
      status: status,
      stations: stations,
    ).toJson();
    final Map<String, dynamic> result = {};
    if (truck_id != null) {
      result.addAll({
        TripsRecordFieldsEnum.truck_id.name:
            jsonMap[TripsRecordFieldsEnum.truck_id.name]
      });
    }
    if (newdriver != null) {
      result.addAll({
        TripsRecordFieldsEnum.newdriver.name:
            jsonMap[TripsRecordFieldsEnum.newdriver.name]
      });
    }
    if (expand != null) {
      result.addAll({
        TripsRecordFieldsEnum.expand.name:
            jsonMap[TripsRecordFieldsEnum.expand.name]
      });
    }

    if (driver != null) {
      result.addAll({
        TripsRecordFieldsEnum.driver.name:
            jsonMap[TripsRecordFieldsEnum.driver.name]
      });
    }
    if (order_id != null) {
      result.addAll({
        TripsRecordFieldsEnum.order_id.name:
            jsonMap[TripsRecordFieldsEnum.order_id.name]
      });
    }
    if (arrival_time != null) {
      result.addAll({
        TripsRecordFieldsEnum.arrival_time.name:
            jsonMap[TripsRecordFieldsEnum.arrival_time.name]
      });
    }
    if (departure_time != null) {
      result.addAll({
        TripsRecordFieldsEnum.departure_time.name:
            jsonMap[TripsRecordFieldsEnum.departure_time.name]
      });
    }
    if (status != null) {
      result.addAll({
        TripsRecordFieldsEnum.status.name:
            jsonMap[TripsRecordFieldsEnum.status.name]
      });
    }
    if (stations != null) {
      result.addAll({
        TripsRecordFieldsEnum.stations.name:
            jsonMap[TripsRecordFieldsEnum.stations.name]
      });
    }
    return result;
  }
}
