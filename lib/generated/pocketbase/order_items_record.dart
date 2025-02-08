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

part 'order_items_record.g.dart';

enum Order_itemsRecordFieldsEnum {
  id,
  created,
  updated,
  collectionId,
  collectionName,
  order_id,
  stock_id,
  quantity
}

@_i1.JsonSerializable()
final class Order_itemsRecord extends _i2.BaseRecord {
  Order_itemsRecord({
    required super.id,
    required super.created,
    required super.updated,
    required super.collectionId,
    required super.collectionName,
    this.order_id,
    this.stock_id,
    this.quantity,
  });

  factory Order_itemsRecord.fromJson(Map<String, dynamic> json) =>
      _$Order_itemsRecordFromJson(json);

  factory Order_itemsRecord.fromRecordModel(_i3.RecordModel recordModel) {
    final extendedJsonMap = {
      ...recordModel.data,
      Order_itemsRecordFieldsEnum.id.name: recordModel.id,
      Order_itemsRecordFieldsEnum.created.name: recordModel.created,
      Order_itemsRecordFieldsEnum.updated.name: recordModel.updated,
      Order_itemsRecordFieldsEnum.collectionId.name: recordModel.collectionId,
      Order_itemsRecordFieldsEnum.collectionName.name:
          recordModel.collectionName,
    };
    return Order_itemsRecord.fromJson(extendedJsonMap);
  }

  final String? order_id;

  final String? stock_id;

  final double? quantity;

  static const $collectionId = 'nkb0hp5jhhqj19j';

  static const $collectionName = 'order_items';

  Map<String, dynamic> toJson() => _$Order_itemsRecordToJson(this);

  Order_itemsRecord copyWith({
    String? order_id,
    String? stock_id,
    double? quantity,
  }) {
    return Order_itemsRecord(
      id: id,
      created: created,
      updated: updated,
      collectionId: collectionId,
      collectionName: collectionName,
      order_id: order_id ?? this.order_id,
      stock_id: stock_id ?? this.stock_id,
      quantity: quantity ?? this.quantity,
    );
  }

  Map<String, dynamic> takeDiff(Order_itemsRecord other) {
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
        order_id,
        stock_id,
        quantity,
      ];

  static Map<String, dynamic> forCreateRequest({
    String? order_id,
    String? stock_id,
    double? quantity,
  }) {
    final jsonMap = Order_itemsRecord(
      id: '',
      created: _i5.EmptyDateTime(),
      updated: _i5.EmptyDateTime(),
      collectionId: $collectionId,
      collectionName: $collectionName,
      order_id: order_id,
      stock_id: stock_id,
      quantity: quantity,
    ).toJson();
    final Map<String, dynamic> result = {};
    if (order_id != null) {
      result.addAll({
        Order_itemsRecordFieldsEnum.order_id.name:
            jsonMap[Order_itemsRecordFieldsEnum.order_id.name]
      });
    }
    if (stock_id != null) {
      result.addAll({
        Order_itemsRecordFieldsEnum.stock_id.name:
            jsonMap[Order_itemsRecordFieldsEnum.stock_id.name]
      });
    }
    if (quantity != null) {
      result.addAll({
        Order_itemsRecordFieldsEnum.quantity.name:
            jsonMap[Order_itemsRecordFieldsEnum.quantity.name]
      });
    }
    return result;
  }
}
