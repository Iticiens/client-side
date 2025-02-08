import 'dart:ui';
import 'dart:math' as math;
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:iot/helpers.dart';
import 'package:iot/main.dart';
import 'package:latlong2/latlong.dart';
import 'package:osrm/osrm.dart';
import 'package:provider/provider.dart';
import 'package:iot/core/providers/auth_provider.dart';
import 'package:iot/generated/pocketbase/stations_record.dart';
import 'package:iot/core/constants.dart'; // Add this import for API_URL

class TruckMarker {
  final String id;
  final String name;
  final String driverName;
  LatLng position;
  String status;
  final Color color;
  double speed;
  double fuelLevel;
  List<LatLng> routePoints;
  int currentRouteIndex;
  StationsRecord? targetStation;

  TruckMarker({
    required this.id,
    required this.name,
    required this.driverName,
    required this.position,
    required this.status,
    required this.color,
    this.speed = 0,
    this.fuelLevel = 100,
    required this.routePoints,
    this.currentRouteIndex = 0,
    this.targetStation,
  });
}

class TruckWaitingScreen extends StatefulWidget {
  const TruckWaitingScreen({super.key});

  @override
  State<TruckWaitingScreen> createState() => _TruckWaitingScreenState();
}

class _TruckWaitingScreenState extends State<TruckWaitingScreen>
    with SingleTickerProviderStateMixin {
  late Timer _timer;
  final osrm = Osrm();
  final List<TruckMarker> trucks = [];
  final Map<String, List<LatLng>> routePoints = {};
  final Map<String, num> routeDistances = {};
  late AnimationController _detailsController;
  StationsRecord? _selectedStation;

  @override
  void initState() {
    super.initState();
    _detailsController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _initializeTrucks();
  }

  @override
  void dispose() {
    _detailsController.dispose();
    _timer.cancel();
    super.dispose();
  }

  Future<void> _initializeTrucks() async {
    final stations = context
            .read<AuthProvider>()
            .currentUser
            ?.expand?['stations']
            ?.map((e) => StationsRecord.fromRecordModel(e))
            .toList() ??
        [];

    if (stations.isEmpty) return;

    // Define distinct starting points spread across the map
    final startingPositions = [
      const LatLng(36.509960, 2.859099), // North-East
      const LatLng(36.456811, 2.797543), // South-West
      const LatLng(36.483662, 2.885987), // East
    ];

    // Define specific station assignments for each truck
    final truckAssignments = [
      (
        start: startingPositions[0],
        name: 'Mohamed Amine',
        color: Colors.blue,
        stationIndex: 0
      ),
      (
        start: startingPositions[1],
        name: 'Yassine',
        color: Colors.green,
        stationIndex: stations.length > 1 ? 1 : 0
      ),
      (
        start: startingPositions[2],
        name: 'Abdelhamid',
        color: Colors.orange,
        stationIndex: stations.length > 2 ? 2 : 0
      ),
    ];

    for (int i = 0; i < truckAssignments.length; i++) {
      final assignment = truckAssignments[i];
      final targetStation = stations[assignment.stationIndex];
      final truckId = 'TRK-${i + 1}';

      // Get initial route
      final route = await _getRouteToStation(
        assignment.start,
        LatLng(targetStation.lat ?? 0, targetStation.lang ?? 0),
      );

      routePoints[truckId] = route.points;
      routeDistances[truckId] = route.distance;

      trucks.add(TruckMarker(
        id: truckId,
        name: assignment.name,
        driverName: 'Driver ${i + 1}',
        position: assignment.start,
        status: 'En Route',
        color: assignment.color,
        speed: 40 + (i * 10),
        fuelLevel: 100 - (i * 20),
        routePoints: route.points,
        targetStation: targetStation,
      ));
    }

    _startTruckAnimation();
  }

  Future<({List<LatLng> points, num distance})> _getRouteToStation(
      LatLng start, LatLng end) async {
    try {
      final options = RouteRequest(
        coordinates: [
          (start.longitude, start.latitude),
          (end.longitude, end.latitude),
        ],
        overview: OsrmOverview.full,
      );

      final route = await osrm.route(options);
      final points =
          route.routes.first.geometry!.lineString!.coordinates.map((e) {
        final location = e.toLocation();
        return LatLng(location.lat, location.lng);
      }).toList();

      return (
        points: points,
        distance: route.routes.first.distance ?? 0,
      );
    } catch (e) {
      print('Error getting route: $e');
      // Fallback to direct line if OSRM fails
      return (points: [start, end], distance: 0);
    }
  }

  void _startTruckAnimation() {
    _timer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      setState(() {
        for (var truck in trucks) {
          if (truck.currentRouteIndex < truck.routePoints.length - 1) {
            // Find the next few points to create smoother curves
            final currentPoint = truck.routePoints[truck.currentRouteIndex];
            final nextPoint = truck.routePoints[truck.currentRouteIndex + 1];

            // Calculate progress along route
            final progress = truck.currentRouteIndex / truck.routePoints.length;
            final remainingDistance =
                routeDistances[truck.id]! * (1 - progress);

            // Calculate distance to next point
            final distanceToNext =
                _calculateDistance(truck.position, nextPoint);

            if (_isCloseEnough(truck.position, nextPoint)) {
              truck.currentRouteIndex++;

              if (truck.currentRouteIndex >= truck.routePoints.length - 1) {
                _handleTruckArrival(truck);
                _assignNewDestination(truck);
              }
            } else {
              // Calculate movement vector
              final double step = 0.02; // Smaller step for smoother movement

              // Use Bezier curve interpolation for smoother movement
              final nextIndex = math.min(
                  truck.currentRouteIndex + 2, truck.routePoints.length - 1);
              final nextNextPoint = truck.routePoints[nextIndex];

              final interpolatedPoint = _bezierInterpolation(
                  truck.position, currentPoint, nextPoint, nextNextPoint, step);

              // Update truck position
              truck.position = interpolatedPoint;

              // Update speed based on remaining distance and current segment length
              final segmentLength = _calculateDistance(currentPoint, nextPoint);
              truck.speed = ((segmentLength / step) * 3.6).clamp(30, 90);
            }
          }
        }
      });
    });
  }

  void _handleTruckArrival(TruckMarker truck) {
    truck.status = 'Arrived';
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${truck.driverName} has arrived at ${truck.targetStation?.name ?? "station"}. Waiting for check-in...',
        ),
        backgroundColor: Colors.green,
      ),
    );
  }

  Future<void> _assignNewDestination(TruckMarker truck) async {
    final stations = context
            .read<AuthProvider>()
            .currentUser
            ?.expand?['stations']
            ?.map((e) => StationsRecord.fromRecordModel(e))
            .toList() ??
        [];

    if (stations.isEmpty) return;

    // Get currently targeted stations by other trucks
    final targetedStations = trucks
        .where((t) => t.id != truck.id)
        .map((t) => t.targetStation?.id)
        .toList();

    // Filter out stations that are currently targeted by other trucks
    final availableStations = stations
        .where((s) =>
            s.id != truck.targetStation?.id && !targetedStations.contains(s.id))
        .toList();

    // If no available stations, pick any station except current
    final newStation = availableStations.isNotEmpty
        ? availableStations[math.Random().nextInt(availableStations.length)]
        : stations
            .where((s) => s.id != truck.targetStation?.id)
            .toList()[math.Random().nextInt(stations.length - 1)];

    // Get new route
    final newRoute = await _getRouteToStation(
      truck.position,
      LatLng(newStation.lat ?? 0, newStation.lang ?? 0),
    );

    // Update truck with new destination
    truck.routePoints = newRoute.points;
    truck.currentRouteIndex = 0;
    truck.targetStation = newStation;
    truck.status = 'En Route';
  }

  double _lerp(double start, double end, double t) {
    return (end - start) * t;
  }

  double _calculateBearing(LatLng start, LatLng end) {
    final double lat1 = start.latitude * math.pi / 180;
    final double lat2 = end.latitude * math.pi / 180;
    final double dLon = (end.longitude - start.longitude) * math.pi / 180;

    final double y = math.sin(dLon) * math.cos(lat2);
    final double x = math.cos(lat1) * math.sin(lat2) -
        math.sin(lat1) * math.cos(lat2) * math.cos(dLon);

    return math.atan2(y, x) * 180 / math.pi;
  }

  bool _isCloseEnough(LatLng current, LatLng target) {
    final distance = _calculateDistance(current, target);
    return distance < 5; // 5 meters threshold
  }

  String getStationImageUrl(StationsRecord station) {
    if (station.avatar == null) return '';
    return '$API_URL/api/files/${StationsRecord.$collectionName}/${station.id}/${station.avatar}';
  }

  String _calculateETA(TruckMarker truck, StationsRecord station) {
    if (truck.targetStation?.id != station.id) return '';
    final remainingPoints = truck.routePoints.length - truck.currentRouteIndex;
    final progress = truck.currentRouteIndex / truck.routePoints.length;
    final remainingDistance = routeDistances[truck.id]! * (1 - progress);
    final timeInMinutes = (remainingDistance / truck.speed) * 3.6;
    return '${timeInMinutes.round()} min';
  }

  void _showStationDetails(StationsRecord station) {
    setState(() {
      if (_selectedStation?.id == station.id) {
        _selectedStation = null;
        _detailsController.reverse();
      } else {
        _selectedStation = station;
        _detailsController.forward();
      }
    });
  }

  Widget _buildStationDetailsCard() {
    if (_selectedStation == null) return const SizedBox.shrink();

    final incomingTrucks = trucks
        .where((truck) => truck.targetStation?.id == _selectedStation?.id)
        .toList();

    return AnimatedBuilder(
      animation: _detailsController,
      builder: (context, child) {
        return Positioned(
          top: 32 + (1 - _detailsController.value) * -200,
          right: 16,
          child: Material(
            elevation: 8,
            borderRadius: BorderRadius.circular(16),
            child: Container(
              width: 300,
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Station Header
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withOpacity(0.1),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color:
                                Theme.of(context).primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.warehouse,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _selectedStation?.name ?? 'Station',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                'Status: Active',
                                style: TextStyle(
                                  color: Colors.green.shade700,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            _selectedStation = null;
                            _detailsController.reverse();
                          },
                        ),
                      ],
                    ),
                  ),
                  // Incoming Trucks
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Incoming Trucks (${incomingTrucks.length})',
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ...incomingTrucks
                            .map((truck) => _buildTruckItem(truck)),
                        if (incomingTrucks.isEmpty)
                          const Center(
                            child: Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Text(
                                'No trucks en route',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTruckItem(TruckMarker truck) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: truck.color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: truck.color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.local_shipping, color: truck.color),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  truck.name,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                Text(
                  'Driver: ${truck.driverName}',
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'ETA',
                style: TextStyle(
                  color: truck.color,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                _calculateETA(truck, _selectedStation!),
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<AuthProvider>(builder: (context, provider, _) {
        final stations = provider.currentUser?.expand?['stations']
                ?.map((e) => StationsRecord.fromRecordModel(e))
                .toList() ??
            [];
        return Stack(
          children: [
            FlutterMap(
              options: MapOptions(
                initialCenter: trucks.isNotEmpty
                    ? trucks.first.position
                    : const LatLng(36.479960, 2.829099),
                initialZoom: 13,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  subdomains: const ['a', 'b', 'c'],
                ),
                // Draw routes
                PolylineLayer(
                  polylines: trucks.map((truck) {
                    return Polyline(
                      points: truck.routePoints,
                      color: truck.color,
                      strokeWidth: 5.0,
                      borderColor: truck.color.withOpacity(0.3),
                      borderStrokeWidth: 8.0,
                      gradientColors: [
                        truck.color.withOpacity(0.7),
                        truck.color,
                        truck.color.withOpacity(0.7),
                      ],
                    );
                  }).toList(),
                ),
                MarkerLayer(
                  markers: [
                    // Add distance markers with improved visibility
                    ...trucks.map((truck) {
                      final midPoint = truck.routePoints.isNotEmpty
                          ? truck.routePoints[math.max(
                              0, (truck.routePoints.length / 2).floor())]
                          : truck.position;

                      return Marker(
                        rotate: true,
                        width: 100.0,
                        height: 40.0,
                        point: midPoint,
                        child: Container(
                          decoration: BoxDecoration(
                            color: truck.color.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: truck.color.withOpacity(0.3),
                                spreadRadius: 2,
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                '${(routeDistances[truck.id] ?? 0).toStringAsFixed(1)} m',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                    // Truck markers with updated positions
                    ...trucks.map((truck) {
                      return Marker(
                        width: 150,
                        height: 90,
                        point: truck.position,
                        rotate: true, // Enable rotation
                        child: Transform.rotate(
                          angle: _calculateBearing(
                                truck.routePoints[
                                    math.max(0, truck.currentRouteIndex - 1)],
                                truck.position,
                              ) *
                              math.pi /
                              180,
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).cardColor,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Column(
                                  children: [
                                    Text(
                                      truck.name,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(Icons.circle,
                                            size: 8, color: truck.color),
                                        const SizedBox(width: 4),
                                        Text(
                                          truck.status,
                                          style: TextStyle(
                                            color: truck.color,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.speed,
                                          size: 12,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          '${truck.speed.toDouble()} km/h',
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                        const SizedBox(width: 8),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                width: 2,
                                height: 20,
                                color: truck.color,
                              ),
                              Container(
                                width: 16,
                                height: 16,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: truck.color.withOpacity(0.2),
                                  border:
                                      Border.all(color: truck.color, width: 3),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),

                    // Station markers
                    ...stations.map((station) {
                      return Marker(
                        width: 50,
                        height: 50,
                        point: LatLng(station.lat ?? 0, station.lang ?? 0),
                        child: InkWell(
                          onTap: () => _showStationDetails(station),
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: _selectedStation?.id == station.id
                                    ? Theme.of(context).primaryColor
                                    : Theme.of(context)
                                        .primaryColor
                                        .withOpacity(0.5),
                                width:
                                    _selectedStation?.id == station.id ? 3 : 2,
                              ),
                            ),
                            child: ClipOval(
                              child: station.avatar != null
                                  ? Image.network(
                                      getStationImageUrl(station),
                                      width: 50,
                                      height: 50,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return Container(
                                          color: Theme.of(context)
                                              .primaryColor
                                              .withOpacity(0.1),
                                          child: Icon(
                                            Icons.local_gas_station,
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                        );
                                      },
                                    )
                                  : Container(
                                      color: Theme.of(context)
                                          .primaryColor
                                          .withOpacity(0.1),
                                      child: Icon(
                                        Icons.local_gas_station,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                    ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ],
            ),

            // Station Cards List
            Positioned(
              bottom: 16,
              left: 0,
              right: 0,
              height: 215,
              child: Consumer<AuthProvider>(
                builder: (context, provider, _) {
                  final stations = provider.currentUser?.expand?['stations']
                          ?.map((e) => StationsRecord.fromRecordModel(e))
                          .toList() ??
                      [];

                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    itemCount: stations.length,
                    itemBuilder: (context, index) {
                      final station = stations[index];
                      return StationCard(station: station);
                    },
                  );
                },
              ),
            ),

            // Add the station details card
            _buildStationDetailsCard(),
          ],
        );
      }),
    );
  }
}

class StationCard extends StatelessWidget {
  final StationsRecord station;

  const StationCard({
    super.key,
    required this.station,
  });

  String getStationImageUrl() {
    if (station.avatar == null) return '';
    return '$API_URL/api/files/${StationsRecord.$collectionName}/${station.id}/${station.avatar}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Theme.of(context).colorScheme.surface.withOpacity(0.4)),
      width: 280,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with station name and icon
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Theme.of(context).primaryColor.withOpacity(0.1),
                  ),
                  child: station.avatar != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            getStationImageUrl(),
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(
                                Icons.local_gas_station,
                                color: Theme.of(context).primaryColor,
                              );
                            },
                          ),
                        )
                      : Icon(
                          Icons.local_gas_station,
                          color: Theme.of(context).primaryColor,
                        ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    station.name ?? 'Unknown Station',
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          // Station details
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDetailRow(
                  context,
                  Icons.location_on,
                  'Latitude',
                  station.lat?.toStringAsFixed(4) ?? 'N/A',
                ),
                const SizedBox(height: 8),
                _buildDetailRow(
                  context,
                  Icons.location_on,
                  'Longitude',
                  station.lang?.toStringAsFixed(4) ?? 'N/A',
                ),
                const SizedBox(height: 12),
                // Action button
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: () {
                      // TODO: Add navigation or details action
                    },
                    icon: const Icon(Icons.directions, size: 18),
                    label: const Text('Navigate'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(
      BuildContext context, IconData icon, String label, String value) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            size: 16,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                color: Theme.of(context).textTheme.bodySmall?.color,
                fontSize: 12,
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class TruckCard extends StatelessWidget {
  final Truck truck;

  const TruckCard({super.key, required this.truck});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      color:
          Theme.of(context).cardColor.withOpacity(0.7), // Make semi-transparent
      child: Container(
        width: 200,
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.local_shipping,
                  color: truck.isAvailable
                      ? Theme.of(context).colorScheme.primary
                      : Colors.grey,
                ),
                const SizedBox(width: 8),
                Text(
                  truck.id,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const Spacer(),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: truck.isAvailable
                        ? Colors.green.withOpacity(0.2)
                        : Colors.grey.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    truck.isAvailable ? 'Available' : 'Busy',
                    style: TextStyle(
                      color: truck.isAvailable ? Colors.green : Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(),
            Text('From: ${truck.origin}'),
            Text('To: ${truck.destination}'),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'ETA: ${truck.eta}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                Text(
                  '${truck.distance} km',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class Truck {
  final String id;
  final String origin;
  final String destination;
  final String eta;
  final double distance;
  final bool isAvailable;
  final LatLng position; // Add this field

  const Truck({
    required this.id,
    required this.origin,
    required this.destination,
    required this.eta,
    required this.distance,
    required this.position, // Add this parameter
    this.isAvailable = true,
  });
}

// Sample data
final List<Truck> availableTrucks = [
  Truck(
    id: 'TRK-001',
    origin: 'Algiers',
    destination: 'Oran',
    eta: '2h 30min',
    distance: 432,
    position: const LatLng(36.7525, 3.0420), // Algiers
  ),
  Truck(
    id: 'TRK-002',
    origin: 'Constantine',
    destination: 'Annaba',
    eta: '1h 45min',
    distance: 154,
    isAvailable: false,
    position: const LatLng(36.3650, 6.6147), // Constantine
  ),
  Truck(
    id: 'TRK-004',
    origin: 'Biskra',
    destination: 'Djelfa',
    eta: '4h 00min',
    distance: 543,
    position: const LatLng(34.8516, 5.7280), // Biskra
  ),
];

// Add these helper methods for better movement calculations
LatLng _bezierInterpolation(
    LatLng current, LatLng p1, LatLng p2, LatLng p3, double t) {
  // Quadratic Bezier curve interpolation
  final double u = 1 - t;
  final double tt = t * t;
  final double uu = u * u;

  final double lat =
      uu * current.latitude + 2 * u * t * p2.latitude + tt * p3.latitude;
  final double lng =
      uu * current.longitude + 2 * u * t * p2.longitude + tt * p3.longitude;

  return LatLng(lat, lng);
}

double _calculateDistance(LatLng point1, LatLng point2) {
  const double earthRadius = 6371000; // Earth's radius in meters
  final double lat1 = point1.latitude * math.pi / 180;
  final double lat2 = point2.latitude * math.pi / 180;
  final double dLat = (point2.latitude - point1.latitude) * math.pi / 180;
  final double dLon = (point2.longitude - point1.longitude) * math.pi / 180;

  final double a = math.sin(dLat / 2) * math.sin(dLat / 2) +
      math.cos(lat1) * math.cos(lat2) * math.sin(dLon / 2) * math.sin(dLon / 2);
  final double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));

  return earthRadius * c;
}
