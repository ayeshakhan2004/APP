import 'dart:ui';
import 'package:flutter/material.dart';

// ─────────────────────────────────────────────────────────────
//  THEME COLORS (Matched with your CIRO Theme)
// ─────────────────────────────────────────────────────────────
class AppTheme {
  static const cyan = Color(0xFF00E5FF);
  static const background = Color(0xFF0F172A);
  static const sosRed = Color(0xFFFF2A5F);
  static const green = Color(0xFF00E676);
  static const textSecondary = Color(0xFFCBD5E1);
}

// ─────────────────────────────────────────────────────────────
//  FROSTED GLASS CARD COMPONENT
// ─────────────────────────────────────────────────────────────
class FrostedGlassCard extends StatelessWidget {
  final Widget child;
  final double radius;
  final EdgeInsets padding;
  final Color? borderColor;
  final Color? backgroundColor;

  const FrostedGlassCard({
    super.key,
    required this.child,
    this.radius = 20, 
    this.padding = const EdgeInsets.all(16),
    this.borderColor,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              color: backgroundColor ?? Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(radius),
              border: Border.all(
                color: borderColor ?? Colors.white.withOpacity(0.15),
                width: 1.2,
              ),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withOpacity(0.1),
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
//  RESOURCE LIST SCREEN
// ─────────────────────────────────────────────────────────────
class ResourceListScreen extends StatefulWidget {
  const ResourceListScreen({super.key});

  @override
  State<ResourceListScreen> createState() => _ResourceListScreenState();
}

class _ResourceListScreenState extends State<ResourceListScreen> {
  // Simple state to toggle active filter
  String activeFilter = 'All';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Stack(
        children: [
          // 1. FIXED: Background subtle glows using BoxShadow instead of ImageFilter
          Positioned(
            top: 50,
            left: -50,
            child: Container(
              width: 200, 
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle, 
                color: AppTheme.cyan.withOpacity(0.1),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.cyan.withOpacity(0.15), 
                    blurRadius: 80, 
                    spreadRadius: 30,
                  )
                ]
              ),
            ),
          ),
          
          SafeArea(
            bottom: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header & Search
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Emergency\nResources',
                        style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w800, height: 1.1),
                      ),
                      const SizedBox(height: 20),
                      
                      // Search Bar (Frosted)
                      FrostedGlassCard(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        radius: 30,
                        child: TextField(
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: 'Search units, vehicles...',
                            hintStyle: const TextStyle(color: AppTheme.textSecondary),
                            border: InputBorder.none,
                            icon: Icon(Icons.search, color: Colors.white.withOpacity(0.5)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Category Filter Chips
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Row(
                    children: [
                      _buildFilterChip('All'),
                      _buildFilterChip('Medical'),
                      _buildFilterChip('Police'),
                      _buildFilterChip('Fire/Rescue'),
                    ],
                  ),
                ),

                // Resource List
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 120), // Bottom padding for global navbar
                    children: [
                      _buildResourceTile(
                        name: 'Ambulance #1',
                        status: 'Available',
                        location: 'Station 4',
                        icon: Icons.medical_services_rounded,
                        color: AppTheme.green,
                        isExpanded: false,
                      ),
                      const SizedBox(height: 16),
                      
                      // THIS IS THE ACTIVE / EXPANDED TILE
                      _buildResourceTile(
                        name: 'Rescue Team Alpha',
                        status: 'Deployed',
                        location: 'Sector G-10',
                        icon: Icons.security_rounded,
                        color: AppTheme.sosRed,
                        isExpanded: true, 
                      ),
                      const SizedBox(height: 16),

                      _buildResourceTile(
                        name: 'Police Unit 04',
                        status: 'Available',
                        location: 'Highway Patrol',
                        icon: Icons.local_police_rounded,
                        color: AppTheme.green,
                        isExpanded: false,
                      ),
                      const SizedBox(height: 16),

                      _buildResourceTile(
                        name: 'Water Tanker',
                        status: 'Deployed',
                        location: 'Sector G-7',
                        icon: Icons.water_drop_rounded,
                        color: AppTheme.sosRed,
                        isExpanded: false,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  //  WIDGET BUILDERS
  // ─────────────────────────────────────────────────────────────

  Widget _buildFilterChip(String label) {
    bool isActive = activeFilter == label;
    return GestureDetector(
      onTap: () => setState(() => activeFilter = label),
      child: Container(
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isActive ? AppTheme.cyan : Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: isActive ? AppTheme.cyan : Colors.white.withOpacity(0.15)),
          boxShadow: isActive ? [BoxShadow(color: AppTheme.cyan.withOpacity(0.3), blurRadius: 10)] : [],
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isActive ? AppTheme.background : Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildResourceTile({
    required String name,
    required String status,
    required String location,
    required IconData icon,
    required Color color,
    required bool isExpanded,
  }) {
    bool isAvailable = status == 'Available';

    return FrostedGlassCard(
      borderColor: isExpanded ? AppTheme.cyan.withOpacity(0.6) : null,
      backgroundColor: isExpanded ? AppTheme.cyan.withOpacity(0.05) : null,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              // Glowing Icon Box
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: color.withOpacity(0.3)),
                  boxShadow: [BoxShadow(color: color.withOpacity(0.2), blurRadius: 10)],
                ),
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(width: 16),
              
              // Text Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.location_on, color: AppTheme.textSecondary.withOpacity(0.8), size: 14),
                        const SizedBox(width: 4),
                        Text(location, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13)),
                      ],
                    ),
                  ],
                ),
              ),

              // Status Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: isAvailable ? AppTheme.green.withOpacity(0.1) : AppTheme.sosRed.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: isAvailable ? AppTheme.green.withOpacity(0.5) : AppTheme.sosRed.withOpacity(0.5)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6, height: 6,
                      decoration: BoxDecoration(shape: BoxShape.circle, color: isAvailable ? AppTheme.green : AppTheme.sosRed),
                    ),
                    const SizedBox(width: 6),
                    Text(status, style: TextStyle(color: isAvailable ? AppTheme.green : AppTheme.sosRed, fontSize: 12, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ],
          ),
          
          // EXPANDED DETAILS (Only shows if isExpanded is true)
          if (isExpanded) ...[
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildDetailItem('ETA', '10:45 PM', Icons.access_time),
                      _buildDetailItem('Crew', '4 Members', Icons.group),
                      _buildDetailItem('Contact', 'Radio Ch. 4', Icons.headset_mic),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Mock Progress Bar
                  Stack(
                    children: [
                      Container(height: 4, decoration: BoxDecoration(color: Colors.white.withOpacity(0.1), borderRadius: BorderRadius.circular(2))),
                      Container(height: 4, width: 150, decoration: BoxDecoration(color: AppTheme.cyan, borderRadius: BorderRadius.circular(2), boxShadow: [BoxShadow(color: AppTheme.cyan.withOpacity(0.5), blurRadius: 6)])),
                    ],
                  ),
                ],
              ),
            ),
          ]
        ],
      ),
    );
  }

  Widget _buildDetailItem(String label, String value, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 12, color: AppTheme.textSecondary),
            const SizedBox(width: 4),
            Text(label, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
          ],
        ),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
      ],
    );
  }
}