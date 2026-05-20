import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/data_providers.dart';

// ─────────────────────────────────────────────────────────────
//  THEME COLORS (Matched with CIRO Theme)
// ─────────────────────────────────────────────────────────────
class AppTheme {
  static const cyan = Color(0xFF00E5FF);
  static const background = Color(0xFF0F172A);
  static const sosRed = Color(0xFFFF2A5F);
  static const green = Color(0xFF00E676);
  static const yellow = Color(0xFFFFD54F);
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
          BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 15, offset: const Offset(0, 5)),
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
              border: Border.all(color: borderColor ?? Colors.white.withOpacity(0.15), width: 1.2),
              gradient: LinearGradient(
                begin: Alignment.topLeft, end: Alignment.bottomRight,
                colors: [Colors.white.withOpacity(0.1), Colors.white.withOpacity(0.02)],
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
//  ALERT FEED SCREEN
// ─────────────────────────────────────────────────────────────
class AlertFeedScreen extends ConsumerStatefulWidget {
  const AlertFeedScreen({super.key});

  @override
  ConsumerState<AlertFeedScreen> createState() => _AlertFeedScreenState();
}

class _AlertFeedScreenState extends ConsumerState<AlertFeedScreen> {
  String activeFilter = 'All';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Stack(
        children: [
          // Background Glows
          Positioned(
            top: -50, right: -50,
            child: Container(
              width: 250, height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle, color: AppTheme.sosRed.withOpacity(0.15),
                boxShadow: [BoxShadow(color: AppTheme.sosRed.withOpacity(0.15), blurRadius: 100, spreadRadius: 40)],
              ),
            ),
          ),
          Positioned(
            bottom: 100, left: -80,
            child: Container(
              width: 200, height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle, color: AppTheme.cyan.withOpacity(0.1),
                boxShadow: [BoxShadow(color: AppTheme.cyan.withOpacity(0.1), blurRadius: 80, spreadRadius: 30)],
              ),
            ),
          ),

          SafeArea(
            bottom: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Header Area
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // FIXED: Wrapped in Expanded taake text push na ho
                      const Expanded(
                        child: Text(
                          'Stakeholder\nAlerts Feed',
                          style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w800, height: 1.1),
                        ),
                      ),
                      const SizedBox(width: 10),
                      // Notification Bell
                      Stack(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.05),
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white.withOpacity(0.2)),
                            ),
                            child: const Icon(Icons.notifications_active_outlined, color: Colors.white),
                          ),
                          Positioned(
                            right: 0, top: 0,
                            child: Container(
                              width: 12, height: 12,
                              decoration: BoxDecoration(color: AppTheme.sosRed, shape: BoxShape.circle, border: Border.all(color: AppTheme.background, width: 2)),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),

                // 2. Interactive Filter Chips
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Row(
                    children: [
                      _buildFilterChip('All'),
                      _buildFilterChip('Critical'),
                      _buildFilterChip('Public'),
                      _buildFilterChip('Medical'),
                    ],
                  ),
                ),
                const SizedBox(height: 10),

                // 3. Alerts List
                Expanded(
                  child: ref.watch(notificationsProvider).when(
                    data: (notifications) {
                      if (notifications.isEmpty) {
                        return const Center(child: Text("No stakeholder alerts at this time.", style: TextStyle(color: Colors.white54)));
                      }

                      return ListView.builder(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 120),
                        itemCount: notifications.length,
                        itemBuilder: (context, index) {
                          final notif = notifications[index];
                          
                          // Parse backend data
                          final message = notif['message'] ?? 'Alert message not provided.';
                          final channel = notif['channel'] ?? 'General';
                          final status = notif['status'] ?? 'pending';
                          
                          // Default UI bindings
                          String severityLabel = 'High';
                          Color accent = AppTheme.cyan;
                          IconData icon = Icons.notifications_active_rounded;
                          
                          if (channel.toString().toLowerCase().contains('medical') || channel.toString().toLowerCase().contains('hospital')) {
                            severityLabel = 'Critical';
                            accent = AppTheme.sosRed;
                            icon = Icons.medical_services_rounded;
                          } else if (channel.toString().toLowerCase().contains('public')) {
                            severityLabel = 'Warning';
                            accent = AppTheme.yellow;
                            icon = Icons.campaign_rounded;
                          } else if (status.toString().toLowerCase() == 'sent') {
                            severityLabel = 'Info';
                            accent = AppTheme.green;
                            icon = Icons.check_circle_rounded;
                          }

                          // Simple filtering
                          if (activeFilter != 'All' && 
                              !severityLabel.toLowerCase().contains(activeFilter.toLowerCase()) &&
                              !channel.toString().toLowerCase().contains(activeFilter.toLowerCase())) {
                            return const SizedBox.shrink();
                          }

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            child: _buildAlertTile(
                              title: channel.toString().toUpperCase(),
                              description: message,
                              timeAgo: 'Just now', // Could be parsed from created_at
                              icon: icon,
                              accentColor: accent,
                              severity: severityLabel,
                            ),
                          );
                        },
                      );
                    },
                    loading: () => const Center(child: CircularProgressIndicator(color: AppTheme.cyan)),
                    error: (err, stack) => Center(child: Text('Error: $err', style: const TextStyle(color: Colors.red))),
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
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), // Padding thori kam ki
        decoration: BoxDecoration(
          color: isActive ? AppTheme.cyan : Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: isActive ? AppTheme.cyan : Colors.white.withOpacity(0.15)),
          boxShadow: isActive ? [BoxShadow(color: AppTheme.cyan.withOpacity(0.3), blurRadius: 10)] : [],
        ),
        child: Text(
          label,
          style: TextStyle(color: isActive ? AppTheme.background : Colors.white, fontWeight: FontWeight.w600, fontSize: 13),
        ),
      ),
    );
  }

  Widget _buildAlertTile({
    required String title,
    required String description,
    required String timeAgo,
    required IconData icon,
    required Color accentColor,
    required String severity,
  }) {
    Color severityBgColor = (severity == 'Critical' || severity == 'High') 
        ? AppTheme.sosRed.withOpacity(0.15) 
        : (severity == 'Warning' ? AppTheme.yellow.withOpacity(0.15) : Colors.white.withOpacity(0.1));

    return FrostedGlassCard(
      padding: const EdgeInsets.all(16),
      borderColor: severity == 'Critical' ? AppTheme.sosRed.withOpacity(0.5) : null,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left Icon Box
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: accentColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: accentColor.withOpacity(0.3)),
            ),
            child: Icon(icon, color: accentColor, size: 24),
          ),
          const SizedBox(width: 12),
          
          // Right Content Area
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold, height: 1.2)),
                const SizedBox(height: 6),
                Text(description, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12, height: 1.4)),
                const SizedBox(height: 12),
                
                // FIXED: Row ki jagah Wrap use kiya taake choti screen par overflow na ho
                Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 10,
                  runSpacing: 8,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: severityBgColor,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: accentColor.withOpacity(0.3)),
                      ),
                      child: Text(severity.toUpperCase(), style: TextStyle(color: accentColor, fontSize: 9, fontWeight: FontWeight.w800, letterSpacing: 0.5)),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.access_time_rounded, color: Colors.white.withOpacity(0.4), size: 12),
                        const SizedBox(width: 4),
                        Text(timeAgo, style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 11, fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}