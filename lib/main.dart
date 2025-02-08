import 'dart:async';
import 'dart:math' as math;
import 'dart:math' show Random, pi, cos, sin;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
// google fonts
import 'package:google_fonts/google_fonts.dart';
import 'package:iot/chatbot.dart';
import 'package:iot/core/theme/app_theme.dart';
import 'package:iot/pages/map_page.dart';
import 'package:iot/pages/settings_page.dart';
import 'package:iot/pages/speed_page.dart';
import 'package:iot/providers/auth_provider.dart';
import 'package:iot/providers/trips_provider.dart';
import 'package:iot/providers/trucks_provider.dart';
import 'package:iot/repository/trips_repository.dart';
import 'package:iot/repository/trucks_repository.dart';
import 'package:iot/simulation_service.dart';
import 'package:iot/widgets/app_layout.dart';
import 'package:motif/motif.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:timeago/timeago.dart' as timeago;
// http
import 'package:http/http.dart' as http;
import 'dart:convert';
// web socket
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:iot/widgets/speedometer.dart';
import 'package:iot/pages/about_page.dart'; // Add this import
import 'package:iot/core/navigation/routes.dart';
import 'package:provider/provider.dart';
import 'package:iot/core/providers/auth_provider.dart';
import 'package:iot/repository/auth_repository.dart';
import 'package:iot/pages/login_page.dart';

var songs = [
  "The Simpsons:d=4,o=5,b=160:c.6,e6,f#6,8a6,g.6,e6,c6,8a,8f#,8f#,8f#,2g,8p,8p,8f#,8f#,8f#,8g,a#.,8c6,8c6,8c6,c6",
  "Indiana:d=4,o=5,b=250:e,8p,8f,8g,8p,1c6,8p.,d,8p,8e,1f,p.,g,8p,8a,8b,8p,1f6,p,a,8p,8b,2c6,2d6,2e6,e,8p,8f,8g,8p,1c6,p,d6,8p,8e6,1f.6,g,8p,8g,e.6,8p,d6,8p,8g,e.6,8p,d6,8p,8g,f.6,8p,e6,8p,8d6,2c6",
  "TakeOnMe:d=4,o=4,b=160:8f#5,8f#5,8f#5,8d5,8p,8b,8p,8e5,8p,8e5,8p,8e5,8g#5,8g#5,8a5,8b5,8a5,8a5,8a5,8e5,8p,8d5,8p,8f#5,8p,8f#5,8p,8f#5,8e5,8e5,8f#5,8e5,8f#5,8f#5,8f#5,8d5,8p,8b,8p,8e5,8p,8e5,8p,8e5,8g#5,8g#5,8a5,8b5,8a5,8a5,8a5,8e5,8p,8d5,8p,8f#5,8p,8f#5,8p,8f#5,8e5,8e5",
  "Entertainer:d=4,o=5,b=140:8d,8d#,8e,c6,8e,c6,8e,2c.6,8c6,8d6,8d#6,8e6,8c6,8d6,e6,8b,d6,2c6,p,8d,8d#,8e,c6,8e,c6,8e,2c.6,8p,8a,8g,8f#,8a,8c6,e6,8d6,8c6,8a,2d6",
  "Muppets:d=4,o=5,b=250:c6,c6,a,b,8a,b,g,p,c6,c6,a,8b,8a,8p,g.,p,e,e,g,f,8e,f,8c6,8c,8d,e,8e,8e,8p,8e,g,2p,c6,c6,a,b,8a,b,g,p,c6,c6,a,8b,a,g.,p,e,e,g,f,8e,f,8c6,8c,8d,e,8e,d,8d,c",
  "Xfiles:d=4,o=5,b=125:e,b,a,b,d6,2b.,1p,e,b,a,b,e6,2b.,1p,g6,f#6,e6,d6,e6,2b.,1p,g6,f#6,e6,d6,f#6,2b.,1p,e,b,a,b,d6,2b.,1p,e,b,a,b,e6,2b.,1p,e6,2b.",
  "Looney:d=4,o=5,b=140:32p,c6,8f6,8e6,8d6,8c6,a.,8c6,8f6,8e6,8d6,8d#6,e.6,8e6,8e6,8c6,8d6,8c6,8e6,8c6,8d6,8a,8c6,8g,8a#,8a,8f",
  "20thCenFox:d=16,o=5,b=140:b,8p,b,b,2b,p,c6,32p,b,32p,c6,32p,b,32p,c6,32p,b,8p,b,b,b,32p,b,32p,b,32p,b,32p,b,32p,b,32p,b,32p,g#,32p,a,32p,b,8p,b,b,2b,4p,8e,8g#,8b,1c#6,8f#,8a,8c#6,1e6,8a,8c#6,8e6,1e6,8b,8g#,8a,2b",
  "Bond:d=4,o=5,b=80:32p,16c#6,32d#6,32d#6,16d#6,8d#6,16c#6,16c#6,16c#6,16c#6,32e6,32e6,16e6,8e6,16d#6,16d#6,16d#6,16c#6,32d#6,32d#6,16d#6,8d#6,16c#6,16c#6,16c#6,16c#6,32e6,32e6,16e6,8e6,16d#6,16d6,16c#6,16c#7,c.7,16g#6,16f#6,g#.6",
  "MASH:d=8,o=5,b=140:4a,4g,f#,g,p,f#,p,g,p,f#,p,2e.,p,f#,e,4f#,e,f#,p,e,p,4d.,p,f#,4e,d,e,p,d,p,e,p,d,p,2c#.,p,d,c#,4d,c#,d,p,e,p,4f#,p,a,p,4b,a,b,p,a,p,b,p,2a.,p,a,b,a,4b,a,b,p,2a.,a,4f#,a,b,p,d6,p,4e.6,d6,b,p,a,p,2b",
  "StarWars:d=4,o=5,b=45:32p,32f#,32f#,32f#,8b.,8f#.6,32e6,32d#6,32c#6,8b.6,16f#.6,32e6,32d#6,32c#6,8b.6,16f#.6,32e6,32d#6,32c#6,8b.6,16f#.6,32e6,32d#6,32c#6,8b.6,16f#.6,32e6,32d#6,32e6,8c#.6,32f#,32f#,32f#,8b.,8f#.6,32e6,32d#6,32c#6,8b.6,16f#.6,32e6,32d#6,32c#6,8b.6,16f#.6,32e6,32d#6,32e6,8c#6",
  "GoodBad:d=4,o=5,b=56:32p,32a#,32d#6,32a#,32d#6,8a#.,16f#.,16g#.,d#,32a#,32d#6,32a#,32d#6,8a#.,16f#.,16g#.,c#6,32a#,32d#6,32a#,32d#6,8a#.,16f#.,32f.,32d#.,c#,32a#,32d#6,32a#,32d#6,8a#.,16g#.,d#",
  "TopGun:d=4,o=4,b=31:32p,16c#,16g#,16g#,32f#,32f,32f#,32f,16d#,16d#,32c#,32d#,16f,32d#,32f,16f#,32f,32c#,16f,d#,16c#,16g#,16g#,32f#,32f,32f#,32f,16d#,16d#,32c#,32d#,16f,32d#,32f,16f#,32f,32c#,g#",
  "A-Team:d=8,o=5,b=125:4d#6,a#,2d#6,16p,g#,4a#,4d#.,p,16g,16a#,d#6,a#,f6,2d#6,16p,c#.6,16c6,16a#,g#.,2a#",
  "Flinstones:d=4,o=5,b=40:32p,16f6,16a#,16a#6,32g6,16f6,16a#.,16f6,32d#6,32d6,32d6,32d#6,32f6,16a#,16c6,d6,16f6,16a#.,16a#6,32g6,16f6,16a#.,32f6,32f6,32d#6,32d6,32d6,32d#6,32f6,16a#,16c6,a#,16a6,16d.6,16a#6,32a6,32a6,32g6,32f#6,32a6,8g6,16g6,16c.6,32a6,32a6,32g6,32g6,32f6,32e6,32g6,8f6,16f6,16a#.,16a#6,32g6,16f6,16a#.,16f6,32d#6,32d6,32d6,32d#6,32f6,16a#,16c.6,32d6,32d#6,32f6,16a#,16c.6,32d6,32d#6,32f6,16a#6,16c7,8a#.6",
  "Jeopardy:d=4,o=6,b=125:c,f,c,f5,c,f,2c,c,f,c,f,a.,8g,8f,8e,8d,8c#,c,f,c,f5,c,f,2c,f.,8d,c,a#5,a5,g5,f5,p,d#,g#,d#,g#5,d#,g#,2d#,d#,g#,d#,g#,c.7,8a#,8g#,8g,8f,8e,d#,g#,d#,g#5,d#,g#,2d#,g#.,8f,d#,c#,c,p,a#5,p,g#.5,d#,g#",
  "Gadget:d=16,o=5,b=50:32d#,32f,32f#,32g#,a#,f#,a,f,g#,f#,32d#,32f,32f#,32g#,a#,d#6,4d6,32d#,32f,32f#,32g#,a#,f#,a,f,g#,f#,8d#",
  "Smurfs:d=32,o=5,b=200:4c#6,16p,4f#6,p,16c#6,p,8d#6,p,8b,p,4g#,16p,4c#6,p,16a#,p,8f#,p,8a#,p,4g#,4p,g#,p,a#,p,b,p,c6,p,4c#6,16p,4f#6,p,16c#6,p,8d#6,p,8b,p,4g#,16p,4c#6,p,16a#,p,8b,p,8f,p,4f#",
  "MahnaMahna:d=16,o=6,b=125:c#,c.,b5,8a#.5,8f.,4g#,a#,g.,4d#,8p,c#,c.,b5,8a#.5,8f.,g#.,8a#.,4g,8p,c#,c.,b5,8a#.5,8f.,4g#,f,g.,8d#.,f,g.,8d#.,f,8g,8d#.,f,8g,d#,8c,a#5,8d#.,8d#.,4d#,8d#.",
  "LeisureSuit:d=16,o=6,b=56:f.5,f#.5,g.5,g#5,32a#5,f5,g#.5,a#.5,32f5,g#5,32a#5,g#5,8c#.,a#5,32c#,a5,a#.5,c#.,32a5,a#5,32c#,d#,8e,c#.,f.,f.,f.,f.,f,32e,d#,8d,a#.5,e,32f,e,32f,c#,d#.,c#",
  "MissionImp:d=16,o=6,b=95:32d,32d#,32d,32d#,32d,32d#,32d,32d#,32d,32d,32d#,32e,32f,32f#,32g,g,8p,g,8p,a#,p,c7,p,g,8p,g,8p,f,p,f#,p,g,8p,g,8p,a#,p,c7,p,g,8p,g,8p,f,p,f#,p,a#,g,2d,32p,a#,g,2c#,32p,a#,g,2c,a#5,8c,2p,32p,a#5,g5,2f#,32p,a#5,g5,2f,32p,a#5,g5,2e,d#,8d",
  "smbdeath:d=4,o=5,b=90:32c6,32c6,32c6,8p,16b,16f6,16p,16f6,16f.6,16e.6,16d6,16c6,16p,16e,16p,16c",
  "Monty P:d=4,o=5,b=200:f6,8e6,d6,8c#6,c6,8b,a#,8a,8g,8a,8a#,a,8g,2c6,8p,8c6,8a,8p,8a,8a,8g#,8a,8f6,8p,8c6,8c6,8p,8a,8a#,8p,8a#,8a#,8p,8c6,2d6,8p,8a#,8g,8p,8g,8g,8f#,8g,8e6,8p,8d6,8d6,8p,8a#,8a,8p,8a,8a,8p,8a#,2c6,8p,8c6",
  "Yaketysax:d=4,o=5,b=125:8d.,16e,8g,8g,16e,16d,16a4,16b4,16d,16b4,8e,16d,16b4,16a4,16b4,8a4,16a4,16a#4,16b4,16d,16e,16d,g,p,16d,16e,16d,8g,8g,16e,16d,16a4,16b4,16d,16b4,8e,16d,16b4,16a4,16b4,8d,16d,16d,16f#,16a,8f,d,p,16d,16e,16d,8g,16g,16g,8g,16g,16g,8g,8g,16e,8e.,8c,8c,8c,8c,16e,16g,16a,16g,16a#,8g,16a,16b,16a#,16b,16a,16b,8d6,16a,16b,16d6,8b,8g,8d,16e6,16b,16b,16d,8a,8g,g;",
  "YMCA:d=4,o=5,b=160:8c#6,8a#,2p,8a#,8g#,8f#,8g#,8a#,c#6,8a#,c#6,8d#6,8a#,2p,8a#,8g#,8f#,8g#,8a#,c#6,8a#,c#6,8d#6,8b,2p,8b,8a#,8g#,8a#,8b,d#6,8f#6,d#6,f.6,d#.6,c#.6,b.,a#,g#",
  "BarbieGirl:d=4,o=5,b=125:8g#,8e,8g#,8c#6,a,p,8f#,8d#,8f#,8b,g#,8f#,8e,p,8e,8c#,f#,c#,p,8f#,8e,g#,f#",
  "TakeOnMe:d=4,o=4,b=160:8f#5,8f#5,8f#5,8d5,8p,8b,8p,8e5,8p,8e5,8p,8e5,8g#5,8g#5,8a5,8b5,8a5,8a5,8a5,8e5,8p,8d5,8p,8f#5,8p,8f#5,8p,8f#5,8e5,8e5,8f#5,8e5,8f#5,8f#5,8f#5,8d5,8p,8b,8p,8e5,8p,8e5,8p,8e5,8g#5,8g#5,8a5,8b5,8a5,8a5,8a5,8e5,8p,8d5,8p,8f#5,8p,8f#5,8p,8f#5,8e5,8e5",
];

final pb = PocketBase("http://127.0.0.1:8090/");

DateTime appStartAt = DateTime.now();

ValueNotifier<ThemeMode> themeMode = ValueNotifier(ThemeMode.system);
ValueNotifier<Color> themeColor = ValueNotifier(Colors.teal);

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => AuthProvider(AuthRepositoryImpl())),
      ChangeNotifierProvider(
          create: (_) => TrucksProvider(TrucksRepositoryImpl())),
      ChangeNotifierProvider(
          create: (_) => TripsProvider(TripsRepositoryImpl())),
    ],
    child: const App(),
  ));
}

class App extends StatelessWidget {
  const App({super.key});
  @override
  Widget build(BuildContext context) {
    // Set initial theme color to gold
    themeColor.value = Colors.amber;

    return ListenableBuilder(
      listenable: Listenable.merge([themeMode, themeColor]),
      builder: (context, snapshot) {
        return MaterialApp(
          title: 'IOT',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light(themeColor.value),
          darkTheme: AppTheme.dark(themeColor.value),
          themeMode: themeMode.value,
          home: Stack(
            children: [
              const Positioned.fill(
                child: AnimatedBackground(),
              ),
              Consumer<AuthProvider>(
                builder: (context, auth, _) {
                  if (!auth.isAuthenticated) {
                    return const LoginPage();
                  }
                  return AppLayout(
                    child: AppRoute.home.screen,
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

enum ConnectionStatus {
  connected(Colors.green),
  disconnected(Colors.red),
  connecting(Colors.orange),
  failed(Colors.red);

  const ConnectionStatus(this.color);
  final Color color;

  static ConnectionStatus fromString(String value) {
    switch (value) {
      case 'connected':
        return ConnectionStatus.connected;
      case 'disconnected':
        return ConnectionStatus.disconnected;
      case 'connecting':
        return ConnectionStatus.connecting;
      case 'failed':
        return ConnectionStatus.failed;
      default:
        return ConnectionStatus.failed;
    }
  }
}

enum ConnectionType {
  wifi(Icons.wifi_rounded, Icons.wifi_off_rounded),
  ap(Icons.wifi_tethering_rounded, Icons.wifi_tethering_off_rounded);

  const ConnectionType(this.connectedIcon, this.disconnectedIcon);
  final IconData connectedIcon;
  final IconData disconnectedIcon;
}

class AnimatedStar {
  double x;
  double y;
  double size;
  double opacity;
  double speed;
  double angle;

  AnimatedStar({
    required this.x,
    required this.y,
    required this.size,
    required this.opacity,
    required this.speed,
    required this.angle,
  });
}

class SimpleLightPainter extends CustomPainter {
  final double time;
  final bool isDarkTheme;

  SimpleLightPainter({
    required this.time,
    required this.isDarkTheme,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (isDarkTheme) {
      _paintDarkTheme(canvas, size);
    } else {
      _paintLightTheme(canvas, size);
    }
  }

  void _paintLightTheme(Canvas canvas, Size size) {
    // Simple gradient background
    final backgroundPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.amber.shade50,
          Colors.white.withOpacity(0.9),
        ],
      ).createShader(Offset.zero & size);

    canvas.drawRect(Offset.zero & size, backgroundPaint);

    // Single moving light beam
    final beamPosition = size.width * (0.2 + 0.6 * cos(time * 0.2));
    final beamPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.amber.shade200.withOpacity(0.2),
          // Colors.transparent,
        ],
      ).createShader(Rect.fromLTWH(
        beamPosition - 200,
        0,
        400,
        size.height,
      ));

    canvas.drawRect(
      Rect.fromLTWH(beamPosition - 200, 0, 400, size.height),
      beamPaint..maskFilter = const MaskFilter.blur(BlurStyle.normal, 80),
    );
  }

  void _paintDarkTheme(Canvas canvas, Size size) {
    // Simple gradient background

    // Single moving light beam
    final beamPosition = size.width * (0.2 + 0.6 * cos(time * 0.2));
    final beamPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.blue.shade200.withOpacity(0.1),
          // Colors.transparent,
        ],
      ).createShader(Rect.fromLTWH(
        beamPosition - 200,
        0,
        400,
        size.height,
      ));

    canvas.drawRect(
      Rect.fromLTWH(beamPosition - 200, 0, 400, size.height),
      beamPaint..maskFilter = const MaskFilter.blur(BlurStyle.normal, 80),
    );
  }

  @override
  bool shouldRepaint(SimpleLightPainter oldDelegate) => true;
}

class AnimatedBackground extends StatefulWidget {
  const AnimatedBackground({super.key});

  @override
  State<AnimatedBackground> createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 30),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: SimpleLightPainter(
            time: _controller.value * 2 * pi,
            isDarkTheme: isDark,
          ),
        );
      },
    );
  }
}

class _HomeState extends State<Home> {
  // last try
  DateTime? lastRetry;
  ConnectionType connectionType = ConnectionType.wifi;
  ConnectionStatus wifiConnectionStatus = ConnectionStatus.disconnected;
  ConnectionStatus apConnectionStatus = ConnectionStatus.disconnected;
  ConnectionStatus get currentConnectionStatus {
    if (connectionType == ConnectionType.wifi) {
      return wifiConnectionStatus;
    } else if (connectionType == ConnectionType.ap) {
      return apConnectionStatus;
    }
    return ConnectionStatus.disconnected;
  }

  String get currentHost {
    if (connectionType == ConnectionType.wifi) {
      return wifi_ip;
    }
    return ap_ip;
  }

  String get displayValue {
    switch (displayValueKey) {
      case "temperature":
        return "${temperature.toStringAsFixed(2)} °C";
      case "fahrenheit":
        return "${fahrenheit.toStringAsFixed(2)} °C";
      case "humidity":
        return "${humidity.toStringAsFixed(2)} %";
      case "heatindexC":
        return "${heatindexC.toStringAsFixed(2)} °C";
      case "heatindexF":
        return "${heatindexF.toStringAsFixed(2)} °C";
      case "tankHeight-distance":
        return "${(tankHeight - distance).toStringAsFixed(2)}";
      case "remains":
        return "${((tankHeight - distance) / (tankHeight / 100)).toStringAsFixed(2)}%";
      default:
        return "${distance.toStringAsFixed(2)} cm";
    }
  }

  List<String> displayValueKeys = const [
    "temperature",
    "fahrenheit",
    "humidity",
    "heatindexC",
    "heatindexF",
    "distance",
    "tankHeight-distance",
    "remains",
  ];

  num time = 0;
  String displayValueKey = "temperature";
  String ap_ip = "192.168.4.1";
  String ap_status = "active";
  String wifi_ip = "192.168.1.6";
  String wifiStatus = "active";
  String wifiSSID = "DJAWEB_IOT";
  num readRate = 100;
  num notifyRate = 100;
  num flaged = 0;
  num temperature = 0;
  num distance = 0;
  num benchmark = 0;
  num averageDistance = 0;
  num realDistance = 0;
  num tankHeight = 0;
  num fahrenheit = 0;
  num humidity = 0;
  num heatindexC = 0;
  num heatindexF = 0;
  late List<num> temperatures = [];
  late List<num> humidities = [];
  late List<num> distances = [];
  TextEditingController chatController = TextEditingController();
  double speed = 0;

  List<Map<String, String>> messages = [];
  Map<String, dynamic> arduinoData = {};

  WebSocketChannel? channel;
  StreamSubscription? subscription;

  // Add simulation service
  final SimulationService _simulation = SimulationService();

  @override
  void initState() {
    super.initState();
    _simulation.onData = (data) {
      if (!mounted) return;

      setState(() {
        arduinoData = data;
        time = data['time'] ?? 0;
        ap_ip = data['ap_ip'] ?? "192.168.4.1";
        ap_status = data['ap_status'] ?? "active";
        wifi_ip = data['wifi_ip'] ?? "192.168.1.6";
        wifiStatus = data['wifi_status'] ?? "active";
        wifiSSID = data['wifi_ssid'] ?? "DJAWEB_IOT";
        readRate = data['readRate'] ?? 100;
        notifyRate = data['notifyRate'] ?? 100;
        flaged = data['flaged'] ?? 0;
        benchmark = data['benchmark'] ?? 0;
        distance = data['distance']?.toDouble() ?? 0.0;
        tankHeight = data['tankHeight']?.toDouble() ?? 200.0;
        realDistance = data['realDistance']?.toDouble() ?? 0.0;
        averageDistance = data['averageDistance']?.toDouble() ?? 0.0;
        temperature = data['temperature']?.toDouble() ?? 0.0;
        fahrenheit = data['fahrenheit']?.toDouble() ?? 0.0;
        humidity = data['humidity']?.toDouble() ?? 0.0;
        heatindexC = data['heatindexC']?.toDouble() ?? 0.0;
        heatindexF = data['heatindexF']?.toDouble() ?? 0.0;
        speed = data['speed']?.toDouble() ?? 0.0;

        temperatures.add(temperature);
        humidities.add(humidity);
        distances.add(distance);

        if (distances.length > 50) distances.removeAt(0);
        if (temperatures.length > 50) temperatures.removeAt(0);
        if (humidities.length > 50) humidities.removeAt(0);
      });
    };
    _simulation.start();
  }

  @override
  void dispose() {
    _simulation.stop();
    super.dispose();
  }

  // Replace initWebSocket with simulation toggle
  void initWebSocket(ConnectionType connectionType) {
    this.connectionType = connectionType;
    if (connectionType == ConnectionType.wifi) {
      wifiConnectionStatus = ConnectionStatus.connected;
      apConnectionStatus = ConnectionStatus.disconnected;
    } else {
      wifiConnectionStatus = ConnectionStatus.disconnected;
      apConnectionStatus = ConnectionStatus.connected;
    }
    setState(() {});
  }

  num parseUnsignedInt(dynamic value, num defaultValue) {
    var parsed = num.tryParse(value.toString()) ?? 0;
    return parsed > 0 ? parsed.toInt() : defaultValue;
  }

  void disconnect() {
    channel?.sink.close();
    wifiConnectionStatus = ConnectionStatus.disconnected;
    apConnectionStatus = ConnectionStatus.disconnected;
    setState(() {});
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.maybeOf(context)?.showSnackBar(
      SnackBar(
          behavior: SnackBarBehavior.floating,
          width: 400.0,
          content: const Text('Disconnected'),
          action: SnackBarAction(
            label: 'recconect',
            onPressed: () {
              initWebSocket(connectionType);
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            },
          )),
    );
  }

  Future<void> updateDisplayValueKey(String value) async {
    final response = await http.post(
      Uri.parse('http://$currentHost/api?displayValueKey=$value'),
    );
    if (response.statusCode == 200) {
      setState(() {
        displayValueKey = value;
      });
    }
  }

  Future<void> updateTankHeight(num value) async {
    final response = await http.post(
      Uri.parse('http://$currentHost/api?tankHeight=$value'),
    );
    if (response.statusCode == 200) {
      setState(() {
        tankHeight = value;
      });
    }
  }

  Future<void> updateReadRate(num value) async {
    final response = await http.post(
      Uri.parse('http://$currentHost/api?readRate=$value'),
    );
    if (response.statusCode == 200) {
      setState(() {
        readRate = value;
      });
    }
  }

  // notifyRate
  Future<void> updateNotifyRate(num value) async {
    final response = await http.post(
      Uri.parse('http://$currentHost/api?notifyRate=$value'),
    );
    if (response.statusCode == 200) {
      setState(() {
        notifyRate = value;
      });
    }
  }

  Future<void> updateFlaged(num value) async {
    try {
      final response = await http.post(
        Uri.parse('http://$currentHost/api?flaged=$value'),
      );
      if (response.statusCode == 200) {
        setState(() {
          flaged = value;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> updateWifi(
      {required String ssid, required String password}) async {
    try {
      final response = await http.post(
        Uri.parse(
            'http://$currentHost/api?wifi_ssid=$ssid&wifi_password=$password'),
      );
    } catch (e) {
      print(e);
    }
  }

  Future<void> updateAP(
      {required String ssid, required String password}) async {
    try {
      final response = await http.post(
        Uri.parse(
            'http://$currentHost/api?ap_ssid=$ssid&ap_password=$password'),
      );
    } catch (e) {
      print(e);
    }
  }

  Future<void> restart() async {
    try {
      final response = await http.post(
        Uri.parse('http://$currentHost/api?restart=1'),
      );
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background with blur
          const Positioned.fill(
            child: AnimatedBackground(),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
            child: Container(),
          ),

          // Your existing content
          SingleChildScrollView(
            child: Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 600),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: AppBar(
                        leading: IconButton(
                          icon: const Icon(Icons.color_lens),
                          onPressed: () async {
                            await showPreferencesDailog(context);
                          },
                        ),
                        backgroundColor: Colors.transparent,
                        centerTitle: false,
                        title: Image.asset(
                          "assets/images/LOGIC_3.png",
                          width: 150,
                          height: 100,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        actions: [
                          IconButton(
                            icon: const Icon(Icons.report_problem_rounded),
                            onPressed: () async {
                              // showDialog(
                              //   context: context,
                              //   builder: (context) {
                              //     return AlertDialog(
                              //       title: const Text('Restart'),
                              //       content: const Text(
                              //           'Are you sure you want to restart the device?'),
                              //       actions: [
                              //         TextButton(
                              //           onPressed: () {
                              //             Navigator.pop(context);
                              //           },
                              //           child: const Text('Cancel'),
                              //         ),
                              //         TextButton.icon(
                              //           icon: const Icon(Icons.done_all),
                              //           onPressed: () {
                              //             restart();
                              //             Navigator.pop(context);
                              //           },
                              //           label: const Text('Restart'),
                              //         ),
                              //       ],
                              //     );
                              //   },
                              // );

                              // Add this method in your _HomeState class
                              showGeneralDialog(
                                context: context,
                                pageBuilder:
                                    (context, animation, secondaryAnimation) {
                                  return Container(); // Placeholder, won't be used
                                },
                                transitionBuilder: (context, animation,
                                    secondaryAnimation, child) {
                                  final curvedAnimation = CurvedAnimation(
                                    parent: animation,
                                    curve: Curves.easeInOut,
                                  );

                                  return ScaleTransition(
                                    scale: Tween<double>(begin: 0.8, end: 1.0)
                                        .animate(curvedAnimation),
                                    child: FadeTransition(
                                      opacity: curvedAnimation,
                                      child: AlertDialog(
                                        backgroundColor: Theme.of(context)
                                            .colorScheme
                                            .errorContainer,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        title: Row(
                                          children: [
                                            Icon(
                                              Icons.warning_amber_rounded,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .error,
                                              size: 28,
                                            )
                                                .animate(
                                                    onPlay: (controller) =>
                                                        controller.repeat())
                                                .shake(duration: 1000.ms),
                                            const SizedBox(width: 8),
                                            Text(
                                              'Report Problem',
                                              style: TextStyle(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onErrorContainer,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                        content: Container(
                                          constraints: const BoxConstraints(
                                              maxWidth: 400),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              TextField(
                                                maxLines: 1,
                                                decoration: InputDecoration(
                                                  filled: true,
                                                  fillColor: Theme.of(context)
                                                      .colorScheme
                                                      .surface,
                                                  hintText: 'Title',
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                    borderSide: BorderSide.none,
                                                  ),
                                                  prefixIcon:
                                                      const Icon(Icons.title),
                                                ),
                                              ).animate().slideX(
                                                    begin: -0.2,
                                                    duration: 400.ms,
                                                    curve: Curves.easeOut,
                                                  ),
                                              const SizedBox(height: 16),
                                              TextField(
                                                maxLines: 4,
                                                decoration: InputDecoration(
                                                  filled: true,
                                                  fillColor: Theme.of(context)
                                                      .colorScheme
                                                      .surface,
                                                  hintText:
                                                      'Describe what happened...',
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                    borderSide: BorderSide.none,
                                                  ),
                                                ),
                                              ).animate().slideX(
                                                    begin: 0.2,
                                                    duration: 400.ms,
                                                    delay: 200.ms,
                                                    curve: Curves.easeOut,
                                                  ),
                                              const SizedBox(height: 16),
                                              Row(
                                                children: [
                                                  Icon(
                                                    Icons.info_outline,
                                                    size: 16,
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .onErrorContainer
                                                        .withOpacity(0.7),
                                                  ),
                                                  const SizedBox(width: 8),
                                                  Expanded(
                                                    child: Text(
                                                      'Your report will help us improve the system',
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .onErrorContainer
                                                            .withOpacity(0.7),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ).animate().fadeIn(delay: 400.ms),
                                            ],
                                          ),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context),
                                            child: Text(
                                              'Cancel',
                                              style: TextStyle(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onErrorContainer,
                                              ),
                                            ),
                                          ),
                                          FilledButton.icon(
                                            onPressed: () {
                                              // Handle report submission here
                                              Navigator.pop(context);
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  content: const Text(
                                                      'Report submitted successfully'),
                                                  behavior:
                                                      SnackBarBehavior.floating,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                ),
                                              );
                                            },
                                            style: FilledButton.styleFrom(
                                              backgroundColor: Theme.of(context)
                                                  .colorScheme
                                                  .error,
                                              foregroundColor: Theme.of(context)
                                                  .colorScheme
                                                  .onError,
                                            ),
                                            icon: const Icon(Icons.send),
                                            label: const Text('Submit Report'),
                                          ).animate().slideY(
                                                begin: 0.5,
                                                duration: 400.ms,
                                                delay: 200.ms,
                                                curve: Curves.easeOut,
                                              ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                                transitionDuration:
                                    const Duration(milliseconds: 400),
                              );

// Update the IconButton in your build method
                              // IconButton(
                              //   icon: const Icon(Icons.report_problem_rounded),
                              //   onPressed: _showDangerReportDialog,
                              // );
                            },
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: SizedBox(
                        height: 180,
                        child: Row(
                          children: [
                            Expanded(
                              child: Card(
                                margin: const EdgeInsets.all(0),
                                color: Theme.of(context)
                                    .colorScheme
                                    .surface
                                    .withOpacity(0.5),
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  side: BorderSide(
                                    color: Colors.grey.withOpacity(0.5),
                                    width: 1,
                                  ),
                                ),
                                clipBehavior: Clip.antiAlias,
                                child: Stack(
                                  children: [
                                    Positioned.fill(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Container(
                                            height: 1,
                                            decoration: BoxDecoration(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primary,
                                                gradient: LinearGradient(
                                                  colors: [
                                                    Colors.blue
                                                        .withOpacity(0.5),
                                                    Colors.blue,
                                                    Colors.blue,
                                                    Colors.blue
                                                        .withOpacity(0.5),
                                                  ],
                                                  begin: Alignment.centerLeft,
                                                  end: Alignment.centerRight,
                                                  // stops: const [0.1, 0.2, 0],
                                                )),
                                          ),
                                          AnimatedContainer(
                                            duration: const Duration(
                                                milliseconds: 300),
                                            height: 180 *
                                                math.max(
                                                    0,
                                                    (tankHeight <= 0
                                                        ? 0
                                                        : ((tankHeight -
                                                                averageDistance) /
                                                            tankHeight))),
                                            decoration: BoxDecoration(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primary,
                                                gradient: LinearGradient(
                                                  colors: [
                                                    Colors.blueAccent
                                                        .withOpacity(0.5),
                                                    Colors.blue.withOpacity(0),
                                                  ],
                                                  begin: Alignment.topCenter,
                                                  end: Alignment.bottomCenter,
                                                  // stops: const [0.1, 0.2, 0],
                                                )),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Positioned.fill(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Container(
                                            height: 1,
                                            decoration: BoxDecoration(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primary,
                                                gradient: LinearGradient(
                                                  colors: [
                                                    Colors.green
                                                        .withOpacity(0.5),
                                                    Colors.blue,
                                                    Colors.blue,
                                                    Colors.green
                                                        .withOpacity(0.5),
                                                  ],
                                                  begin: Alignment.centerLeft,
                                                  end: Alignment.centerRight,
                                                  // stops: const [0.1, 0.2, 0],
                                                )),
                                          ),
                                          AnimatedContainer(
                                            duration: const Duration(
                                                milliseconds: 300),
                                            height: 180 *
                                                math.max(
                                                    0,
                                                    (tankHeight <= 0
                                                        ? 0
                                                        : ((tankHeight -
                                                                distance) /
                                                            tankHeight))),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const SizedBox(height: 24),
                                        Text(
                                          tankHeight > 0
                                              ? "${(tankHeight - averageDistance) * 100 ~/ tankHeight}%"
                                              : "--%",
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineMedium!
                                              .copyWith(
                                                  fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(height: 12),
                                        const Row(
                                          children: [],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Column(
                                              children: [
                                                const Icon(
                                                    Icons.leak_add_rounded),
                                                Text(
                                                    '${distance.toStringAsFixed(2)}KG'),
                                              ],
                                            ),
                                            const SizedBox(
                                                height: 30,
                                                child: VerticalDivider()),
                                            Column(
                                              children: [
                                                const Icon(
                                                    Icons.join_full_outlined),
                                                Text(
                                                    '${tankHeight.toStringAsFixed(2)}KG'),
                                              ],
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 24),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              flex: 2,
                              child: Card(
                                margin: const EdgeInsets.all(0),
                                color: Theme.of(context)
                                    .colorScheme
                                    .surface
                                    .withOpacity(0.5),
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  side: BorderSide(
                                    color: Colors.grey.withOpacity(0.5),
                                    width: 1,
                                  ),
                                ),
                                clipBehavior: Clip.antiAlias,
                                child: Stack(
                                  children: [
                                    Positioned(
                                      left: 0,
                                      right: 0,
                                      bottom: 0,
                                      height: 74,
                                      child: CustomPaint(
                                        painter: _GriedentGraphPainter(
                                          temperatures: distances,
                                          context: context,
                                        ),
                                      ),
                                    ),
                                    MenuAnchor(
                                      menuChildren: [
                                        for (var key in displayValueKeys)
                                          ListTile(
                                            title: Text(key),
                                            onTap: () {
                                              updateDisplayValueKey(key);
                                            },
                                          ),
                                      ],
                                      builder: (context, controller, _) {
                                        return GestureDetector(
                                          onTap: () {
                                            if (controller.isOpen) {
                                              controller.close();
                                            } else {
                                              controller.open();
                                            }
                                          },
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              const SizedBox(height: 24),
                                              Text(
                                                displayValue.trim(),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headlineMedium!
                                                    .copyWith(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                              ),
                                              const SizedBox(width: 8),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  // connection status
                                                  Container(
                                                    width: 30,
                                                    height: 20,
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 8,
                                                        vertical: 4),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                      color:
                                                          currentConnectionStatus
                                                              .color
                                                              .withOpacity(0.2),
                                                    ),
                                                    child: Center(
                                                      child: Icon(
                                                        currentConnectionStatus ==
                                                                ConnectionStatus
                                                                    .connected
                                                            ? connectionType
                                                                .connectedIcon
                                                            : connectionType
                                                                .disconnectedIcon,
                                                        color:
                                                            currentConnectionStatus
                                                                .color,
                                                        size: 12,
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 8),
                                                  // if (lastRetry != null)
                                                  //   Text("retry in "+(lastRetry!.difference(DateTime.now()).abs().inSeconds.toString())+"...")
                                                  //   else
                                                  Text(timeago
                                                      .format(appStartAt)),
                                                ],
                                              ),
                                              const SizedBox(height: 12),
                                              const Row(
                                                children: [],
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Column(
                                                    children: [
                                                      const Icon(Icons
                                                          .device_thermostat_rounded),
                                                      Text(
                                                          '${temperature.toStringAsFixed(2)} °C'),
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                      height: 30,
                                                      child: VerticalDivider()),
                                                  Column(
                                                    children: [
                                                      const Icon(
                                                          Icons.water_rounded),
                                                      Text(
                                                          '${humidity.toStringAsFixed(2)} %'),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 24),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 16),

                    ListTile(
                      leading: Icon(Icons.data_saver_off_rounded),
                      title: Text('Data from device'),
                      // benchmark is ping Response/ms (red if > 500, green less 150)
                      trailing: Text(
                        '${benchmark.toInt()}ms',
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                              color:
                                  benchmark > 500 ? Colors.red : Colors.green,
                            ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Card(
                        margin: const EdgeInsets.all(0),
                        color: Theme.of(context)
                            .colorScheme
                            .surface
                            .withOpacity(0.7),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(
                            color: Colors.grey.withOpacity(0.5),
                            width: 1,
                          ),
                        ),
                        child: Column(
                          children: [
                            ListTile(
                              onLongPress: () async {
                                var ip = await showUpdateIpDailog(context,
                                    ip: wifi_ip);
                                if (ip != null) {
                                  wifi_ip = ip;
                                  initWebSocket(ConnectionType.wifi);
                                }
                              },
                              onTap: () {
                                if (currentConnectionStatus ==
                                    ConnectionStatus.connected) {
                                  disconnect();
                                  if (connectionType == ConnectionType.ap) {
                                    initWebSocket(ConnectionType.wifi);
                                  }
                                } else {
                                  initWebSocket(ConnectionType.wifi);
                                }
                              },
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              minVerticalPadding: 0,
                              leading: wifiConnectionStatus ==
                                      ConnectionStatus.connecting
                                  ? const CircularProgressIndicator.adaptive()
                                  : Icon(
                                      wifiConnectionStatus ==
                                              ConnectionStatus.connected
                                          ? ConnectionType.wifi.connectedIcon
                                          : ConnectionType
                                              .wifi.disconnectedIcon,
                                      color: wifiConnectionStatus.color),
                              title: Row(
                                children: [
                                  const Text('Wifi IP'),
                                  const SizedBox(width: 8),
                                  buildConnect(wifiConnectionStatus),
                                ],
                              ),
                              subtitle: Row(
                                children: [
                                  Text(wifi_ip),
                                  const SizedBox(width: 8),
                                  Text("$wifiSSID | $wifiStatus",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall!
                                          .copyWith(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onBackground
                                                  .withOpacity(0.5),
                                              fontSize: 10)),
                                ],
                              ),
                              trailing: IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () async {
                                  var data = await showWifiUpdateDailog(context,
                                      ssid: wifiSSID, password: "iotiotiot");
                                  if (data != null) {
                                    updateWifi(
                                      ssid: data.ssid,
                                      password: data.password,
                                    );
                                  }
                                },
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(
                                  left: kMinInteractiveDimension),
                              child: Divider(
                                height: 1,
                              ),
                            ),
                            // ListTile(
                            //   onLongPress: () async {
                            //     var ip = await showUpdateIpDailog(context,
                            //         ip: ap_ip);
                            //     if (ip != null) {
                            //       ap_ip = ip;
                            //       initWebSocket(ConnectionType.ap);
                            //     }
                            //   },
                            //   onTap: () {
                            //     if (currentConnectionStatus ==
                            //         ConnectionStatus.connected) {
                            //       disconnect();
                            //       if (connectionType == ConnectionType.wifi) {
                            //         initWebSocket(ConnectionType.ap);
                            //       }
                            //     } else {
                            //       initWebSocket(ConnectionType.ap);
                            //     }
                            //   },
                            //   contentPadding:
                            //       const EdgeInsets.symmetric(horizontal: 16),
                            //   minVerticalPadding: 0,
                            //   leading: apConnectionStatus ==
                            //           ConnectionStatus.connecting
                            //       ? const CircularProgressIndicator.adaptive()
                            //       : Icon(
                            //           apConnectionStatus ==
                            //                   ConnectionStatus.connected
                            //               ? ConnectionType.ap.connectedIcon
                            //               : ConnectionType.ap.disconnectedIcon,
                            //           color: apConnectionStatus.color),
                            //   title: Row(
                            //     children: [
                            //       const Text('AP IP'),
                            //       const SizedBox(width: 8),
                            //       buildConnect(apConnectionStatus),
                            //       const SizedBox(width: 8),
                            //       Text(ap_status,
                            //           style: Theme.of(context)
                            //               .textTheme
                            //               .bodySmall!
                            //               .copyWith(
                            //                   color: Theme.of(context)
                            //                       .colorScheme
                            //                       .onBackground
                            //                       .withOpacity(0.5),
                            //                   fontSize: 10)),
                            //     ],
                            //   ),
                            //   subtitle: Text(ap_ip),
                            //   trailing: IconButton(
                            //     icon: const Icon(Icons.edit),
                            //     onPressed: () async {
                            //       var data = await showWifiUpdateDailog(context,
                            //           ssid: "IOT_AP", password: "iotiotiot");
                            //       if (data != null) {
                            //         updateAP(
                            //           ssid: data.ssid,
                            //           password: data.password,
                            //         );
                            //       }
                            //     },
                            //   ),
                            // ),
                            const Padding(
                              padding: EdgeInsets.only(
                                  left: kMinInteractiveDimension),
                              child: Divider(
                                height: 1,
                              ),
                            ),
                            // ListTile(
                            //   onTap: () {
                            //     updateFlaged(flaged == 1 ? 0 : 1);
                            //   },
                            //   contentPadding:
                            //       const EdgeInsets.symmetric(horizontal: 16),
                            //   minVerticalPadding: 0,
                            //   leading: Icon(
                            //     flaged == 1
                            //         ? Icons.lightbulb_sharp
                            //         : Icons.lightbulb_outline_rounded,
                            //     color: flaged == 1 ? Colors.amber : null,
                            //   ),
                            //   title: const Text('Flaged'),
                            //   subtitle: Text(flaged == 1 ? 'Yes' : 'No'),
                            //   trailing: Switch(
                            //     value: flaged == 1,
                            //     onChanged: (value) {
                            //       updateFlaged(value ? 1 : 0);
                            //     },
                            //     thumbIcon: MaterialStateProperty.all(
                            //       Icon(
                            //         flaged == 1
                            //             ? Icons.light_mode_rounded
                            //             : Icons.light_mode,
                            //       ),
                            //     ),
                            //   ),
                            // ),

                            const Padding(
                              padding: EdgeInsets.only(
                                  left: kMinInteractiveDimension),
                              child: Divider(
                                height: 1,
                              ),
                            ),
                            ListTile(
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              minVerticalPadding: 0,
                              leading: const Icon(Icons.line_weight),
                              title: const Text('Weight'),
                              subtitle: Text(
                                  '${distance.toStringAsFixed(2)} cm / max ${tankHeight}%'),
                              // dialog to update it
                              trailing: IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () async {
                                  var data = await showDialog(
                                      context: context,
                                      builder: (context) {
                                        var value = TextEditingController(
                                            text: tankHeight.toString());
                                        return AlertDialog(
                                          title: const Text('Update Distance'),
                                          content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              TextFormField(
                                                controller: value,
                                                decoration:
                                                    const InputDecoration(
                                                  isDense: true,
                                                  labelText: 'Tank Height',
                                                  border: OutlineInputBorder(),
                                                  prefixIcon:
                                                      Icon(Icons.water_rounded),
                                                ),
                                                keyboardType:
                                                    TextInputType.number,
                                                validator: (value) {
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    return 'Please enter tank height';
                                                  }
                                                  return null;
                                                },
                                              ),
                                            ],
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: const Text('Cancel'),
                                            ),
                                            TextButton.icon(
                                              icon: const Icon(Icons.done_all),
                                              onPressed: () {
                                                if (num.parse(value.text) > 0) {
                                                  Navigator.pop(context,
                                                      num.parse(value.text));
                                                }
                                              },
                                              label: const Text('Update'),
                                            ),
                                          ],
                                        );
                                      });
                                  if (data != null) {
                                    updateTankHeight(data);
                                  }
                                },
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(
                                  left: kMinInteractiveDimension),
                              child: Divider(
                                height: 1,
                              ),
                            ),
                            ListTile(
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              minVerticalPadding: 0,
                              leading: const Icon(Icons.thermostat_rounded),
                              title: const Text('Temperature'),
                              subtitle: Text(
                                  '${temperature.toStringAsFixed(2)} °C / ${fahrenheit.toStringAsFixed(2)} °F'),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(
                                  left: kMinInteractiveDimension),
                              child: Divider(
                                height: 1,
                              ),
                            ),
                            ListTile(
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              minVerticalPadding: 0,
                              leading: const Icon(Icons.water_rounded),
                              title: const Text('Humidity'),
                              subtitle:
                                  Text('${humidity.toStringAsFixed(2)} %'),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(
                                  left: kMinInteractiveDimension),
                              child: Divider(
                                height: 1,
                              ),
                            ),
                            ListTile(
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              minVerticalPadding: 0,
                              leading: const Icon(Icons.thermostat_rounded),
                              title: const Text('Heat Index'),
                              subtitle: Text(
                                  '${heatindexC.toStringAsFixed(2)} °C / ${heatindexF.toStringAsFixed(2)} °F'),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(
                                  left: kMinInteractiveDimension),
                              child: Divider(
                                height: 1,
                              ),
                            ),

                            SizedBox(
                              height: 10,
                            ),
                            // L
                            // istTile(
                            //   contentPadding:
                            //       const EdgeInsets.symmetric(horizontal: 16),
                            //   minVerticalPadding: 0,
                            //   leading: const Icon(Icons.file_present_outlined),
                            //   title: const Text('Read Docs'),
                            //   subtitle: Text('all info about the project'),
                            //   onTap: () {
                            //     Navigator.of(context).push(
                            //       MaterialPageRoute<void>(
                            //         builder: (BuildContext context) =>
                            //             const AboutPage(),
                            //       ),
                            //     );
                            //   },
                            // ),
                          ],
                        ),
                      ),
                    ),

                    // advanced
                    // const ListTile(
                    //   leading: Icon(Icons.settings),
                    //   title: Text('Advanced'),
                    // ),

                    // Padding(
                    //   padding: const EdgeInsets.symmetric(horizontal: 16),
                    //   child: Card(
                    //     margin: const EdgeInsets.all(0),
                    //     color: Theme.of(context)
                    //         .colorScheme
                    //         .surface
                    //         .withOpacity(0.7),
                    //     elevation: 0,
                    //     shape: RoundedRectangleBorder(
                    //       borderRadius: BorderRadius.circular(12),
                    //       side: BorderSide(
                    //         color: Colors.grey.withOpacity(0.5),
                    //         width: 1,
                    //       ),
                    //     ),
                    //     child: Column(children: [
                    //       ListTile(
                    //         contentPadding:
                    //             const EdgeInsets.symmetric(horizontal: 16),
                    //         minVerticalPadding: 0,
                    //         leading: const Icon(Icons.wifi_protected_setup),
                    //         title: const Text('Read Rate'),
                    //         subtitle: Text('$readRate ms'),
                    //         // two icon buttons + - in range 0 - 2000
                    //         trailing: Row(
                    //           mainAxisSize: MainAxisSize.min,
                    //           children: [
                    //             IconButton(
                    //               icon: const Icon(Icons.remove_rounded),
                    //               onPressed: readRate > 0
                    //                   ? () => updateReadRate(
                    //                       math.max(0, readRate - 25))
                    //                   : null,
                    //             ),
                    //             IconButton(
                    //               icon: const Icon(Icons.add_rounded),
                    //               onPressed: () =>
                    //                   updateReadRate(readRate + 25),
                    //             ),
                    //           ],
                    //         ),
                    //       ),
                    //       const Padding(
                    //         padding:
                    //             EdgeInsets.only(left: kMinInteractiveDimension),
                    //         child: Divider(
                    //           height: 1,
                    //         ),
                    //       ),
                    //       ListTile(
                    //         contentPadding:
                    //             const EdgeInsets.symmetric(horizontal: 16),
                    //         minVerticalPadding: 0,
                    //         leading: const Icon(Icons.rotate_90_degrees_ccw),
                    //         title: const Text('Notify Rate'),
                    //         subtitle: Text('$notifyRate ms'),
                    //         // two icon buttons + - in range 0 - 2000
                    //         trailing: Row(
                    //           mainAxisSize: MainAxisSize.min,
                    //           children: [
                    //             IconButton(
                    //               icon: const Icon(Icons.remove_rounded),
                    //               onPressed: notifyRate > 0
                    //                   ? () => updateNotifyRate(
                    //                       math.max(0, notifyRate - 25))
                    //                   : null,
                    //             ),
                    //             IconButton(
                    //               icon: const Icon(Icons.add_rounded),
                    //               onPressed: () =>
                    //                   updateNotifyRate(notifyRate + 25),
                    //             ),
                    //           ],
                    //         ),
                    //       ),
                    //       const Padding(
                    //         padding:
                    //             EdgeInsets.only(left: kMinInteractiveDimension),
                    //         child: Divider(
                    //           height: 1,
                    //         ),
                    //       ),
                    //       ListTile(
                    //         contentPadding:
                    //             const EdgeInsets.symmetric(horizontal: 16),
                    //         minVerticalPadding: 0,
                    //         leading: const Icon(Icons.audio_file_outlined),
                    //         title: const Text('Play Audio'),
                    //         onTap: () {
                    //           Navigator.of(context).push(
                    //             MaterialPageRoute<void>(
                    //               builder: (BuildContext context) => AudioPage(
                    //                 currentHost: currentHost,
                    //               ),
                    //             ),
                    //           );
                    //         },
                    //       ),
                    //     ]),
                    //   ),
                    // ),

                    // const SizedBox(height: 24),
                    // // copy right
                    // Padding(
                    //   padding: const EdgeInsets.symmetric(horizontal: 16),
                    //   child: Card(
                    //     margin: const EdgeInsets.all(0),
                    //     color: Theme.of(context)
                    //         .colorScheme
                    //         .surface
                    //         .withOpacity(0.7),
                    //     elevation: 0,
                    //     shape: RoundedRectangleBorder(
                    //       borderRadius: BorderRadius.circular(12),
                    //       side: BorderSide(
                    //         color: Colors.grey.withOpacity(0.5),
                    //         width: 1,
                    //       ),
                    //     ),
                    //     child: ListTile(
                    //       leading: const Icon(Icons.info),
                    //       title: const Text('chat with out bot'),
                    //       subtitle: const Text('bot'),
                    //       onTap: () {
                    //         Navigator.of(context).push(
                    //           MaterialPageRoute<void>(
                    //               builder: (BuildContext context) => ChatScreen(
                    //                     arduinoData: arduinoData,
                    //                   )),
                    //         );
                    //       },
                    //     ),
                    //   ),
                    // ),
                    SizedBox(
                      height: 16,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Card(
                        margin: const EdgeInsets.all(0),
                        color: Theme.of(context)
                            .colorScheme
                            .surface
                            .withOpacity(0.5),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(
                            color: Colors.grey.withOpacity(0.5),
                            width: 1,
                          ),
                        ),
                        child: Column(
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
                                          : Theme.of(context)
                                              .colorScheme
                                              .primary,
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

                    Text(
                      'AMINE MENADI © 2024 | USDB',
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onBackground
                                .withOpacity(0.5),
                          ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildConnect(ConnectionStatus connectionStatus) {
    return Container(
      margin: const EdgeInsets.only(left: 8),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: connectionStatus.color.withOpacity(0.2),
      ),
      child: Row(
        children: [
          Icon(
            connectionStatus == ConnectionStatus.connected
                ? Icons.router_outlined
                : connectionStatus == ConnectionStatus.connecting
                    ? Icons.router_outlined
                    : Icons.route_rounded,
            color: connectionStatus.color,
            size: 12,
          ),
          const SizedBox(width: 4),
          Text(
            connectionStatus.name,
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  color: connectionStatus.color,
                  fontSize: 10,
                ),
          ),
        ],
      ),
    );
  }
}

// [_GriedentGraphPainter] paints a line graph with a gradient body.
class _GriedentGraphPainter extends CustomPainter {
  _GriedentGraphPainter({
    required this.temperatures,
    required this.context,
    this.theme2 = false,
  });

  final List<num> temperatures;
  final BuildContext context;
  final bool theme2;

  @override
  void paint(Canvas canvas, Size size) {
    if (temperatures.length <= 2) {
      return;
    }
    final rectPaint = Paint()
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.fill;
    final linePaint = Paint()
      ..strokeWidth = theme2 ? 2 : 1
      ..color = theme2
          ? Theme.of(context).colorScheme.secondary
          : Theme.of(context).colorScheme.primary
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final rectPath = Path();
    final linePath = Path();

    final gradient = LinearGradient(
      colors: [
        Theme.of(context).colorScheme.tertiaryContainer,
        Theme.of(context).colorScheme.primary.withOpacity(0),
      ],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );

    final points = [
      ...temperatures.reversed.map((e) => e.toDouble()).toList(),
      // 0
    ];
    final max = points.reduce(math.max);
    final min = points.reduce(math.min);
    final diff = max - min;
    final step = size.width / points.length;

    for (var i = 0; i < points.length; i++) {
      final point = points[i];
      final x = step * i;
      final y = size.height - ((point - min) / diff) * size.height;
      if (i == 0) {
        rectPath.moveTo(x, y);
        linePath.moveTo(x, y);
      } else {
        if (!theme2) {
          final prevPoint = points[i - 1];
          final prevX = step * (i - 1);
          final prevY = size.height - ((prevPoint - min) / diff) * size.height;
          final x1 = prevX + (x - prevX) / 2;
          final y1 = prevY;
          final x2 = prevX + (x - prevX) / 2;
          final y2 = y;
          rectPath.cubicTo(x1, y1, x2, y2, x, y);
          linePath.cubicTo(x1, y1, x2, y2, x, y);
        } else {
          linePath.lineTo(x, y);
        }
      }
    }
    // close the rect
    rectPath.lineTo(size.width, size.height);
    rectPath.lineTo(0, size.height);

    rectPaint.shader = gradient.createShader(
      Rect.fromLTWH(0, 0, size.width, size.height),
    );

    if (!theme2) {
      canvas.drawPath(rectPath, rectPaint);
    }
    canvas.drawPath(linePath, linePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

Future<
    ({
      String password,
      String ssid,
    })?> showWifiUpdateDailog(
  BuildContext context, {
  String? password,
  String? ssid,
}) async {
  final ssidController = TextEditingController(text: ssid);
  final passwordController = TextEditingController(text: password);
  return await showDialog<
      ({
        String password,
        String ssid,
      })>(
    context: context,
    builder: (context) {
      return Form(
        child: AlertDialog(
          title: const Text('Update Wifi'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: ssidController,
                decoration: const InputDecoration(
                  isDense: true,
                  labelText: 'SSID',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.wifi_rounded),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter SSID';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: passwordController,
                decoration: const InputDecoration(
                  isDense: true,
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock_rounded),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter password';
                  }
                  if (value.length < 8) {
                    return 'Password must be at least 8 characters';
                  }
                  return null;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton.icon(
              icon: const Icon(Icons.done_all),
              onPressed: () {
                if (ssidController.text.isNotEmpty &&
                    passwordController.text.isNotEmpty) {
                  Navigator.pop(context, (
                    ssid: ssidController.text,
                    password: passwordController.text,
                  ));
                }
              },
              label: const Text('Update'),
            ),
          ],
        ),
      );
    },
  );
}

Future<String?> showConnectDailog(BuildContext context) async {
  final hostController = TextEditingController(text: "192.168.4.1");
  return await showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Connect'),
        content: TextFormField(
          controller: hostController,
          decoration: const InputDecoration(
            isDense: true,
            labelText: 'Host',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.wifi_rounded),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter host';
            }
            return null;
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          TextButton.icon(
            icon: const Icon(Icons.done_all),
            onPressed: () {
              if (hostController.text.isNotEmpty) {
                Navigator.pop(context, hostController.text);
              }
            },
            label: const Text('Connect'),
          ),
        ],
      );
    },
  );
}

// preferences dailog, update the color and them mode
Future<void> showPreferencesDailog(BuildContext context) async {
  final themeModeValue = themeMode.value;
  final themeColorValue = themeColor.value;
  return await showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Preferences'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.brightness_2_rounded),
              title: const Text('Theme Mode'),
              subtitle: Text(themeModeValue.name),
              trailing: DropdownButton<ThemeMode>(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                ),
                borderRadius: BorderRadius.circular(12),
                value: themeModeValue,
                onChanged: (value) {
                  themeMode.value = value!;
                },
                items: ThemeMode.values.map((e) {
                  return DropdownMenuItem(
                    value: e,
                    child: Text(e.name),
                  );
                }).toList(),
              ),
            ),
            ListTile(
              leading: const Icon(
                Icons.color_lens,
              ),
              title: const Text('Theme Color'),
              trailing: DropdownButton<Color>(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                ),
                borderRadius: BorderRadius.circular(12),
                value: themeColorValue,
                onChanged: (value) {
                  themeColor.value = value!;
                },
                items: Colors.primaries.map((e) {
                  return DropdownMenuItem(
                    value: e,
                    child: Container(
                      width: 50,
                      height: 20,
                      decoration: BoxDecoration(
                        color: e,
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          TextButton.icon(
            icon: const Icon(Icons.done_all),
            onPressed: () {
              Navigator.pop(context);
            },
            label: const Text('Update'),
          ),
        ],
      );
    },
  );
}

Future<String> showUpdateIpDailog(BuildContext context, {String? ip}) async {
  final ipController = TextEditingController(text: ip);
  return await showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Update IP'),
        content: TextFormField(
          controller: ipController,
          decoration: const InputDecoration(
            isDense: true,
            labelText: 'IP',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.location_searching_sharp),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter IP';
            }
            return null;
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          TextButton.icon(
            icon: const Icon(Icons.done_all),
            onPressed: () {
              if (ipController.text.isNotEmpty) {
                Navigator.pop(context, ipController.text);
              }
            },
            label: const Text('Update'),
          ),
        ],
      );
    },
  );
}

// class AboutPage extends StatelessWidget {
//   const AboutPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Expanded(
//           child: SingleChildScrollView(
//             child: InteractiveViewer(
//               child: Column(
//                 children: [
//                   for (var i = 0; i <= 13; i++)
//                     Container(
//                       padding: const EdgeInsets.only(bottom: 8.0),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           ConstrainedBox(
//                             constraints: BoxConstraints(
//                               maxWidth: MediaQuery.of(context).size.width,
//                             ),
//                             child: Image.asset(
//                               "assets/doc/Artboard $i-80.jpg",
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

// AudioPage
class AudioPage extends StatelessWidget {
  final String currentHost;
  const AudioPage({super.key, required this.currentHost});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Audio"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            for (var song in songs)
              ListTile(
                leading: const Icon(Icons.music_note_rounded),
                title: Text(song.split(':').first),
                onTap: () {
                  playSong(song);
                },
                trailing: const Icon(Icons.play_arrow_rounded),
              ),
          ],
        ),
      ),
    );
  }

  // String? song;
  // playSong
  Future<void> playSong(String value) async {
    final response = await http.post(
      Uri.parse('http://$currentHost/api?song=$value'),
    );
    // if (response.statusCode == 200) {
    //   setState(() {
    //     song = value;
    //   });
    // }
  }
}
