import 'dart:math' as math;
import 'package:flutter/material.dart';

class Speedometer extends StatefulWidget {
  final double speed;
  final double maxSpeed;
  final String unit;

  const Speedometer(
      {super.key,
      required this.speed,
      this.maxSpeed = 180,
      this.unit = 'km/h'});

  @override
  State<Speedometer> createState() => _SpeedometerState();
}

class _SpeedometerState extends State<Speedometer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _speedAnimation;
  double _lastSpeed = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _speedAnimation = Tween<double>(
      begin: widget.speed,
      end: widget.speed,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));
    _lastSpeed = widget.speed;
  }

  @override
  void didUpdateWidget(Speedometer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.speed != _lastSpeed) {
      _speedAnimation = Tween<double>(
        begin: _lastSpeed,
        end: widget.speed,
      ).animate(CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutCubic,
      ));
      _controller.forward(from: 0);
      _lastSpeed = widget.speed;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _speedAnimation,
      builder: (context, child) {
        return CustomPaint(
          painter: _SpeedometerPainter(
            speed: _speedAnimation.value,
            maxSpeed: widget.maxSpeed,
            context: context,
          ),
          child: SizedBox(
            height: 180,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _speedAnimation.value.toStringAsFixed(1),
                    style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: _speedAnimation.value > 120
                              ? Colors.red
                              : _speedAnimation.value > 80
                                  ? Colors.orange
                                  : null,
                        ),
                  ),
                  Text(
                    widget.unit,
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withOpacity(0.5),
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
}

class _SpeedometerPainter extends CustomPainter {
  final double speed;
  final double maxSpeed;
  final BuildContext context;

  _SpeedometerPainter({
    required this.speed,
    required this.maxSpeed,
    required this.context,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2;

    // Draw background arc
    final bgPaint = Paint()
      ..color = Theme.of(context).colorScheme.surfaceVariant
      ..style = PaintingStyle.stroke
      ..strokeWidth = 20
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - 20),
      math.pi * 0.8,
      math.pi * 1.4,
      false,
      bgPaint,
    );

    // Draw speed arc with color transitions
    final speedPaint = Paint()
      ..shader = LinearGradient(
        colors: [
          speed <= 80 ? Theme.of(context).colorScheme.primary : Colors.orange,
          speed > 120
              ? Colors.red
              : (speed > 80
                  ? Colors.orange
                  : Theme.of(context).colorScheme.secondary),
        ],
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 20
      ..strokeCap = StrokeCap.round;

    final speedAngle = (speed / maxSpeed) * math.pi * 1.4;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - 20),
      math.pi * 0.8,
      speedAngle,
      false,
      speedPaint,
    );

    // Draw speed zones indicators
    final dangerZoneStart = (120 / maxSpeed) * math.pi * 1.4;
    final warningZoneStart = (80 / maxSpeed) * math.pi * 1.4;

    // Draw ticks with colors
    for (var i = 0; i <= 10; i++) {
      final angle = math.pi * 0.8 + (math.pi * 1.4 * i / 10);
      final tickLength = i % 2 == 0 ? 15.0 : 10.0;

      final x1 = center.dx + (radius - 30) * math.cos(angle);
      final y1 = center.dy + (radius - 30) * math.sin(angle);
      final x2 = center.dx + (radius - 30 - tickLength) * math.cos(angle);
      final y2 = center.dy + (radius - 30 - tickLength) * math.sin(angle);

      final progress = i / 10;
      final tickColor = progress > 120 / maxSpeed
          ? Colors.red.withOpacity(0.5)
          : progress > 80 / maxSpeed
              ? Colors.orange.withOpacity(0.5)
              : Theme.of(context).colorScheme.onSurface.withOpacity(0.5);

      canvas.drawLine(
          Offset(x1, y1),
          Offset(x2, y2),
          Paint()
            ..color = tickColor
            ..strokeWidth = 2);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
