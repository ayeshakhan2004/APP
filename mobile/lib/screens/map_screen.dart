import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

// ─────────────────────────────────────────────────────────────
//  THEME COLORS (Matched with Dashboard)
// ─────────────────────────────────────────────────────────────
class AppTheme {
  static const cyan = Color(0xFF00E5FF);
  static const background = Color(0xFF0F172A);
  static const sosRed = Color(0xFFFF2A5F);
  static const green = Color(0xFF00E676);
  static const textSecondary = Color(0xFFCBD5E1);
}

class CrisisMapScreen extends StatefulWidget {
  const CrisisMapScreen({super.key});

  @override
  State<CrisisMapScreen> createState() => _CrisisMapScreenState();
}

class _CrisisMapScreenState extends State<CrisisMapScreen> {
  final Completer<GoogleMapController> _controller = Completer();

  // Initial Camera Position: Islamabad
  static const CameraPosition _kIslamabad = CameraPosition(
    target: LatLng(33.6844, 73.0479),
    zoom: 14.5,
  );

  // Mock Data: Markers
  final Set<Marker> _markers = {
    // Crisis Marker (Red)
    Marker(
      markerId: const MarkerId('crisis_1'),
      position: const LatLng(33.6930, 73.0600),
      infoWindow: const InfoWindow(title: 'Sector F-8', snippet: 'Medical Emergency'),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    ),
    // Resource Marker (Green)
    Marker(
      markerId: const MarkerId('resource_1'),
      position: const LatLng(33.6750, 73.0400),
      infoWindow: const InfoWindow(title: 'Ambulance 04', snippet: 'En Route'),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
    ),
  };

  // Mock Data: Active Route (Polyline)
  final Set<Polyline> _polylines = {
    Polyline(
      polylineId: const PolylineId('route_1'),
      color: AppTheme.sosRed, // Route line color
      width: 5,
      points: const [
        LatLng(33.6750, 73.0400),
        LatLng(33.6800, 73.0450),
        LatLng(33.6880, 73.0550),
        LatLng(33.6930, 73.0600),
      ],
    ),
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Stack(
        children: [ 
          // 1. THE GOOGLE MAP
          GoogleMap(
            mapType: MapType.normal, // Dark mode map styling can be added via JSON here
            initialCameraPosition: _kIslamabad,
            markers: _markers,
            polylines: _polylines,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
          ),

          // 2. TOP FLOATING CARDS (Direction & Status)
          Positioned(
            top: 50,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Left: Direction Pill (like the reference image)
                _buildFrostedCard(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.turn_left_rounded, color: AppTheme.sosRed, size: 28),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text('500 m', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                          Text('Sector F-8 Markaz', style: TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
                        ],
                      ),
                    ],
                  ),
                ),
                
                // Top Right: Status Button
                _buildFrostedCard(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  backgroundColor: AppTheme.background.withOpacity(0.8),
                  borderColor: AppTheme.cyan.withOpacity(0.5),
                  child: const Text('Active Rescue', style: TextStyle(color: AppTheme.cyan, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),

          // 3. BOTTOM ETA & PROGRESS CARD
          Positioned(
            bottom: 120, // Placed above the global bottom nav bar
            left: 20,
            right: 20,
            child: _buildFrostedCard(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Stats Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildBottomStat('2.4 km', 'Distance'),
                      _buildBottomStat('8 min', 'Time'),
                      _buildBottomStat('10:05 PM', 'ETA'),
                    ],
                  ),
                  const SizedBox(height: 20),
                  
                  // Progress Bar Wrapper
                  Stack(
                    alignment: Alignment.centerLeft,
                    children: [
                      // Background Track
                      Container(
                        height: 6,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                      // Active Progress
                      Container(
                        height: 6,
                        width: MediaQuery.of(context).size.width * 0.4, // 40% progress
                        decoration: BoxDecoration(
                          color: AppTheme.sosRed,
                          borderRadius: BorderRadius.circular(3),
                          boxShadow: [
                            BoxShadow(color: AppTheme.sosRed.withOpacity(0.5), blurRadius: 8, spreadRadius: 1)
                          ],
                        ),
                      ),
                      // Slider Thumb / Car Indicator
                      Positioned(
                        left: (MediaQuery.of(context).size.width * 0.4) - 15,
                        child: Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 5)],
                          ),
                          child: const Icon(Icons.play_arrow_rounded, color: AppTheme.sosRed, size: 16),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  //  HELPER WIDGETS
  // ─────────────────────────────────────────────────────────────

  Widget _buildFrostedCard({
    required Widget child,
    required EdgeInsets padding,
    Color? backgroundColor,
    Color? borderColor,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: backgroundColor ?? Colors.white.withOpacity(0.08),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: borderColor ?? Colors.white.withOpacity(0.2),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }

  Widget _buildBottomStat(String value, String label) {
    return Column(
      children: [
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13, fontWeight: FontWeight.w500)),
      ],
    );
  }
}