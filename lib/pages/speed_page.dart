import 'package:flutter/material.dart';
import '../widgets/app_layout.dart';
import '../widgets/speedometer.dart';
import '../simulation_service.dart';

class SpeedPage extends StatefulWidget {
  const SpeedPage({super.key});

  @override
  State<SpeedPage> createState() => _SpeedPageState();
}

class _SpeedPageState extends State<SpeedPage> {
  final SimulationService _simulation = SimulationService();
  double speed = 0;

  @override
  void initState() {
    super.initState();
    _simulation.onData = (data) {
      if (mounted) setState(() => speed = data['speed']);
    };
    _simulation.start();
  }

  @override
  void dispose() {
    _simulation.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: Card(
            margin: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: Icon(Icons.speed),
                  title: Text('Vehicle Speed'),
                  trailing: Text(
                    speed > 120
                        ? 'DANGER'
                        : speed > 80
                            ? 'WARNING'
                            : 'SAFE',
                    style: TextStyle(
                      color: speed > 120
                          ? Colors.red
                          : speed > 80
                              ? Colors.orange
                              : Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Speedometer(
                  speed: speed,
                  maxSpeed: 180,
                  unit: 'km/h',
                ),
                SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
