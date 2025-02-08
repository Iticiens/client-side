import 'dart:ui';

import 'package:iot/generated/pocketbase/base_record.dart';
import 'package:iot/main.dart';
import 'package:pocketbase/pocketbase.dart';

Future<List<T>> loadRecords<T extends BaseRecord>(
  String collectionName,
  T Function(RecordModel) fromRecordModel, {
  String? expand,
  String? filter,
  String? sort,
}) async {
  return (await pb.collection(collectionName).getFullList(
            expand: expand,
            filter: filter,
            sort: sort,
          ))
      .map((e) {
    return fromRecordModel(e);
  }).toList();
}

extension RecordModelFileUrl on BaseRecord {
  /// Returns the file URL of the record.
  String? fileUrl(String? name, {Size? thumb}) {
    if (name == null) return null;
    var baseUrl = pb.baseUrl;
    var collectionName = this.collectionName;
    var id = this.id;
    var thumbStr = thumb != null ? "?thumb=${thumb.width}x${thumb.height}" : "";
    return "$baseUrl/api/files/$collectionName/$id/$name$thumbStr";
  }
}
