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

part 'stockes_record.g.dart';

enum StockesRecordFieldsEnum {
  id,
  created,
  updated,
  collectionId,
  collectionName,
  weight,
  volume,
  quantity,
  product_name
}

@_i1.JsonSerializable()
final class StockesRecord extends _i2.BaseRecord {
  StockesRecord({
    required super.id,
    required super.created,
    required super.updated,
    required super.collectionId,
    required super.collectionName,
    this.weight,
    this.volume,
    this.quantity,
    this.product_name,
  });

  factory StockesRecord.fromJson(Map<String, dynamic> json) =>
      _$StockesRecordFromJson(json);

  factory StockesRecord.fromRecordModel(_i3.RecordModel recordModel) {
    final extendedJsonMap = {
      ...recordModel.data,
      StockesRecordFieldsEnum.id.name: recordModel.id,
      StockesRecordFieldsEnum.created.name: recordModel.created,
      StockesRecordFieldsEnum.updated.name: recordModel.updated,
      StockesRecordFieldsEnum.collectionId.name: recordModel.collectionId,
      StockesRecordFieldsEnum.collectionName.name: recordModel.collectionName,
    };
    return StockesRecord.fromJson(extendedJsonMap);
  }

  final double? weight;

  final double? volume;

  final double? quantity;

  final String? product_name;

  static const $collectionId = 'hj9ua7kee73pmnl';

  static const $collectionName = 'stockes';

  Map<String, dynamic> toJson() => _$StockesRecordToJson(this);

  StockesRecord copyWith({
    double? weight,
    double? volume,
    double? quantity,
    String? product_name,
  }) {
    return StockesRecord(
      id: id,
      created: created,
      updated: updated,
      collectionId: collectionId,
      collectionName: collectionName,
      weight: weight ?? this.weight,
      volume: volume ?? this.volume,
      quantity: quantity ?? this.quantity,
      product_name: product_name ?? this.product_name,
    );
  }

  Map<String, dynamic> takeDiff(StockesRecord other) {
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
        weight,
        volume,
        quantity,
        product_name,
      ];

  static Map<String, dynamic> forCreateRequest({
    double? weight,
    double? volume,
    double? quantity,
    String? product_name,
  }) {
    final jsonMap = StockesRecord(
      id: '',
      created: _i5.EmptyDateTime(),
      updated: _i5.EmptyDateTime(),
      collectionId: $collectionId,
      collectionName: $collectionName,
      weight: weight,
      volume: volume,
      quantity: quantity,
      product_name: product_name,
    ).toJson();
    final Map<String, dynamic> result = {};
    if (weight != null) {
      result.addAll({
        StockesRecordFieldsEnum.weight.name:
            jsonMap[StockesRecordFieldsEnum.weight.name]
      });
    }
    if (volume != null) {
      result.addAll({
        StockesRecordFieldsEnum.volume.name:
            jsonMap[StockesRecordFieldsEnum.volume.name]
      });
    }
    if (quantity != null) {
      result.addAll({
        StockesRecordFieldsEnum.quantity.name:
            jsonMap[StockesRecordFieldsEnum.quantity.name]
      });
    }
    if (product_name != null) {
      result.addAll({
        StockesRecordFieldsEnum.product_name.name:
            jsonMap[StockesRecordFieldsEnum.product_name.name]
      });
    }
    return result;
  }
}
