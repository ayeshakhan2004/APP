import 'dart:ui';
import 'package:flutter/material.dart';

// ─────────────────────────────────────────────────────────────
//  DESIGN TOKENS — High Contrast & Frosted Theme
// ─────────────────────────────────────────────────────────────
class AppColors {
  static const background = Color(0xFF0F172A); // Deep Slate/Navy Blue
  
  // Brand Palette
  static const cyan = Color(0xFF00E5FF);
  static const yellow = Color(0xFFFFD54F);
  static const green = Color(0xFF00E676);
  static const sosRed = Color(0xFFFF2A5F); // Glowing Red for SOS
  
  // Text Colors
  static const textPrimary = Color(0xFFFFFFFF);
  static const textSecondary = Color(0xFFCBD5E1); 
}

// ─────────────────────────────────────────────────────────────
//  FROSTED GLASS CARD COMPONENT
// ─────────────────────────────────────────────────────────────
class FrostedGlassCard extends StatelessWidget {
  final Widget child;
  final double radius;
  final EdgeInsets padding;
  final double? height;
  final double? width;

  const FrostedGlassCard({
    super.key,
    required this.child,
    this.radius = 24, 
    this.padding = const EdgeInsets.all(20),
    this.height,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 20,
            spreadRadius: -5,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05), 
              borderRadius: BorderRadius.circular(radius),
              border: Border.all(
                color: Colors.white.withOpacity(0.25), 
                width: 1.2,
              ),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withOpacity(0.15),
                  Colors.white.withOpacity(0.02),
                ],
              ),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  DASHBOARD SCREEN
// ─────────────────────────────────────────────────────────────
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      extendBody: true, // Yeh navbar ko floating look dega aur background uske peeche nazar aayega
      
      // 1. QUICK ACTION / SOS FAB
      floatingActionButton: _buildSOSButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      
      // FUTURISTIC FLOATING NAVBAR
      bottomNavigationBar: _buildFuturisticBottomNav(),
      
      body: Stack(
        children: [
          // Subtle Background Glows
          Positioned(
            top: -100,
            right: -50,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF6366F1).withOpacity(0.25),
                boxShadow: [BoxShadow(color: const Color(0xFF6366F1).withOpacity(0.25), blurRadius: 150, spreadRadius: 50)],
              ),
            ),
          ),
          Positioned(
            bottom: 50,
            left: -100,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.cyan.withOpacity(0.15),
                boxShadow: [BoxShadow(color: AppColors.cyan.withOpacity(0.15), blurRadius: 150, spreadRadius: 40)],
              ),
            ),
          ),

          // Main Content
          SafeArea(
            bottom: false, // Taa ke content neechay tak scroll ho
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20.0, 16.0, 20.0, 120.0), // Bottom padding extra di hai FAB aur Navbar ke liye
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Icon(Icons.menu, color: Colors.white, size: 28),
                      // 2. WEATHER & ENVIRONMENT SNIPPET
                      FrostedGlassCard(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        radius: 30,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.wb_cloudy_outlined, color: AppColors.cyan, size: 18),
                            const SizedBox(width: 8),
                            const Text('32°C • AQI 85', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                      const Icon(Icons.notifications_outlined, color: Colors.white, size: 28),
                    ],
                  ),
                  const SizedBox(height: 24),
                  
                  // Main Titles
                  const Text(
                    'Emergency Overview',
                    style: TextStyle(color: AppColors.textSecondary, fontSize: 15, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text(
                        'Monitoring City\nStatus',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 32,
                          fontWeight: FontWeight.w800,
                          height: 1.1,
                          letterSpacing: -0.5,
                        ),
                      ),
                      // 3. ACTIVE RESPONDERS AVATAR ROW
                      _buildRespondersStack(),
                    ],
                  ),
                  const SizedBox(height: 30),

                  // Grid Stats Section
                  SizedBox(
                    height: 180, 
                    child: Row(
                      children: [
                        Expanded(child: _buildStatCard('Active Crises', '12', 'Critical', AppColors.yellow, Icons.warning_amber_rounded)),
                        const SizedBox(width: 16),
                        Expanded(child: _buildStatCard('Resources', '48', 'Deployed', AppColors.green, Icons.local_shipping_outlined)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // 4. MINI MAP SNIPPET
                  FrostedGlassCard(
                    height: 90,
                    padding: const EdgeInsets.all(0),
                    radius: 20,
                    child: Stack(
                      children: [
                        Positioned.fill(child: CustomPaint(painter: GridMapPainter())),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 18.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text('Nearest Safe Zone', style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      const Icon(Icons.location_on, color: AppColors.green, size: 18),
                                      const SizedBox(width: 6),
                                      const Text('2.4 km away', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ],
                              ),
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: AppColors.cyan.withOpacity(0.2),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.navigation_rounded, color: AppColors.cyan, size: 20),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 35),

                  // Alerts Header
                  const Text('Live Alerts', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 12),

                  // 5. CATEGORY FILTER CHIPS
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildFilterChip('All', Icons.apps, true, Colors.white),
                        _buildFilterChip('Medical', Icons.medical_services, false, AppColors.yellow),
                        _buildFilterChip('Flood', Icons.water_drop, false, AppColors.cyan),
                        _buildFilterChip('Fire', Icons.local_fire_department, false, AppColors.sosRed),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Alert List Items
                  _buildAlertTile(Icons.water_drop, 'Flood Warning', 'Sector 12 - Water levels rising', AppColors.cyan),
                  const SizedBox(height: 14),
                  _buildAlertTile(Icons.medical_services, 'Medical Emergency', 'Downtown - Ambulance Dispatched', AppColors.yellow),
                  const SizedBox(height: 14),
                  _buildAlertTile(Icons.security, 'Area Secured', 'Gulshan - Police deployed', AppColors.green),
                  
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- WIDGET BUILDERS ---

  Widget _buildStatCard(String title, String value, String subtitle, Color color, IconData icon) {
    return FrostedGlassCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(color: AppColors.textPrimary, fontSize: 15, fontWeight: FontWeight.w600)),
              Icon(icon, color: color, size: 24),
            ],
          ),
          SizedBox(
            height: 35,
            child: CustomPaint(painter: NeonChartPainter(color: color), size: const Size(double.infinity, 35)),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(value, style: const TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold)),
              const SizedBox(width: 8),
              Padding(
                padding: const EdgeInsets.only(bottom: 6.0),
                child: Text(subtitle, style: TextStyle(color: color, fontSize: 13, fontWeight: FontWeight.w700)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, IconData icon, bool isActive, Color color) {
    return Padding(
      padding: const EdgeInsets.only(right: 12.0),
      child: FrostedGlassCard(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        radius: 30,
        child: Row(
          children: [
            Icon(icon, color: isActive ? AppColors.background : color, size: 16),
            const SizedBox(width: 8),
            Text(label, style: TextStyle(
              color: isActive ? AppColors.background : Colors.white, 
              fontWeight: FontWeight.w600,
              fontSize: 14,
            )),
          ],
        ),
      ).wrapWithActiveState(isActive),
    );
  }

  Widget _buildAlertTile(IconData icon, String title, String subtitle, Color accentColor) {
    return FrostedGlassCard(
      height: 90,
      padding: const EdgeInsets.symmetric(horizontal: 18),
      radius: 20,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: accentColor.withOpacity(0.15),
              shape: BoxShape.circle,
              border: Border.all(color: accentColor.withOpacity(0.4), width: 1.5),
            ),
            child: Icon(icon, color: accentColor, size: 24),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(title, style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w700)),
                const SizedBox(height: 6),
                Text(subtitle, style: const TextStyle(color: AppColors.textSecondary, fontSize: 14, fontWeight: FontWeight.w400)),
              ],
            ),
          ),
          Icon(Icons.arrow_forward_ios_rounded, color: Colors.white.withOpacity(0.3), size: 18),
        ],
      ),
    );
  }

  Widget _buildRespondersStack() {
    return SizedBox(
      width: 100,
      height: 40,
      child: Stack(
        children: [
          Positioned(right: 0, child: _buildAvatarPlaceholder(Colors.blue, 'A')),
          Positioned(right: 25, child: _buildAvatarPlaceholder(Colors.purple, 'S')),
          Positioned(right: 50, child: _buildAvatarPlaceholder(Colors.teal, 'M')),
          Positioned(right: 75, child: _buildAvatarPlaceholder(AppColors.background, '+3', isCount: true)),
        ],
      ),
    );
  }

  Widget _buildAvatarPlaceholder(Color color, String text, {bool isCount = false}) {
    return Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        border: Border.all(color: Colors.white.withOpacity(0.8), width: 2),
      ),
      alignment: Alignment.center,
      child: Text(text, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: isCount ? 12 : 16)),
    );
  }

  Widget _buildSOSButton() {
    return Container(
      margin: const EdgeInsets.only(bottom: 90), // FAB ko navbar se thora upar rakha hai
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppColors.sosRed.withOpacity(0.6),
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
            onPressed: () {},
            backgroundColor: AppColors.sosRed.withOpacity(0.8), 
            elevation: 0,
            child: const Text('SOS', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 16)),
          ),
        ),
      ),
    );
  }

  // 🔥 FUTURISTIC FLOATING NAVBAR
  Widget _buildFuturisticBottomNav() {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, bottom: 24),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05), // Light frosted base
        borderRadius: BorderRadius.circular(35),
        border: Border.all(color: Colors.white.withOpacity(0.15), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 25,
            offset: const Offset(0, 10),
          ),
          BoxShadow(
            color: AppColors.cyan.withOpacity(0.05), // Subtle cyan glow base
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
              _buildNavItem(Icons.dashboard_rounded, 'Dashboard', true),
              _buildNavItem(Icons.map_outlined, 'Map', false),
              _buildNavItem(Icons.list_alt_rounded, 'Resources', false),
              _buildNavItem(Icons.notifications_outlined, 'Alerts', false),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, bool isActive) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon, 
            color: isActive ? AppColors.cyan : Colors.white.withOpacity(0.5), 
            size: isActive ? 28 : 24
          ),
          const SizedBox(height: 6),
          if (isActive)
            Container(
              width: 18,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.cyan,
                borderRadius: BorderRadius.circular(2),
                boxShadow: [
                  BoxShadow(color: AppColors.cyan, blurRadius: 10, spreadRadius: 2), // Neon underline glow
                ],
              ),
            )
          else
            Text(label, style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 11, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}

// Extension to handle Active state of chips
extension ActiveStateModifier on Widget {
  Widget wrapWithActiveState(bool isActive) {
    if (!isActive) return this;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white, 
        borderRadius: BorderRadius.circular(30),
        boxShadow: [BoxShadow(color: Colors.white.withOpacity(0.3), blurRadius: 15)],
      ),
      child: this,
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  PAINTERS
// ─────────────────────────────────────────────────────────────
class NeonChartPainter extends CustomPainter {
  final Color color;
  NeonChartPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();
    path.moveTo(0, size.height * 0.7);
    path.quadraticBezierTo(size.width * 0.25, size.height * 0.9, size.width * 0.5, size.height * 0.5);
    path.quadraticBezierTo(size.width * 0.75, size.height * 0.1, size.width, size.height * 0.4);

    canvas.drawPath(path, paint);
    
    final glowPaint = Paint()
      ..color = color.withOpacity(0.4)
      ..strokeWidth = 6.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4.0);
      
    canvas.drawPath(path, glowPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Subtle Grid Map Painter
class GridMapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.05)
      ..strokeWidth = 1;

    for (double i = 0; i < size.width; i += 20) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }
    for (double i = 0; i < size.height; i += 20) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}