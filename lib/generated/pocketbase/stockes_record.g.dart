// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stockes_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StockesRecord _$StockesRecordFromJson(Map<String, dynamic> json) =>
    StockesRecord(
      id: json['id'] as String,
      created: pocketBaseDateTimeFromJson(json['created'] as String),
      updated: pocketBaseDateTimeFromJson(json['updated'] as String),
      collectionId: json['collectionId'] as String,
      collectionName: json['collectionName'] as String,
      weight: (json['weight'] as num?)?.toDouble(),
      volume: (json['volume'] as num?)?.toDouble(),
      quantity: (json['quantity'] as num?)?.toDouble(),
      product_name: json['product_name'] as String?,
    );

Map<String, dynamic> _$StockesRecordToJson(StockesRecord instance) =>
    <String, dynamic>{
      'id': instance.id,
      'created': pocketBaseDateTimeToJson(instance.created),
      'updated': pocketBaseDateTimeToJson(instance.updated),
      'collectionId': instance.collectionId,
      'collectionName': instance.collectionName,
      'weight': instance.weight,
      'volume': instance.volume,
      'quantity': instance.quantity,
      'product_name': instance.product_name,
    };
