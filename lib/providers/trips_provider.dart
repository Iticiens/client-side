import 'package:flutter/material.dart';
import 'package:iot/generated/pocketbase/orders_record.dart';
import 'package:iot/generated/pocketbase/stations_record.dart';
import 'package:iot/generated/pocketbase/trips_record.dart';
import 'package:iot/generated/pocketbase/truckes_record.dart';
import 'package:iot/main.dart';
import 'package:iot/repository/trips_repository.dart';

class TripsProvider extends ChangeNotifier {
  TripsRepository _tripsRepository;

  TripsProvider(this._tripsRepository);

  List<TripsRecord> _trips = [];
  List<TripsRecord> get trips => _trips;

  Map<String, dynamic> gettrips = {};

  Future<void> fetchTrips() async {
    _trips = await _tripsRepository.getTripsForMyStations();
    notifyListeners();
  }

  Future<void> getTripsForMyStations() async {
    var trips = await pb.collection('trips').getFullList(expand: 'stations');
    _trips = trips.map((e) {
      return TripsRecord.fromRecordModel(e);
    }).toList();

    print(trips);
  }
}
