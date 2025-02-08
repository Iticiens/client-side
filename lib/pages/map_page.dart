import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:iot/widgets/app_layout.dart';
import 'package:latlong2/latlong.dart';
import 'package:osrm/osrm.dart';

class FlutterMapOsrmExample extends StatefulWidget {
  const FlutterMapOsrmExample({
    super.key,
  });

  @override
  State<FlutterMapOsrmExample> createState() => _FlutterMapOsrmExampleState();
}

class _FlutterMapOsrmExampleState extends State<FlutterMapOsrmExample>
    with TickerProviderStateMixin {
  // Replace individual points with a list
  List<LatLng> waypoints = [
    const LatLng(36.479960, 2.829099),
    const LatLng(36.476811, 2.827543),
    const LatLng(36.473662, 2.825987),
  ];
  var points = <LatLng>[];

  // Add these new properties
  late AnimationController _animationController;
  LatLng? truckPosition;
  double truckRotation = 0.0;
  bool isAnimating = false;

  // Add this new property
  int selectedPointIndex = 0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    );

    _animationController.addListener(() {
      if (points.isNotEmpty) {
        // Calculate current position along the route
        final pointIndex =
            (_animationController.value * (points.length - 1)).floor();
        final nextIndex = min(pointIndex + 1, points.length - 1);

        // Interpolate between points
        final percent =
            (_animationController.value * (points.length - 1)) - pointIndex;
        final currentPoint = points[pointIndex];
        final nextPoint = points[nextIndex];

        // Calculate truck position
        truckPosition = LatLng(
          currentPoint.latitude +
              (nextPoint.latitude - currentPoint.latitude) * percent,
          currentPoint.longitude +
              (nextPoint.longitude - currentPoint.longitude) * percent,
        );

        // Calculate truck rotation
        if (nextPoint != currentPoint) {
          truckRotation = atan2(
                nextPoint.longitude - currentPoint.longitude,
                nextPoint.latitude - currentPoint.latitude,
              ) *
              (180 / pi);
        }

        // Check if arrived at a waypoint
        if (truckPosition == nextPoint && waypoints.contains(nextPoint)) {
          _animationController.stop();
          isAnimating = false;
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Arrived'),
              content: const Text('You have arrived at your destination.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _animationController.forward();
                    isAnimating = true;
                  },
                  child: const Text('Go Next'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Stay'),
                ),
              ],
            ),
          );
        }

        setState(() {});
      }
    });

    getRoute();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void startTrip() {
    if (points.isNotEmpty) {
      isAnimating = true;
      truckPosition = points.first;
      _animationController
        ..reset()
        ..forward();
      setState(() {});
    }
  }

  /// [distance] the distance between two coordinates [from] and [to]
  num distance = 0.0;

  /// [duration] the duration between two coordinates [from] and [to]
  num duration = 0.0;

  /// Calculate direct distance between two points
  double calculateDistance(LatLng point1, LatLng point2) {
    const double earthRadius = 6371000; // Earth's radius in meters
    final double lat1 = point1.latitude * pi / 180;
    final double lat2 = point2.latitude * pi / 180;
    final double lon1 = point1.longitude * pi / 180;
    final double lon2 = point2.longitude * pi / 180;

    final double dLat = lat2 - lat1;
    final double dLon = lon2 - lon1;

    final double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(lat1) * cos(lat2) * sin(dLon / 2) * sin(dLon / 2);
    final double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return earthRadius * c;
  }

  /// Modified optimal order function for multiple points
  List<LatLng> findOptimalOrder() {
    List<LatLng> bestOrder = List.from(waypoints);
    double shortestDistance = calculateTotalDistance(waypoints);

    // Try different permutations (using 2-opt algorithm for better performance)
    for (int i = 1; i < waypoints.length - 1; i++) {
      for (int j = i + 1; j < waypoints.length; j++) {
        List<LatLng> newOrder = List.from(bestOrder);
        // Reverse the segment between i and j
        for (int k = 0; k < (j - i + 1) ~/ 2; k++) {
          var temp = newOrder[i + k];
          newOrder[i + k] = newOrder[j - k];
          newOrder[j - k] = temp;
        }

        double newDistance = calculateTotalDistance(newOrder);
        if (newDistance < shortestDistance) {
          shortestDistance = newDistance;
          bestOrder = newOrder;
        }
      }
    }
    return bestOrder;
  }

  double calculateTotalDistance(List<LatLng> points) {
    double total = 0;
    for (int i = 0; i < points.length - 1; i++) {
      total += calculateDistance(points[i], points[i + 1]);
    }
    return total;
  }

  /// [getRoute] get the optimal route between three points
  Future<void> getRoute() async {
    final osrm = Osrm();
    final optimizedPoints = findOptimalOrder();

    final options = RouteRequest(
      coordinates: optimizedPoints
          .map((point) => (point.longitude, point.latitude))
          .toList(),
      overview: OsrmOverview.full,
    );

    final route = await osrm.route(options);
    distance = route.routes.first.distance!;
    duration = route.routes.first.duration!;
    points = route.routes.first.geometry!.lineString!.coordinates.map((e) {
      var location = e.toLocation();
      return LatLng(location.lat, location.lng);
    }).toList();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FlutterMap(
          options: MapOptions(
            onTap: (_, point) {
              waypoints[selectedPointIndex] = point;
              setState(() {});
              getRoute();
            },
            initialCenter: const LatLng(36.479960, 2.829099),
            initialZoom: 13.0,
          ),
          children: [
            TileLayer(
              urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
              subdomains: const ['a', 'b', 'c'],
            ),

            /// [PolylineLayer] draw the route between two coordinates [from] and [to]
            PolylineLayer(
              polylines: [
                Polyline(
                  points: points,
                  strokeWidth: 4.0,
                  color: Colors.red,
                ),
              ],
            ),

            /// [MarkerLayer] draw the marker on the map
            MarkerLayer(
              markers: [
                Marker(
                  width: 80.0,
                  height: 80.0,
                  point: waypoints[0],
                  child: const Icon(
                    Icons.circle,
                    color: Colors.blue,
                  ),
                ),
                Marker(
                  width: 80.0,
                  height: 80.0,
                  point: waypoints[1],
                  child: const Icon(
                    Icons.circle,
                    color: Colors.green,
                  ),
                ),
                Marker(
                  width: 80.0,
                  height: 80.0,
                  point: waypoints[2],
                  child: const Icon(
                    Icons.circle,
                    color: Colors.red,
                  ),
                ),

                /// in the middle of [points] list we draw the [Marker] shows the distance between [from] and [to]
                if (points.isNotEmpty)
                  Marker(
                    rotate: true,
                    width: 80.0,
                    height: 30.0,
                    point: points[max(0, (points.length / 2).floor())],
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            '${distance.toStringAsFixed(2)} m',
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                // Add truck marker if animating
                if (truckPosition != null && isAnimating)
                  Marker(
                    width: 50.0,
                    height: 50.0,
                    point: truckPosition!,
                    child: Transform.rotate(
                      angle: truckRotation * (pi / 180),
                      child: const Icon(
                        Icons.local_shipping,
                        color: Colors.blue,
                        size: 32,
                      ),
                    ),
                  ),
              ],
            ),

            // copy right text
          ],
        ),

        /// [Form] with two [TextFormField] to get the coordinates [from] and [to]
        Align(
          alignment: Alignment.topRight,
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            margin: const EdgeInsets.all(20),
            child: Container(
              width: 500,
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Add dropdown for selecting specific point
                  DropdownButton<int>(
                    value: selectedPointIndex,
                    items: List.generate(
                      waypoints.length,
                      (index) => DropdownMenuItem(
                        value: index,
                        child: Text('Point ${index + 1}'),
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        selectedPointIndex = value!;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  // Dynamic list of waypoint inputs
                  ...List.generate(
                    waypoints.length,
                    (index) => Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              initialValue: waypoints[index].toSexagesimal(),
                              onChanged: (value) {
                                waypoints[index] =
                                    LatLng.fromSexagesimal(value);
                                setState(() {});
                              },
                              decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.location_on),
                                prefix: Text('Point ${index + 1}: '),
                                border: const OutlineInputBorder().copyWith(
                                  borderSide:
                                      const BorderSide(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ),
                          if (waypoints.length > 2)
                            IconButton(
                              icon: const Icon(Icons.remove_circle_outline),
                              onPressed: () {
                                setState(() {
                                  waypoints.removeAt(index);
                                  getRoute();
                                });
                              },
                            ),
                        ],
                      ),
                    ),
                  ),

                  // Add waypoint button
                  FilledButton.icon(
                    icon: const Icon(Icons.add_location),
                    onPressed: () {
                      setState(() {
                        waypoints.add(
                            waypoints.last); // Add new point near the last one
                      });
                    },
                    label: const Text('Add Waypoint'),
                  ),

                  const SizedBox(height: 20),

                  Row(
                    children: [
                      FilledButton.icon(
                        icon: const Icon(Icons.directions),
                        onPressed: () {
                          getRoute();
                        },
                        label: const Text('Get Route'),
                      ),
                      const SizedBox(width: 20),
                      FilledButton.icon(
                        icon: const Icon(Icons.play_arrow),
                        onPressed: points.isEmpty ? null : startTrip,
                        label: const Text('Start Trip'),
                      ),
                      const SizedBox(width: 20),
                      // grey text display the duration between [from] and [to] and the distance
                      Center(
                        child: Text(
                          // km and hour
                          '| ${(duration / 60).toStringAsFixed(2)} h - ${(distance / 1000).toStringAsFixed(2)} km',
                          style: const TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
