import 'package:flutter/material.dart';

class AlertFeedScreen extends StatelessWidget {
  const AlertFeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Stakeholder Alerts')),
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: const [
          Card(
            child: ListTile(
              title: Text('Public Alert: G-10 Flooding'),
              subtitle: Text('Immediate action: Avoid main roads in G-10.'),
              trailing: Text('2m ago'),
            ),
          ),
          Card(
            child: ListTile(
              title: Text('Hospital Notice: Heatwave Surge'),
              subtitle: Text('PIMS Hospital alerted for 50+ heatstroke cases.'),
              trailing: Text('15m ago'),
            ),
          ),
        ],
      ),
    );
  }
}
