import 'package:flutter/material.dart';
import 'package:iot/pages/about_page.dart';
import 'package:iot/pages/map_page.dart';
import 'package:iot/pages/speed_page.dart';
import 'package:iot/main.dart';
import 'package:iot/pages/truck_waiting_screen.dart'; // Add this import

enum AppRoute {
  home(
    icon: Icons.home_outlined,
    selectedIcon: Icons.home,
    label: 'Home',
    key: ValueKey('home'),
  ),
  speed(
    icon: Icons.speed_outlined,
    selectedIcon: Icons.speed,
    label: 'Speed',
    key: ValueKey('speed'),
  ),
  map(
    icon: Icons.map_outlined,
    selectedIcon: Icons.map,
    label: 'Map',
    key: ValueKey('map'),
  ),
  truckWaiting(
    icon: Icons.local_shipping_outlined,
    selectedIcon: Icons.local_shipping,
    label: 'Trucks',
    key: ValueKey('truck_waiting'),
  ),
  about(
    icon: Icons.info_outline,
    selectedIcon: Icons.info,
    label: 'About',
    key: ValueKey('about'),
  ),
  profile(
    icon: Icons.person_outline,
    selectedIcon: Icons.person,
    label: 'Profile',
    key: ValueKey('profile'),
  );

  const AppRoute({
    required this.icon,
    required this.selectedIcon,
    required this.label,
    required this.key,
  });

  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final ValueKey key;

  Widget get screen {
    switch (this) {
      case AppRoute.home:
        return Home(key: key);
      case AppRoute.speed:
        return SpeedPage(key: key);
      case AppRoute.map:
        return FlutterMapOsrmExample(key: key);
      case AppRoute.truckWaiting:
        return TruckWaitingScreen(key: key);
      case AppRoute.about:
        return AboutPage(key: key);
      case AppRoute.profile:
        return AboutPage(key: key);
    }
  }
}
