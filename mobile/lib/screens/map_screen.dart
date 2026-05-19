import 'dart:async';
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

  // Markers and Polylines cleared for backend integration
  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      // Ab yahan sirf Map hai, koi faltu UI nahi
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: _kIslamabad,
        markers: _markers,
        polylines: _polylines,
        myLocationEnabled: true,
        myLocationButtonEnabled: false,
        zoomControlsEnabled: false, // Zoom buttons disabled for a cleaner look
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
    );
  }
}