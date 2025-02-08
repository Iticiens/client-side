import 'dart:async';
import 'package:latlong2/latlong.dart';

class TruckSimulator {
  Timer? _timer;
  LatLng _currentPosition;
  final double _speedKmH; // km/h
  List<LatLng> _route = [];
  int _currentRouteIndex = 0;
  final Function(LatLng)? onPositionUpdate;
  final Function()? onDestinationReached;
  final Function(double)? onSpeedUpdate;

  TruckSimulator({
    required LatLng initialPosition,
    required this.onPositionUpdate,
    this.onDestinationReached,
    this.onSpeedUpdate,
    double speedKmH = 60.0,
  })  : _currentPosition = initialPosition,
        _speedKmH = speedKmH;

  void setRoute(List<LatLng> route) {
    _route = route;
    _currentRouteIndex = 0;
    _currentPosition = route.first;
  }

  void start() {
    if (_route.isEmpty) return;

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(milliseconds: 100), (_) {
      if (_currentRouteIndex >= _route.length - 1) {
        stop();
        onDestinationReached?.call();
        return;
      }

      // Calculate next position
      final next = _route[_currentRouteIndex + 1];
      final distance =
          const Distance().as(LengthUnit.Kilometer, _currentPosition, next);

      // Convert km/h to km/100ms
      final step = (_speedKmH / 36000); // km per 100ms

      // Calculate current speed based on route segment
      final currentSpeed =
          _speedKmH * (distance / 0.1); // Adjust speed based on segment length
      onSpeedUpdate?.call(currentSpeed);

      if (distance < step) {
        _currentRouteIndex++;
        _currentPosition = next;
      } else {
        // Interpolate position
        final ratio = step / distance;
        _currentPosition = LatLng(
          _currentPosition.latitude +
              (next.latitude - _currentPosition.latitude) * ratio,
          _currentPosition.longitude +
              (next.longitude - _currentPosition.longitude) * ratio,
        );
      }

      onPositionUpdate?.call(_currentPosition);
    });
  }

  void stop() {
    _timer?.cancel();
  }

  void dispose() {
    stop();
  }

  LatLng get currentPosition => _currentPosition;
}
