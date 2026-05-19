import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';

// ─────────────────────────────────────────────────────────────
//  DESIGN TOKENS
// ─────────────────────────────────────────────────────────────
class AppColors {
  static const background = Color(0xFF0F172A);
  static const cyan = Color(0xFF00E5FF);
  static const yellow = Color(0xFFFFD54F);
  static const green = Color(0xFF00E676);
  static const textPrimary = Color(0xFFFFFFFF);
  static const textSecondary = Color(0xFFCBD5E1);
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // ==============================================================
  // 🔗 BACKEND DATA PLACEHOLDERS (Fetch API aur yahan inject karo)
  // ==============================================================
  String backendMapCoordinates = "Lat: 24.8607, Long: 67.0011";
  String backendSeverityScore = "9.2/10";
  String backendAllocatedUnits = "48 Units";
  String backendAiWarning = "AI ANALYSIS: Severe flooding in Sector 12. Immediate evacuation advised. All units on high alert.";
  // ==============================================================

  void _startSimulationFlow(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SimulationLoadingScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      extendBody: true,
      
      // Yahan sirf AI Orchestration button hai. Agar SOS abhi bhi aaye, toh main.dart check karna!
      floatingActionButton: _buildOrchestrationFAB(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      
      bottomNavigationBar: _buildFuturisticBottomNav(),
      
      body: Stack(
        children: [
          Positioned(top: -100, right: -50, child: _buildGlow(const Color(0xFF6366F1).withOpacity(0.25))),
          Positioned(bottom: 50, left: -100, child: _buildGlow(AppColors.cyan.withOpacity(0.15))),

          SafeArea(
            bottom: false,
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20.0, 16.0, 20.0, 120.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 30),

                  // 1. MAP AREA (Backend Placeholder)
                  const Text('Active Crisis Map', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  FrostedGlassCard(
                    height: 160, padding: EdgeInsets.zero, radius: 25,
                    child: Stack(children: [
                      Positioned.fill(child: CustomPaint(painter: GridMapPainter())),
                      Center(child: Text("Map View Area\n($backendMapCoordinates)", textAlign: TextAlign.center, style: const TextStyle(color: Colors.white54))),
                    ]),
                  ),

                  const SizedBox(height: 25),

                  // 2. METRICS BOX (Backend Placeholders)
                  Row(
                    children: [
                      Expanded(child: _buildMetricCard("Severity Score", backendSeverityScore, AppColors.yellow, Icons.trending_up)),
                      const SizedBox(width: 15),
                      Expanded(child: _buildMetricCard("Allocated Units", backendAllocatedUnits, AppColors.green, Icons.local_shipping)),
                    ],
                  ),

                  const SizedBox(height: 25),

                  // 3. AI ALERT CARD (Backend Placeholder)
                  const Text('AI Stakeholder Warning', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  FrostedGlassCard(
                    padding: const EdgeInsets.all(20),
                    radius: 25,
                    child: Row(
                      children: [
                        const Icon(Icons.psychology, color: AppColors.cyan, size: 30),
                        const SizedBox(width: 15),
                        Expanded(child: Text(backendAiWarning, style: const TextStyle(color: AppColors.textSecondary, fontStyle: FontStyle.italic, fontSize: 14))),
                      ],
                    ),
                  ),

                  const SizedBox(height: 35),
                  
                  // 4. LIVE ALERTS (Wapas le aaya taake khali na lage)
                  const Text('Live Alerts', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 16),
                  _buildAlertTile(Icons.water_drop, 'Flood Warning', 'Sector 12 - Water levels rising', AppColors.cyan),
                  const SizedBox(height: 20),
                  _buildAlertTile(Icons.medical_services, 'Medical Emergency', 'Downtown - Ambulance Dispatched', AppColors.yellow),
                  const SizedBox(height: 20),
                  _buildAlertTile(Icons.security, 'Area Secured', 'Gulshan - Police deployed', AppColors.green),
                  
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- UI COMPONENTS ---

  Widget _buildHeader() => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      const Icon(Icons.menu, color: Colors.white, size: 28),
      FrostedGlassCard(padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8), radius: 30, child: const Row(children: [Icon(Icons.wb_cloudy_outlined, color: AppColors.cyan, size: 18), SizedBox(width: 8), Text('32°C • AQI 85', style: TextStyle(color: Colors.white, fontSize: 13))])),
      const Icon(Icons.notifications_outlined, color: Colors.white, size: 28),
    ],
  );

  Widget _buildMetricCard(String label, String value, Color color, IconData icon) => FrostedGlassCard(
    padding: const EdgeInsets.all(20),
    radius: 25,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 12),
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
        Text(label, style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
      ],
    ),
  );
  
  Widget _buildAlertTile(IconData icon, String title, String subtitle, Color accentColor) {
    return FrostedGlassCard(
      height: 105, 
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18), 
      radius: 25,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: accentColor.withOpacity(0.15), shape: BoxShape.circle, border: Border.all(color: accentColor.withOpacity(0.4), width: 1.5)),
            child: Icon(icon, color: accentColor, size: 26),
          ),
          const SizedBox(width: 22),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(title, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700)),
                const SizedBox(height: 6),
                Text(subtitle, style: const TextStyle(color: AppColors.textSecondary, fontSize: 14)),
              ],
            ),
          ),
          Icon(Icons.arrow_forward_ios_rounded, color: Colors.white.withOpacity(0.3), size: 16),
        ],
      ),
    );
  }

  Widget _buildOrchestrationFAB(BuildContext context) {
    return Container(
      height: 65,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: FloatingActionButton.extended(
        onPressed: () => _startSimulationFlow(context),
        backgroundColor: AppColors.cyan,
        icon: const Icon(Icons.rocket_launch, color: Colors.black),
        label: const Text("RUN AI ORCHESTRATION", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildFuturisticBottomNav() {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, bottom: 24),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(35), border: Border.all(color: Colors.white.withOpacity(0.15), width: 1.5)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavItem(Icons.dashboard_rounded, true),
          _buildNavItem(Icons.map_outlined, false),
          _buildNavItem(Icons.list_alt_rounded, false),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, bool isActive) => Icon(icon, color: isActive ? AppColors.cyan : Colors.white54, size: 28);
  Widget _buildGlow(Color color) => Container(width: 250, height: 250, decoration: BoxDecoration(shape: BoxShape.circle, color: color, boxShadow: [BoxShadow(color: color, blurRadius: 150, spreadRadius: 40)]));
}

// ─────────────────────────────────────────────────────────────
//  AI FLOW SCREENS
// ─────────────────────────────────────────────────────────────
class SimulationLoadingScreen extends StatefulWidget {
  const SimulationLoadingScreen({super.key});
  @override
  State<SimulationLoadingScreen> createState() => _SimulationLoadingScreenState();
}

class _SimulationLoadingScreenState extends State<SimulationLoadingScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 8), () {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const SimulationResultScreen()));
    });
  }
  @override
  Widget build(BuildContext context) => Scaffold(backgroundColor: AppColors.background, body: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [const CircularProgressIndicator(color: AppColors.cyan, strokeWidth: 6), const SizedBox(height: 30), const Text("ORCHESTRATING AGENTS...", style: TextStyle(color: Colors.white, fontSize: 20, letterSpacing: 2, fontWeight: FontWeight.bold))])));
}

class SimulationResultScreen extends StatelessWidget {
  const SimulationResultScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(backgroundColor: AppColors.background, body: Center(child: FrostedGlassCard(padding: const EdgeInsets.all(30), child: Column(mainAxisSize: MainAxisSize.min, children: [const Icon(Icons.check_circle, color: AppColors.green, size: 80), const SizedBox(height: 20), const Text("Orchestration Complete", style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)), const SizedBox(height: 20), ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text("Return to Dashboard"))]))));
}

// ─────────────────────────────────────────────────────────────
//  HELPERS
// ─────────────────────────────────────────────────────────────
class FrostedGlassCard extends StatelessWidget {
  final Widget child; final double radius; final EdgeInsets padding; final double? height;
  const FrostedGlassCard({super.key, required this.child, this.radius = 24, this.padding = const EdgeInsets.all(20), this.height});
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          height: height, padding: padding,
          decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(radius), border: Border.all(color: Colors.white.withOpacity(0.1))),
          child: child,
        ),
      ),
    );
  }
}

class GridMapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white.withOpacity(0.05)..strokeWidth = 1;
    for (double i = 0; i < size.width; i += 20) canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    for (double i = 0; i < size.height; i += 20) canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}