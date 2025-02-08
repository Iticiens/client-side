// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_items_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Order_itemsRecord _$Order_itemsRecordFromJson(Map<String, dynamic> json) =>
    Order_itemsRecord(
      id: json['id'] as String,
      created: pocketBaseDateTimeFromJson(json['created'] as String),
      updated: pocketBaseDateTimeFromJson(json['updated'] as String),
      collectionId: json['collectionId'] as String,
      collectionName: json['collectionName'] as String,
      order_id: json['order_id'] as String?,
      stock_id: json['stock_id'] as String?,
      quantity: (json['quantity'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$Order_itemsRecordToJson(Order_itemsRecord instance) =>
    <String, dynamic>{
      'id': instance.id,
      'created': pocketBaseDateTimeToJson(instance.created),
      'updated': pocketBaseDateTimeToJson(instance.updated),
      'collectionId': instance.collectionId,
      'collectionName': instance.collectionName,
      'order_id': instance.order_id,
      'stock_id': instance.stock_id,
      'quantity': instance.quantity,
    };
