import 'package:latlong2/latlong.dart';

class TripWaypoint {
  final String name;
  final LatLng location;
  final String? description;
  bool isVisited;
  final DateTime? expectedArrival;

  TripWaypoint({
    required this.name,
    required this.location,
    this.description,
    this.isVisited = false,
    this.expectedArrival,
  });
}

class Trip {
  final String id;
  final String truckId;
  final String driverName;
  final List<TripWaypoint> waypoints;
  final DateTime startTime;
  final DateTime? endTime;
  bool isActive;

  Trip({
    required this.id,
    required this.truckId,
    required this.driverName,
    required this.waypoints,
    required this.startTime,
    this.endTime,
    this.isActive = false,
  });
}
