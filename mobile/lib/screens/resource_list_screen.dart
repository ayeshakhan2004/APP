import 'package:flutter/material.dart';

class ResourceListScreen extends StatelessWidget {
  const ResourceListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Emergency Resources')),
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: [
          _buildResourceTile('Ambulance #1', 'Available', Colors.green),
          _buildResourceTile('Rescue Team Alpha', 'Deployed (G-10)', Colors.red),
          _buildResourceTile('Police Unit 04', 'Available', Colors.green),
          _buildResourceTile('Water Tanker', 'Deployed (G-7)', Colors.red),
        ],
      ),
    );
  }

  Widget _buildResourceTile(String name, String status, Color color) {
    return Card(
      child: ListTile(
        leading: Icon(Icons.local_hospital, color: color),
        title: Text(name),
        subtitle: Text(status),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}
