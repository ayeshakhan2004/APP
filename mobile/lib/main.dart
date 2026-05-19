import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart'; // 1. Yeh import add kiya hai
import 'screens/dashboard_screen.dart';
import 'screens/map_screen.dart';
import 'screens/resource_list_screen.dart';
import 'screens/alert_feed_screen.dart';
import 'package:flutter/foundation.dart'; // 1. YEH NAYA IMPORT LAZMI HAI (kIsWeb ke liye)

// ─────────────────────────────────────────────────────────────
//  GLOBAL THEME COLORS
// ─────────────────────────────────────────────────────────────
class AppTheme {
  static const cyan = Color(0xFF00E5FF);
  static const background = Color(0xFF0F172A);
  static const sosRed = Color(0xFFFF2A5F);
}

// 2. main() function ko async kar ke config initialize kiya hai
void main() async {
  WidgetsFlutterBinding.ensureInitialized(); 
  
  // 2. YEH CONDITION ADD KARNI HAI TAAKE WEB PAR CRASH NA HO
  if (!kIsWeb) {
    await FlutterConfig.loadEnvVariables(); 
  }
  
  runApp(const CIROApp());
}

class CIROApp extends StatelessWidget {
  const CIROApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CIRO - Crisis Orchestrator',
      debugShowCheckedModeBanner: false, 
      theme: ThemeData.dark().copyWith(
        primaryColor: AppTheme.cyan,
        scaffoldBackgroundColor: AppTheme.background,
      ),
      home: const MainNavigation(),
    );
  }
}

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;

  static const List<Widget> _screens = [
    DashboardScreen(),
    CrisisMapScreen(),
    ResourceListScreen(),
    AlertFeedScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true, 
      backgroundColor: AppTheme.background,
      
      // GLOBAL SOS BUTTON
      floatingActionButton: _buildSOSButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      
      body: _screens[_selectedIndex],
      
      // FUTURISTIC GLASS NAVBAR
      bottomNavigationBar: _buildFuturisticBottomNav(),
    );
  }

  // ─────────────────────────────────────────────────────────────
  //  WIDGET BUILDERS
  // ─────────────────────────────────────────────────────────────

  Widget _buildSOSButton() {
    return Container(
      margin: const EdgeInsets.only(bottom: 90), 
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppTheme.sosRed.withOpacity(0.6),
            blurRadius: 25,
            spreadRadius: 5,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(35),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: FloatingActionButton(
            onPressed: () {
              // SOS Action Here
            },
            backgroundColor: AppTheme.sosRed.withOpacity(0.8),
            elevation: 0,
            child: const Text('SOS', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 16)),
          ),
        ),
      ),
    );
  }

  Widget _buildFuturisticBottomNav() {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, bottom: 24),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(35),
        border: Border.all(color: Colors.white.withOpacity(0.15), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 25,
            offset: const Offset(0, 10),
          ),
          BoxShadow(
            color: AppTheme.cyan.withOpacity(0.05),
            blurRadius: 30,
            spreadRadius: 5,
          )
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(35),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildNavItem(Icons.dashboard_rounded, 'Dashboard', 0),
              _buildNavItem(Icons.map_outlined, 'Map', 1),
              _buildNavItem(Icons.list_alt_rounded, 'Resources', 2),
              _buildNavItem(Icons.notifications_outlined, 'Alerts', 3),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final isActive = _selectedIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedIndex = index),
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon, 
              color: isActive ? AppTheme.cyan : Colors.white.withOpacity(0.5), 
              size: isActive ? 28 : 24
            ),
            const SizedBox(height: 6),
            if (isActive)
              Container(
                width: 18,
                height: 4,
                decoration: BoxDecoration(
                  color: AppTheme.cyan,
                  borderRadius: BorderRadius.circular(2),
                  boxShadow: [
                    BoxShadow(color: AppTheme.cyan, blurRadius: 10, spreadRadius: 2), 
                  ],
                ),
              )
            else
              Text(label, style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 11, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}