import 'dart:async';
import 'dart:math';

class SimulationService {
  Timer? _timer;
  Function(Map<String, dynamic>)? onData;
  final Random _random = Random();
  double _speed = 0.0;
  double _distance = 100.0;
  double _temperature = 25.0;
  double _humidity = 50.0;

  void start() {
    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      // Simulate realistic data changes
      _speed = _simulateValue(_speed, 0, 180, 5);
      _distance = _simulateValue(_distance, 0, 200, 2);
      _temperature = _simulateValue(_temperature, 15, 35, 0.5);
      _humidity = _simulateValue(_humidity, 30, 70, 1);

      final data = {
        'time': DateTime.now().millisecondsSinceEpoch,
        'ap_ip': '192.168.4.1',
        'ap_status': 'active',
        'wifi_ip': '192.168.1.6',
        'wifi_status': 'active',
        'wifi_ssid': 'DJAWEB_IOT',
        'readRate': 100,
        'notifyRate': 100,
        'flaged': 0,
        'benchmark': _random.nextInt(500),
        'distance': _distance,
        'tankHeight': 200.0,
        'realDistance': _distance,
        'averageDistance': _distance,
        'temperature': _temperature,
        'fahrenheit': (_temperature * 9 / 5) + 32,
        'humidity': _humidity,
        'heatindexC': _calculateHeatIndex(_temperature, _humidity),
        'heatindexF':
            (_calculateHeatIndex(_temperature, _humidity) * 9 / 5) + 32,
        'speed': _speed,
      };

      onData?.call(data);
    });
  }

  double _simulateValue(
      double current, double min, double max, double maxChange) {
    double change = (_random.nextDouble() * 2 - 1) * maxChange;
    return (current + change).clamp(min, max);
  }

  double _calculateHeatIndex(double temp, double humidity) {
    // Simplified heat index calculation
    return temp + (0.555 * (humidity - 50));
  }

  void stop() {
    _timer?.cancel();
    _timer = null;
  }
}
