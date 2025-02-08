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

part 'orders_record.g.dart';

enum OrdersRecordFieldsEnum {
  id,
  created,
  updated,
  collectionId,
  collectionName,
  quantity,
  address,
  status,
  client_id,
}

enum OrdersRecordStatusEnum {
  @_i1.JsonValue('pending')
  pending,
  @_i1.JsonValue('in_progress')
  inProgress,
  @_i1.JsonValue('delivered')
  delivered
}

@_i1.JsonSerializable()
final class OrdersRecord extends _i2.BaseRecord {
  OrdersRecord({
    required super.id,
    required super.created,
    required super.updated,
    required super.collectionId,
    required super.collectionName,
    this.quantity,
    this.address,
    this.status,
    this.client_id,
  });

  factory OrdersRecord.fromJson(Map<String, dynamic> json) =>
      _$OrdersRecordFromJson(json);

  factory OrdersRecord.fromRecordModel(_i3.RecordModel recordModel) {
    final extendedJsonMap = {
      ...recordModel.data,
      OrdersRecordFieldsEnum.id.name: recordModel.id,
      OrdersRecordFieldsEnum.created.name: recordModel.created,
      OrdersRecordFieldsEnum.updated.name: recordModel.updated,
      OrdersRecordFieldsEnum.collectionId.name: recordModel.collectionId,
      OrdersRecordFieldsEnum.collectionName.name: recordModel.collectionName,
    };
    return OrdersRecord.fromJson(extendedJsonMap);
  }

  final double? quantity;

  final String? address;

  final OrdersRecordStatusEnum? status;

  final String? client_id;

  static const $collectionId = 'xpfdvaaqme1cyb6';

  static const $collectionName = 'orders';

  Map<String, dynamic> toJson() => _$OrdersRecordToJson(this);

  OrdersRecord copyWith({
    double? quantity,
    String? address,
    OrdersRecordStatusEnum? status,
    String? client_id,
  }) {
    return OrdersRecord(
      id: id,
      created: created,
      updated: updated,
      collectionId: collectionId,
      collectionName: collectionName,
      quantity: quantity ?? this.quantity,
      address: address ?? this.address,
      status: status ?? this.status,
      client_id: client_id ?? this.client_id,
    );
  }

  Map<String, dynamic> takeDiff(OrdersRecord other) {
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
        quantity,
        address,
        status,
        client_id,
      ];

  static Map<String, dynamic> forCreateRequest({
    double? quantity,
    String? address,
    OrdersRecordStatusEnum? status,
    String? client_id,
  }) {
    final jsonMap = OrdersRecord(
      id: '',
      created: _i5.EmptyDateTime(),
      updated: _i5.EmptyDateTime(),
      collectionId: $collectionId,
      collectionName: $collectionName,
      quantity: quantity,
      address: address,
      status: status,
      client_id: client_id,
    ).toJson();
    final Map<String, dynamic> result = {};
    if (quantity != null) {
      result.addAll({
        OrdersRecordFieldsEnum.quantity.name:
            jsonMap[OrdersRecordFieldsEnum.quantity.name]
      });
    }
    if (address != null) {
      result.addAll({
        OrdersRecordFieldsEnum.address.name:
            jsonMap[OrdersRecordFieldsEnum.address.name]
      });
    }
    if (status != null) {
      result.addAll({
        OrdersRecordFieldsEnum.status.name:
            jsonMap[OrdersRecordFieldsEnum.status.name]
      });
    }
    if (client_id != null) {
      result.addAll({
        OrdersRecordFieldsEnum.client_id.name:
            jsonMap[OrdersRecordFieldsEnum.client_id.name]
      });
    }
    return result;
  }
}
