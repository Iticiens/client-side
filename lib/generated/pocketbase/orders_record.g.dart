// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'orders_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrdersRecord _$OrdersRecordFromJson(Map<String, dynamic> json) => OrdersRecord(
      id: json['id'] as String,
      created: pocketBaseDateTimeFromJson(json['created'] as String),
      updated: pocketBaseDateTimeFromJson(json['updated'] as String),
      collectionId: json['collectionId'] as String,
      collectionName: json['collectionName'] as String,
      quantity: (json['quantity'] as num?)?.toDouble(),
      address: json['address'] as String?,
      status:
          $enumDecodeNullable(_$OrdersRecordStatusEnumEnumMap, json['status']),
      client_id: json['client_id'] as String?,
    );

Map<String, dynamic> _$OrdersRecordToJson(OrdersRecord instance) =>
    <String, dynamic>{
      'id': instance.id,
      'created': pocketBaseDateTimeToJson(instance.created),
      'updated': pocketBaseDateTimeToJson(instance.updated),
      'collectionId': instance.collectionId,
      'collectionName': instance.collectionName,
      'quantity': instance.quantity,
      'address': instance.address,
      'status': _$OrdersRecordStatusEnumEnumMap[instance.status],
      'client_id': instance.client_id,
    };

const _$OrdersRecordStatusEnumEnumMap = {
  OrdersRecordStatusEnum.pending: 'pending',
  OrdersRecordStatusEnum.inProgress: 'in_progress',
  OrdersRecordStatusEnum.delivered: 'delivered',
};
