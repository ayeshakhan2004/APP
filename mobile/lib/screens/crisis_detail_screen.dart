import 'package:flutter/material.dart';

class CrisisDetailScreen extends StatelessWidget {
  final Map<String, dynamic> crisis;

  const CrisisDetailScreen({super.key, required this.crisis});

  @override
  Widget build(BuildContext context) {
    final severityColor = _getSeverityColor(crisis['severity'] ?? 'low');

    return Scaffold(
      appBar: AppBar(
        title: Text('${crisis['type']?.toUpperCase() ?? 'CRISIS'} DETAIL'),
        backgroundColor: severityColor.withOpacity(0.8),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(severityColor),
            const SizedBox(height: 20),
            _buildSectionTitle('Affected Area'),
            Text(crisis['location']?['area_name'] ?? 'Islamabad',
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 20),
            _buildSectionTitle('Severity & Confidence'),
            Row(
              children: [
                _buildChip(
                    crisis['severity']?.toUpperCase() ?? 'LOW', severityColor),
                const SizedBox(width: 10),
                _buildChip(
                    'CONFIDENCE: ${(((crisis['confidence_score'] as num?) ?? 0.0) * 100).toInt()}%',
                    Colors.blueGrey),
              ],
            ),
            const SizedBox(height: 20),
            _buildSectionTitle('Predicted Evolution'),
            const Text(
                '• Peak impact expected in 2 hours\n• Potential spread to neighboring sectors\n• Estimated duration: 6 hours',
                style: TextStyle(fontSize: 15)),
            const SizedBox(height: 20),
            _buildSectionTitle('Assigned Resources'),
            const ListTile(
              leading: Icon(Icons.medical_services, color: Colors.redAccent),
              title: Text('Ambulance #04 (En Route)'),
              trailing: Text('ETA: 8m'),
            ),
            const SizedBox(height: 20),
            _buildSectionTitle('AI Logic (Traces)'),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white10,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'Reasoning: Detected contradiction between social media and IoT sensor. Overrode flood alert with pipe burst classification based on 0.92 credibility score of pressure sensor.',
                style:
                    TextStyle(fontStyle: FontStyle.italic, color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(Color color) {
    return Container(
      height: 150,
      width: double.infinity,
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color, width: 2),
      ),
      child: Icon(Icons.warning_amber_rounded, size: 80, color: color),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(title,
          style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.redAccent)),
    );
  }

  Widget _buildChip(String label, Color color) {
    return Chip(
      label: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
      backgroundColor: color.withOpacity(0.2),
      side: BorderSide(color: color),
    );
  }

  Color _getSeverityColor(String severity) {
    switch (severity.toLowerCase()) {
      case 'critical':
        return Colors.red;
      case 'high':
        return Colors.orange;
      case 'moderate':
        return Colors.yellow;
      default:
        return Colors.green;
    }
  }
}
