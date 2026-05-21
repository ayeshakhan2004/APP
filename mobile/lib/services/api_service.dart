import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // Change this to your exact live backend string
  static const String baseUrl =
      "https://app-1038267469008.europe-west1.run.app/docs";

  Future<Map<String, dynamic>> getSignals() async {
    final response = await http.get(Uri.parse('$baseUrl/signals'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load signals');
    }
  }

  Future<Map<String, dynamic>> getCrises() async {
    final response = await http.get(Uri.parse('$baseUrl/crises'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load crises');
    }
  }

  Future<Map<String, dynamic>> getResources() async {
    final response = await http.get(Uri.parse('$baseUrl/resources'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load resources');
    }
  }

  Future<Map<String, dynamic>> runPipeline() async {
    final response = await http.post(Uri.parse('$baseUrl/pipeline/run'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to run AI pipeline');
    }
  }

  Future<List<dynamic>> getTraces() async {
    final response = await http.get(Uri.parse('$baseUrl/traces'));
    if (response.statusCode == 200) {
      return json.decode(response.body)['traces'];
    } else {
      throw Exception('Failed to load traces');
    }
  }

  Future<Map<String, dynamic>> getNotifications() async {
    final response = await http.get(Uri.parse('$baseUrl/notifications'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load notifications');
    }
  }

  Future<Map<String, dynamic>> getAllocations() async {
    final response = await http.get(Uri.parse('$baseUrl/allocations'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load allocations');
    }
  }
}
