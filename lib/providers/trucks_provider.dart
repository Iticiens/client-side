// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:iot/generated/pocketbase/truckes_record.dart';

import 'package:iot/repository/trucks_repository.dart';

class TrucksProvider extends ChangeNotifier {
  TrucksRepository _trucksRepository;

  List<TruckesRecord> _trucks = [];
  TrucksProvider(
    this._trucksRepository,
  );

  List<TruckesRecord> get trucks => _trucks;

  Future<void> getTrucks() async {
    _trucks = await _trucksRepository.getTrucks();
    notifyListeners();
  }
}
