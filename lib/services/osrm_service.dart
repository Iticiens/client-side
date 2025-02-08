import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OSRMService {
  static Future<List<LatLng>> getRoutePoints(LatLng start, LatLng end) async {
    try {
      final response = await http.get(Uri.parse(
          'https://router.project-osrm.org/route/v1/driving/${start.longitude},${start.latitude};${end.longitude},${end.latitude}?steps=true&geometries=geojson&overview=full'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['routes'].isNotEmpty) {
          final coordinates =
              data['routes'][0]['geometry']['coordinates'] as List;
          return coordinates
              .map((coord) => LatLng(coord[1] as double, coord[0] as double))
              .toList();
        }
      }
    } catch (e) {
      print('OSRM error: $e');
    }
    // Fallback to direct line if route fails
    return [start, end];
  }

  static Future<double> getRouteDistance(List<LatLng> route) async {
    double distance = 0;
    for (int i = 0; i < route.length - 1; i++) {
      distance +=
          const Distance().as(LengthUnit.Kilometer, route[i], route[i + 1]);
    }
    return distance;
  }

  Future<RouteInfo> getRouteInfo(LatLng start, LatLng end) async {
    // Return dummy data for demo
    return RouteInfo(
      distance: 1000,
      duration: 600,
    );
  }
}

class RouteInfo {
  final double distance;
  final double duration;

  RouteInfo({
    required this.distance,
    required this.duration,
  });
}
