import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
// google fonts
import 'package:google_fonts/google_fonts.dart';
import 'package:motif/motif.dart';
import 'package:timeago/timeago.dart' as timeago;
// http
import 'package:http/http.dart' as http;
import 'dart:convert';
// web socket
import 'package:web_socket_channel/web_socket_channel.dart';

DateTime appStartAt = DateTime.now();

ValueNotifier<ThemeMode> themeMode = ValueNotifier(ThemeMode.system);
ValueNotifier<Color> themeColor = ValueNotifier(Colors.amber);

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});
  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
        listenable: Listenable.merge([
          themeMode,
          themeColor
        ]),
        builder: (context, snapshot) {
          return MaterialApp(
            title: 'IOT',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: themeColor.value),
              useMaterial3: true,
              textTheme: GoogleFonts.poppinsTextTheme(),
            ),
            darkTheme: ThemeData.dark().copyWith(
              colorScheme: ColorScheme.fromSeed(seedColor: themeColor.value, brightness: Brightness.dark),
              textTheme: GoogleFonts.poppinsTextTheme(
                ThemeData.dark().textTheme,
              ),
            ),
            themeMode: themeMode.value,
            home: const Home(),
          );
        });
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
        return "$temperature °C";
      case "fahrenheit":
        return "$fahrenheit °C";
      case "humidity":
        return "$humidity %";
      case "heatindexC":
        return "$heatindexC °C";
      case "heatindexF":
        return "$heatindexF °C";
      case "tankHeight-distance":
        return "${tankHeight - distance}";
      case "remains":
        return "${(tankHeight - distance) ~/ (tankHeight / 100)}%";
      default:
        return "$distance cm";
    }
  }

//      "temperature"=>  "$temperature °C",
//       "fahrenheit"=>  "$fahrenheit °F",
//       "humidity"=>  "$humidity %",
//       "heatindexC"=>  "$heatindexC °C",
//       "heatindexF"=>  "$heatindexF °F",
//       "distance"=>  "$distance cm",

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
  num flaged = 0;
  num temperature = 0;
  num distance = 0;
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

  WebSocketChannel? channel;
  StreamSubscription? subscription;

  @override
  void initState() {
    super.initState();
    initWebSocket(connectionType);
  }

  void initWebSocket(ConnectionType connectionType) async {
    this.connectionType = connectionType;
    wifiConnectionStatus = ConnectionStatus.disconnected;
    apConnectionStatus = ConnectionStatus.disconnected;

    if (connectionType == ConnectionType.wifi) {
      wifiConnectionStatus = ConnectionStatus.connecting;
      channel?.sink.close();
      channel = WebSocketChannel.connect(
        Uri.parse('ws://$wifi_ip/ws'),
      );
    } else if (connectionType == ConnectionType.ap) {
      apConnectionStatus = ConnectionStatus.connecting;
      channel?.sink.close();
      channel = WebSocketChannel.connect(
        Uri.parse('ws://$ap_ip/ws'),
      );
    }
    if (mounted) {
      setState(() {});
    }

    subscription?.cancel();
    try {
      subscription = channel!.stream.listen(
        (event) {
          if (currentConnectionStatus != ConnectionStatus.connected) {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            ScaffoldMessenger.maybeOf(context)?.showSnackBar(
              SnackBar(
                  backgroundColor: Colors.green,
                  behavior: SnackBarBehavior.floating,
                  width: 400.0,
                  content: Text('Connected to $currentHost | using ${connectionType == ConnectionType.wifi ? 'wifi' : 'ap'}'),
                  action: SnackBarAction(
                    label: 'hide',
                    onPressed: () {
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    },
                  )),
            );
          }
          if (connectionType == ConnectionType.wifi) {
            wifiConnectionStatus = ConnectionStatus.connected;
          } else if (connectionType == ConnectionType.ap) {
            apConnectionStatus = ConnectionStatus.connected;
          }
          final data = jsonDecode(event);
          print(data);
          setState(() {
            time = data['time'] ?? time;
            ap_ip = data['ap_ip'] ?? ap_ip;
            ap_status = data['ap_status'] ?? ap_status;
            wifi_ip = data['wifi_ip'] ?? wifi_ip;
            wifiStatus = data['wifi_status'] ?? wifiStatus;
            wifiSSID = data['wifi_ssid'] ?? wifiSSID;
            readRate = data['readRate'] ?? readRate;
            flaged = data['flaged'] ?? flaged;
            distance = num.tryParse((data['distance'] ?? 0).toStringAsFixed(2)) ?? distance;
            tankHeight = num.tryParse((data['tankHeight'] ?? 0).toStringAsFixed(2)) ?? tankHeight;
            realDistance = num.tryParse((data['realDistance'] ?? 0).toStringAsFixed(2)) ?? realDistance;
            averageDistance = num.tryParse((data['averageDistance'] ?? 0).toStringAsFixed(2)) ?? averageDistance;
            temperature = num.tryParse((data['temperature'] ?? 0).toStringAsFixed(2)) ?? temperature;
            fahrenheit = num.tryParse((data['fahrenheit'] ?? 0).toStringAsFixed(2)) ?? fahrenheit;
            humidity = num.tryParse((data['humidity'] ?? 0).toStringAsFixed(2)) ?? humidity;
            heatindexC = num.tryParse((data['heatindexC'] ?? 0).toStringAsFixed(2)) ?? heatindexC;
            heatindexF = num.tryParse((data['heatindexF'] ?? 0).toStringAsFixed(2)) ?? heatindexF;
            temperatures.add(temperature);
            humidities.add(humidity);
            distances.add(distance);
            if (distances.length > 50) {
              distances.removeAt(0);
            }
            if (temperatures.length > 50) {
              temperatures.removeAt(0);
            }
            if (temperatures.length > 50) {
              temperatures.removeAt(0);
            }
          });
        },
        onError: (error) {
          setState(() {
            if (connectionType == ConnectionType.wifi) {
              wifiConnectionStatus = ConnectionStatus.disconnected;
            } else if (connectionType == ConnectionType.ap) {
              apConnectionStatus = ConnectionStatus.disconnected;
            }
          });
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.maybeOf(context)?.showSnackBar(
            SnackBar(
                behavior: SnackBarBehavior.floating,
                width: 400.0,
                content: Text('Failed to connect to $currentHost | using ${connectionType == ConnectionType.wifi ? 'wifi' : 'ap'}'),
                action: SnackBarAction(
                  label: 'reconnect',
                  onPressed: () {
                    initWebSocket(connectionType);
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  },
                )),
          );
          DateTime now = DateTime.now();
          if (lastRetry == null || (lastRetry!.difference(now)).abs().inSeconds > 5) {
            initWebSocket(connectionType == ConnectionType.ap ? ConnectionType.wifi : ConnectionType.ap);
            lastRetry = now;
            setState(() {});
          }
        },
        cancelOnError: true,
      );
    } catch (e) {
      print("---------------");
      print(e);
      await Future.delayed(Duration(seconds: 2));
      initWebSocket(connectionType);
    }
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
    // send post to /api with readRate query
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
    // send post to /api with readRate query
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
    // send post to /api with readRate query
    final response = await http.post(
      Uri.parse('http://$currentHost/api?readRate=$value'),
    );
    if (response.statusCode == 200) {
      setState(() {
        readRate = value;
      });
    }
  }

  Future<void> updateFlaged(num value) async {
    // send post to /api with flaged query
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

  Future<void> updateWifi({required String ssid, required String password}) async {
    // send post to /api with wifi query
    try {
      final response = await http.post(
        Uri.parse('http://$currentHost/api?wifi_ssid=$ssid&wifi_password=$password'),
      );
    } catch (e) {
      print(e);
    }
  }

  Future<void> updateAP({required String ssid, required String password}) async {
    // send post to /api with wifi query
    try {
      final response = await http.post(
        Uri.parse('http://$currentHost/api?ap_ssid=$ssid&ap_password=$password'),
      );
    } catch (e) {
      print(e);
    }
  }

  Future<void> restart() async {
    // send post to /api with wifi query
    try {
      final response = await http.post(
        Uri.parse('http://$currentHost/api?restart=1'),
      );
    } catch (e) {
      print(e);
    }
  }

  @override
  void dispose() {
    subscription?.cancel();
    channel?.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const Positioned.fill(
            child: SinosoidalMotif(),
          ),
          SingleChildScrollView(
            child: Center(
              child: Container(
                // max width 800
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
                        title: const Text('Hello IOT'),
                        actions: [
                          IconButton(
                            icon: const Icon(Icons.power_settings_new_rounded),
                            onPressed: () async {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text('Restart'),
                                    content: const Text('Are you sure you want to restart the device?'),
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
                                          restart();
                                          Navigator.pop(context);
                                        },
                                        label: const Text('Restart'),
                                      ),
                                    ],
                                  );
                                },
                              );
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
                                color: Theme.of(context).colorScheme.surface.withOpacity(0.5),
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
                                      child:  Column(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Container(
                                            height: 1,
                                            decoration: BoxDecoration(
                                              color: Theme.of(context).colorScheme.primary,
                                              gradient: LinearGradient(
                                                colors: [

                                                  Colors.blue.withOpacity(0.5),
                                                  Colors.blue,
                                                  Colors.blue,
                                                  Colors.blue.withOpacity(0.5),
                                                ],
                                                begin: Alignment.centerLeft,
                                                end: Alignment.centerRight,
                                                // stops: const [0.1, 0.2, 0],
                                              )
                                            ),
                                          ),
                                          AnimatedContainer(
                                            duration: const Duration(milliseconds: 300),
                                            height: 180*math.max(0, (tankHeight<=0?0:((tankHeight-averageDistance)/tankHeight))),
                                            decoration: BoxDecoration(
                                              color: Theme.of(context).colorScheme.primary,
                                              gradient: LinearGradient(
                                                colors: [
                                                  Colors.blueAccent.withOpacity(0.5),
                                                  Colors.blue.withOpacity(0),
                                                ],
                                                begin: Alignment.topCenter,
                                                end: Alignment.bottomCenter,
                                                // stops: const [0.1, 0.2, 0],
                                              )
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Positioned.fill(
                                      child:  Column(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Container(
                                            height: 1,
                                            decoration: BoxDecoration(
                                              color: Theme.of(context).colorScheme.primary,
                                              gradient: LinearGradient(
                                                colors: [

                                                  Colors.green.withOpacity(0.5),
                                                  Colors.blue,
                                                  Colors.blue,
                                                  Colors.green.withOpacity(0.5),
                                                ],
                                                begin: Alignment.centerLeft,
                                                end: Alignment.centerRight,
                                                // stops: const [0.1, 0.2, 0],
                                              )
                                            ),
                                          ),
                                          AnimatedContainer(
                                            duration: const Duration(milliseconds: 300),
                                            height: 180*math.max(0, (tankHeight<=0?0:((tankHeight-distance)/tankHeight))),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        const SizedBox(height: 24),
                                        Text(
                                         tankHeight > 0? "${(tankHeight-averageDistance)*100~/tankHeight}%" : "--%",
                                          style: Theme.of(context).textTheme.headlineMedium!.copyWith(fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(height: 12),
                                        const Row(
                                          children: [],
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Column(
                                              children: [
                                                const Icon(Icons.leak_add_rounded),
                                                Text('${distance.toInt()}cm'),
                                              ],
                                            ),
                                            const SizedBox(height: 30, child: VerticalDivider()),
                                            Column(
                                              children: [
                                                const Icon(Icons.join_full_outlined),
                                                Text('${tankHeight.toInt()}cm'),
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
                                color: Theme.of(context).colorScheme.surface.withOpacity(0.5),
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
                                    // Positioned(
                                    //   left: 0,
                                    //   right: 0,
                                    //   bottom: 0,
                                    //   height: 20,
                                    //   child: CustomPaint(
                                    //     painter: _GriedentGraphPainter(
                                    //       temperatures:  temperatures,
                                    //       context: context,
                                    //       theme2: true
                                    //     ),
                                    //   ),
                                    // ),
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
                                      mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              const SizedBox(height: 24),
                                              Text(
                                                displayValue,
                                                style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                              ),
                                              const SizedBox(width: 8),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  // connection status
                                                  Container(
                                                    width: 30,
                                                    height: 20,
                                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(12),
                                                      color: currentConnectionStatus.color.withOpacity(0.2),
                                                    ),
                                                    child: Center(
                                                      child: Icon(
                                                        currentConnectionStatus == ConnectionStatus.connected ? connectionType.connectedIcon : connectionType.disconnectedIcon,
                                                        color: currentConnectionStatus.color,
                                                        size: 12,
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 8),
                                                  // if (lastRetry != null)
                                                  //   Text("retry in "+(lastRetry!.difference(DateTime.now()).abs().inSeconds.toString())+"...")
                                                  //   else
                                                  Text(timeago.format(appStartAt)),
                                                ],
                                              ),
                                              const SizedBox(height: 12),
                                              const Row(
                                                children: [],
                                              ),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Column(
                                                    children: [
                                                      const Icon(Icons.device_thermostat_rounded),
                                                      Text('$temperature °C'),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 30, child: VerticalDivider()),
                                                  Column(
                                                    children: [
                                                      const Icon(Icons.water_rounded),
                                                      Text('$humidity %'),
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
                    const ListTile(
                      enabled: false,
                      leading: Icon(Icons.data_saver_off_rounded),
                      title: Text('Data from device'),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Card(
                        margin: const EdgeInsets.all(0),
                        color: Theme.of(context).colorScheme.surface.withOpacity(0.7),
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
                                var ip = await showUpdateIpDailog(context, ip: wifi_ip);
                                if (ip != null) {
                                  wifi_ip = ip;
                                  initWebSocket(ConnectionType.wifi);
                                }
                              },
                              onTap: () {
                                if (currentConnectionStatus == ConnectionStatus.connected) {
                                  disconnect();
                                  if (connectionType == ConnectionType.ap) {
                                    initWebSocket(ConnectionType.wifi);
                                  }
                                } else {
                                  initWebSocket(ConnectionType.wifi);
                                }
                              },
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                              minVerticalPadding: 0,
                              leading: wifiConnectionStatus == ConnectionStatus.connecting ? const CircularProgressIndicator.adaptive() : Icon(wifiConnectionStatus == ConnectionStatus.connected ? ConnectionType.wifi.connectedIcon : ConnectionType.wifi.disconnectedIcon, color: wifiConnectionStatus.color),
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
                                  Text("$wifiSSID | $wifiStatus", style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Theme.of(context).colorScheme.onBackground.withOpacity(0.5), fontSize: 10)),
                                ],
                              ),
                              trailing: IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () async {
                                  var data = await showWifiUpdateDailog(context, ssid: wifiSSID, password: "iotiotiot");
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
                              padding: EdgeInsets.only(left: kMinInteractiveDimension),
                              child: Divider(
                                height: 1,
                              ),
                            ),
                            ListTile(
                              onLongPress: () async {
                                var ip = await showUpdateIpDailog(context, ip: ap_ip);
                                if (ip != null) {
                                  ap_ip = ip;
                                  initWebSocket(ConnectionType.ap);
                                }
                              },
                              onTap: () {
                                if (currentConnectionStatus == ConnectionStatus.connected) {
                                  disconnect();
                                  if (connectionType == ConnectionType.wifi) {
                                    initWebSocket(ConnectionType.ap);
                                  }
                                } else {
                                  initWebSocket(ConnectionType.ap);
                                }
                              },
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                              minVerticalPadding: 0,
                              leading: apConnectionStatus == ConnectionStatus.connecting ? const CircularProgressIndicator.adaptive() : Icon(apConnectionStatus == ConnectionStatus.connected ? ConnectionType.ap.connectedIcon : ConnectionType.ap.disconnectedIcon, color: apConnectionStatus.color),
                              title: Row(
                                children: [
                                  const Text('AP IP'),
                                  const SizedBox(width: 8),
                                  buildConnect(apConnectionStatus),
                                  const SizedBox(width: 8),
                                  Text(ap_status, style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Theme.of(context).colorScheme.onBackground.withOpacity(0.5), fontSize: 10)),
                                ],
                              ),
                              subtitle: Text(ap_ip),
                              trailing: IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () async {
                                  var data = await showWifiUpdateDailog(context, ssid: "IOT_AP", password: "iotiotiot");
                                  if (data != null) {
                                    updateAP(
                                      ssid: data.ssid,
                                      password: data.password,
                                    );
                                  }
                                },
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(left: kMinInteractiveDimension),
                              child: Divider(
                                height: 1,
                              ),
                            ),
                            ListTile(
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                              minVerticalPadding: 0,
                              leading: const Icon(Icons.wifi_protected_setup),
                              title: const Text('Read Rate'),
                              subtitle: Text('$readRate ms'),
                              // two icon buttons + - in range 0 - 2000
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.remove_rounded),
                                    onPressed: readRate > 0 ? () => updateReadRate(readRate - 100) : null,
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.add_rounded),
                                    onPressed: readRate < 2000 ? () => updateReadRate(readRate + 100) : null,
                                  ),
                                ],
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(left: kMinInteractiveDimension),
                              child: Divider(
                                height: 1,
                              ),
                            ),
                            ListTile(
                              onTap: () {
                                updateFlaged(flaged == 1 ? 0 : 1);
                              },
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                              minVerticalPadding: 0,
                              leading: Icon(
                                flaged == 1 ? Icons.lightbulb_sharp : Icons.lightbulb_outline_rounded,
                                color: flaged == 1 ? Colors.amber : null,
                              ),
                              title: const Text('Flaged'),
                              subtitle: Text(flaged == 1 ? 'Yes' : 'No'),
                              trailing: Switch(
                                value: flaged == 1,
                                onChanged: (value) {
                                  updateFlaged(value ? 1 : 0);
                                },
                                thumbIcon: MaterialStateProperty.all(
                                  Icon(
                                    flaged == 1 ? Icons.light_mode_rounded : Icons.light_mode,
                                  ),
                                ),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(left: kMinInteractiveDimension),
                              child: Divider(
                                height: 1,
                              ),
                            ),
                            ListTile(
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                              minVerticalPadding: 0,
                              leading: const Icon(Icons.water_drop_outlined),
                              title: const Text('Distance'),
                              subtitle: Text('$distance cm / max ${tankHeight}%'),
                              // dialog to update it
                              trailing: IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () async {
                                  var data = await showDialog(
                                      context: context,
                                      builder: (context) {
                                        var value = TextEditingController(text: tankHeight.toString());
                                        return AlertDialog(
                                          title: const Text('Update Distance'),
                                          content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              TextFormField(
                                                controller: value,
                                                decoration: const InputDecoration(
                                                  isDense: true,
                                                  labelText: 'Tank Height',
                                                  border: OutlineInputBorder(),
                                                  prefixIcon: Icon(Icons.water_rounded),
                                                ),
                                                keyboardType: TextInputType.number,
                                                validator: (value) {
                                                  if (value == null || value.isEmpty) {
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
                                                  Navigator.pop(context, num.parse(value.text));
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
                              padding: EdgeInsets.only(left: kMinInteractiveDimension),
                              child: Divider(
                                height: 1,
                              ),
                            ),
                            ListTile(
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                              minVerticalPadding: 0,
                              leading: const Icon(Icons.thermostat_rounded),
                              title: const Text('Temperature'),
                              subtitle: Text('$temperature °C / $fahrenheit °F'),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(left: kMinInteractiveDimension),
                              child: Divider(
                                height: 1,
                              ),
                            ),
                            ListTile(
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                              minVerticalPadding: 0,
                              leading: const Icon(Icons.water_rounded),
                              title: const Text('Humidity'),
                              subtitle: Text('$humidity %'),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(left: kMinInteractiveDimension),
                              child: Divider(
                                height: 1,
                              ),
                            ),
                            ListTile(
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                              minVerticalPadding: 0,
                              leading: const Icon(Icons.thermostat_rounded),
                              title: const Text('Heat Index'),
                              subtitle: Text('$heatindexC °C / $heatindexF °F'),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(left: kMinInteractiveDimension),
                              child: Divider(
                                height: 1,
                              ),
                            ),
                            ListTile(
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                              minVerticalPadding: 0,
                              leading: const Icon(Icons.file_present_outlined),
                              title: const Text('Read Docs'),
                              subtitle: Text('all info about the project'),
                              onTap: () {
                                Navigator.of(context).push(    MaterialPageRoute<void>(
      builder: (BuildContext context) => const AboutPage(),
    ),
);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    // copy right
                    Text(
                      'MOHAMADLOUNNAS © 2024 | USDB',
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            color: Theme.of(context).colorScheme.onBackground.withOpacity(0.5),
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
      ..color = theme2 ? Theme.of(context).colorScheme.secondary : Theme.of(context).colorScheme.primary
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
                if (ssidController.text.isNotEmpty && passwordController.text.isNotEmpty) {
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







class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Documents"),
      ),
      body: ListView(
        children: [
          for (var i = 0; i<=13;i++)
            Padding(
              padding: const EdgeInsets.only(bottom:  8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset("assets/doc/Artboard $i-80.jpg"),
                ],
              ),
            ),
        ],
      ),
    );
  }
}