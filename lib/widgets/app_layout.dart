import 'package:flutter/material.dart';
import 'package:iot/core/providers/auth_provider.dart';
import 'package:iot/core/providers/theme_provider.dart';
import 'package:iot/core/theme/app_theme.dart';
import 'package:iot/main.dart';
import 'package:iot/pages/about_page.dart';
import 'package:iot/pages/map_page.dart';
import 'package:iot/pages/qr_scanner_page.dart';
import 'package:iot/pages/speed_page.dart';
import 'package:iot/pages/truck_waiting_screen.dart';
import 'package:iot/pages/weekly_orders_page.dart';
import 'package:motif/motif.dart';
import 'package:provider/provider.dart'; // Add this import

class AppLayout extends StatefulWidget {
  final Widget child;
  final int currentIndex;

  const AppLayout({
    super.key,
    required this.child,
    this.currentIndex = 0,
  });

  @override
  State<AppLayout> createState() => _AppLayoutState();
}

class _AppLayoutState extends State<AppLayout>
    with SingleTickerProviderStateMixin {
  late int _currentIndex;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  List<Widget> _screens = [];
  bool _mounted = true;

  List<(IconData, IconData, String, Widget)> _getNavigationItems(
      String? userRole) {
    if (userRole == 'client') {
      return [
        (
          Icons.local_shipping_outlined,
          Icons.local_shipping,
          'Trucks',
          TruckWaitingScreen(key: const ValueKey('truck'))
        ),
        (
          Icons.assignment_outlined,
          Icons.assignment,
          'Orders',
          const WeeklyOrdersPage(key: ValueKey('orders'))
        ),
        (
          Icons.qr_code_scanner_outlined,
          Icons.qr_code_scanner,
          'QR Scanner',
          const QrScreen(key: ValueKey('qr'))
        ),
        (
          Icons.person_outline,
          Icons.person,
          'Profile',
          const ProfileScreen(key: ValueKey('profile'))
        ),
      ];
    } else if (userRole == 'driver') {
      return [
        (
          Icons.home_outlined,
          Icons.home,
          'Home',
          const HomeScreen(key: ValueKey('home'))
        ),
        (
          Icons.map_outlined,
          Icons.map,
          'Map',
          const MapScreen(key: ValueKey('map'))
        ),
        (
          Icons.person_outline,
          Icons.person,
          'Profile',
          const ProfileScreen(key: ValueKey('profile'))
        ),
      ];
    }
    // Default or fallback navigation items
    return [
      (
        Icons.home_outlined,
        Icons.home,
        'Home',
        const HomeScreen(key: ValueKey('home'))
      ),
      (
        Icons.person_outline,
        Icons.person,
        'Profile',
        const ProfileScreen(key: ValueKey('profile'))
      ),
    ];
  }

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.currentIndex;
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _mounted = false;
    _animationController.dispose();
    super.dispose();
  }

  void _navigate(int index) {
    if (!_mounted || index == _currentIndex) return;
    setState(() {
      _currentIndex = index;
      _animationController.reset();
      _animationController.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        final userRole = authProvider.currentUser?.role?.name;
        final navigationItems = _getNavigationItems(userRole);

        // Update screens list based on role
        _screens = navigationItems.map((item) => item.$4).toList();

        final currentScreen =
            _screens.isEmpty ? widget.child : _screens[_currentIndex];
        final isLargeScreen = MediaQuery.of(context).size.width >= 840;
        Widget mainContent = FadeTransition(
          opacity: _fadeAnimation,
          child: currentScreen,
        );

        if (isLargeScreen) {
          return Scaffold(
            // backgroundColor: Colors.transparent,
            body: Stack(
              children: [
                // const Positioned.fill(child: SinosoidalMotif()),
                Row(
                  children: [
                    NavigationRail(
                      extended: MediaQuery.of(context).size.width >= 1200,
                      destinations: navigationItems.map((item) {
                        return NavigationRailDestination(
                          icon: Icon(item.$1),
                          selectedIcon: Icon(item.$2),
                          label: Text(item.$3),
                        );
                      }).toList(),
                      selectedIndex: _currentIndex,
                      onDestinationSelected: _navigate,
                      leading: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Image.asset(
                          "assets/images/LOGIC_3.png",
                          color: Theme.of(context).colorScheme.primary,
                          width: 150,
                          height: 100,
                        ),
                      ),
                    ),
                    VerticalDivider(
                      thickness: 1,
                      width: 1,
                      color: Theme.of(context).dividerColor,
                    ),
                    Expanded(
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(16),
                          bottomLeft: Radius.circular(16),
                        ),
                        child: mainContent,
                      ),
                    ),
                  ],
                ),
                Positioned(
                  top: 16,
                  right: 16,
                  child: IconButton(
                    icon: Icon(
                      Theme.of(context).brightness == Brightness.dark
                          ? Icons.wb_sunny
                          : Icons.nightlight_round,
                    ),
                    onPressed: () {
                      themeMode.value = themeMode.value == ThemeMode.light
                          ? ThemeMode.dark
                          : ThemeMode.light;
                    },
                  ),
                ),
              ],
            ),
          );
        }

        return Scaffold(
          // backgroundColor: Colors.transparent,
          body: mainContent,
          bottomNavigationBar: NavigationBar(
            selectedIndex: _currentIndex,
            onDestinationSelected: _navigate,
            destinations: navigationItems.map((item) {
              return NavigationDestination(
                icon: Icon(item.$1),
                selectedIcon: Icon(item.$2),
                label: item.$3,
              );
            }).toList(),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              themeMode.value = themeMode.value == ThemeMode.light
                  ? ThemeMode.dark
                  : ThemeMode.light;
            },
            child: Icon(
              Theme.of(context).brightness == Brightness.dark
                  ? Icons.wb_sunny
                  : Icons.nightlight_round,
            ),
          ),
        );
      },
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) => const Home();
}

class SpeedScreen extends StatelessWidget {
  const SpeedScreen({super.key});
  @override
  Widget build(BuildContext context) => const SpeedPage();
}

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});
  @override
  Widget build(BuildContext context) => const FlutterMapOsrmExample();
}

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});
  @override
  Widget build(BuildContext context) => const AboutPage();
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  @override
  Widget build(BuildContext context) => const AboutPage();
}

// Add this at the end of the file
class QrScreen extends StatelessWidget {
  const QrScreen({super.key});
  @override
  Widget build(BuildContext context) => const QrScannerPage();
}

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});
  @override
  Widget build(BuildContext context) => const WeeklyOrdersPage();
}
