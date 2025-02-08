import 'package:iot/generated/pocketbase/trips_record.dart';
import 'package:iot/main.dart';

abstract class TripsRepository {
  Future<List<TripsRecord>> getTripsForMyStations();

  Future<TripsRecord> getTrip(String id);
}

class TripsRepositoryImpl extends TripsRepository {
  @override
  Future<List<TripsRecord>> getTripsForMyStations() async {
    var trips = await pb.collection('trips').getFullList(expand: 'stations');
    var tripsRecord = trips.map((e) {
      return TripsRecord.fromRecordModel(e);
    }).toList();

    print(trips);
    return tripsRecord;
  }

  @override
  Future<TripsRecord> getTrip(String id) async {
    throw UnimplementedError();
  }
}
