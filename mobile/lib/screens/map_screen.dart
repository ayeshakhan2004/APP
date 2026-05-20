import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/data_providers.dart';

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

class CrisisMapScreen extends ConsumerStatefulWidget {
  const CrisisMapScreen({super.key});

  @override
  ConsumerState<CrisisMapScreen> createState() => _CrisisMapScreenState();
}

class _CrisisMapScreenState extends ConsumerState<CrisisMapScreen> {
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
    // Watch crises to build markers
    final crisesAsync = ref.watch(crisesProvider);

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: crisesAsync.when(
        data: (crises) {
          final Set<Marker> dynamicMarkers = {};
          for (var crisis in crises) {
            try {
              final loc = crisis['location'];
              if (loc != null && loc is Map) {
                final lat = double.tryParse(loc['lat'].toString());
                final lng = double.tryParse(loc['lng'].toString());
                if (lat != null && lng != null) {
                  final severity = crisis['severity']?.toString().toUpperCase() ?? 'WARNING';
                  final type = crisis['type']?.toString().toUpperCase() ?? 'CRISIS';
                  dynamicMarkers.add(
                    Marker(
                      markerId: MarkerId(crisis['id']?.toString() ?? DateTime.now().toString()),
                      position: LatLng(lat, lng),
                      infoWindow: InfoWindow(title: '$type', snippet: 'Severity: $severity'),
                      icon: BitmapDescriptor.defaultMarkerWithHue(
                        severity == 'CRITICAL' || severity == 'HIGH' ? BitmapDescriptor.hueRed : BitmapDescriptor.hueOrange
                      ),
                    ),
                  );
                }
              }
            } catch (e) {
              // Ignore invalid location parsing
            }
          }

          return GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: _kIslamabad,
            markers: dynamicMarkers,
            polylines: _polylines,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            onMapCreated: (GoogleMapController controller) {
              if (!_controller.isCompleted) {
                _controller.complete(controller);
              }
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator(color: AppTheme.cyan)),
        error: (err, stack) => Center(child: Text('Error: $err', style: const TextStyle(color: Colors.red))),
      ),
    );
  }
}