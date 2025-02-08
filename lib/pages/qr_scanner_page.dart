import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'dart:math';

class QrScannerPage extends StatefulWidget {
  const QrScannerPage({super.key});

  @override
  State<QrScannerPage> createState() => _QrScannerPageState();
}

class _QrScannerPageState extends State<QrScannerPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  bool _isScanning = false;
  final MobileScannerController _scannerController = MobileScannerController();
  final List<String> truckDrivers = [
    'Mohamed Amine',
    'Yassine',
    'Abdelhamid',
    'Ahmed',
    'Omar',
    'Karim',
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    )..repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _scannerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        colorScheme: Theme.of(context).colorScheme.copyWith(
              surface: Colors.black,
              onSurface: Colors.white,
            ),
      ),
      child: Scaffold(
        body: Stack(
          children: [
            MobileScanner(
              controller: _scannerController,
              onDetect: (capture) {
                final List<Barcode> barcodes = capture.barcodes;
                for (final barcode in barcodes) {
                  _handleQrCode(barcode.rawValue ?? '');
                }
              },
            ),
            // Gradient overlay
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.8),
                      Colors.transparent,
                      Colors.transparent,
                      Colors.black.withOpacity(0.8),
                    ],
                  ),
                ),
              ),
            ),
            // Scanner overlay
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: SizedBox(
                  height: 300,
                  width: 300,
                  child: Stack(
                    children: [
                      // Animated scanner line
                      AnimatedBuilder(
                        animation: _animationController,
                        builder: (context, child) {
                          return Positioned(
                            top: _animationController.value * 300,
                            left: 0,
                            right: 0,
                            height: 2,
                            child: Container(
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primary
                                        .withOpacity(0.5),
                                    blurRadius: 10,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.transparent,
                                      Theme.of(context).colorScheme.primary,
                                      Colors.transparent,
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      // Corner decorations
                      ...List.generate(4, (index) {
                        final isTop = index < 2;
                        final isLeft = index.isEven;
                        return Positioned(
                          top: isTop ? 0 : null,
                          bottom: !isTop ? 0 : null,
                          left: isLeft ? 0 : null,
                          right: !isLeft ? 0 : null,
                          child: Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              border: Border(
                                left: BorderSide(
                                  color: isLeft
                                      ? Theme.of(context).colorScheme.primary
                                      : Colors.transparent,
                                  width: 4,
                                ),
                                top: BorderSide(
                                  color: isTop
                                      ? Theme.of(context).colorScheme.primary
                                      : Colors.transparent,
                                  width: 4,
                                ),
                                right: BorderSide(
                                  color: !isLeft
                                      ? Theme.of(context).colorScheme.primary
                                      : Colors.transparent,
                                  width: 4,
                                ),
                                bottom: BorderSide(
                                  color: !isTop
                                      ? Theme.of(context).colorScheme.primary
                                      : Colors.transparent,
                                  width: 4,
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),
            ),
            // Top bar
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: SafeArea(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back),
                        color: Colors.white,
                        onPressed: () => Navigator.pop(context),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.flash_on),
                            color: Colors.white,
                            onPressed: () => _scannerController.toggleTorch(),
                          ),
                          IconButton(
                            icon: const Icon(Icons.flip_camera_android),
                            color: Colors.white,
                            onPressed: () => _scannerController.switchCamera(),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Bottom instructions
            Positioned(
              bottom: 60,
              left: 24,
              right: 24,
              child: Column(
                children: [
                  Text(
                    'Scan QR Code',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(color: Colors.white),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Place the QR code within the frame to scan',
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: Colors.white.withOpacity(0.7)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleQrCode(String value) {
    if (!_isScanning) {
      _isScanning = true;
      showCongratulationsDialog(context, value);
    }
  }

  void showCongratulationsDialog(BuildContext context, String qrCode) {
    final random = Random();
    final driverName = truckDrivers[random.nextInt(truckDrivers.length)];

    showGeneralDialog(
      context: context,
      pageBuilder: (_, __, ___) => Container(),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: Curves.easeInOut,
        );

        return ScaleTransition(
          scale: Tween<double>(begin: 0.5, end: 1.0).animate(curvedAnimation),
          child: AlertDialog(
            backgroundColor: Theme.of(context).colorScheme.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            content: Container(
              width: 300,
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Success Icon with animation
                  Icon(
                    Icons.check_circle_outline,
                    color: Theme.of(context).colorScheme.primary,
                    size: 80,
                  )
                      .animate(onPlay: (controller) => controller.repeat())
                      .scale(
                        duration: 800.ms,
                        curve: Curves.easeInOut,
                        begin: const Offset(0.8, 0.8),
                        end: const Offset(1.1, 1.1),
                      )
                      .then()
                      .scale(
                        duration: 800.ms,
                        curve: Curves.easeInOut,
                        begin: const Offset(1.1, 1.1),
                        end: const Offset(0.8, 0.8),
                      ),

                  const SizedBox(height: 20),

                  // Congratulations text
                  Text(
                    'Congratulations!',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                  ).animate().slideY(
                        begin: 0.3,
                        duration: 500.ms,
                        curve: Curves.easeOut,
                      ),

                  const SizedBox(height: 12),

                  // Driver name
                  Text(
                    'Truck driven by $driverName',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium,
                  ).animate().fadeIn(
                        delay: 200.ms,
                        duration: 500.ms,
                      ),

                  const SizedBox(height: 8),

                  // Status text
                  Text(
                    'Checked and waiting for validation',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                  ).animate().fadeIn(
                        delay: 400.ms,
                        duration: 500.ms,
                      ),

                  const SizedBox(height: 20),

                  // QR Code info
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .primaryContainer
                          .withOpacity(0.3),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'QR Code: $qrCode',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ).animate().slideX(
                        begin: 0.3,
                        delay: 600.ms,
                        duration: 500.ms,
                        curve: Curves.easeOut,
                      ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  'Close',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ).animate().fadeIn(delay: 800.ms),
            ],
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 400),
    );
  }
}
