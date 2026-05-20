import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/api_service.dart';

final apiServiceProvider = Provider((ref) => ApiService());

final crisesProvider = FutureProvider<List<dynamic>>((ref) async {
  final api = ref.read(apiServiceProvider);
  final result = await api.getCrises(); 
  return result['crises'] ?? [];
});

final resourcesProvider = FutureProvider<List<dynamic>>((ref) async {
  final api = ref.read(apiServiceProvider);
  final result = await api.getResources();
  return result['resources'] ?? [];
});

final notificationsProvider = FutureProvider<List<dynamic>>((ref) async {
  final api = ref.read(apiServiceProvider);
  final result = await api.getNotifications();
  return result['notifications'] ?? [];
});

final allocationsProvider = FutureProvider<List<dynamic>>((ref) async {
  final api = ref.read(apiServiceProvider);
  final result = await api.getAllocations();
  return result['allocations'] ?? [];
});
