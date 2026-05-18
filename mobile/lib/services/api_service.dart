import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://10.0.2.2:8000/api'; // Use 10.0.2.2 for Android Emulator

  Future<Map<String, dynamic>> getSignals() async {
    final response = await http.get(Uri.parse('$baseUrl/signals'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load signals');
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
}
