import 'package:iot/generated/pocketbase/truckes_record.dart';
import 'package:iot/main.dart';

abstract class TrucksRepository {
  Future<List<TruckesRecord>> getTrucks();

  Future<TruckesRecord> getTruck(String id);
}

class TrucksRepositoryImpl extends TrucksRepository {
  @override
  Future<List<TruckesRecord>> getTrucks() async {
    var trucks = await pb.collection('truckes').getFullList();

    var trucksRecord = trucks.map((e) {
      return TruckesRecord.fromRecordModel(e);
    }).toList();

    return trucksRecord;
  }

  @override
  Future<TruckesRecord> getTruck(String id) async {
    throw UnimplementedError();
  }
}
