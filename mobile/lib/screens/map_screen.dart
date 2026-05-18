import 'package:flutter/material.dart';

class CrisisMapScreen extends StatelessWidget {
  const CrisisMapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Crisis Map - Islamabad')),
      body: Stack(
        children: [
          const Center(child: Text('Google Maps Integration Here\n(G-10 & G-7 Active Zones)')),
          Positioned(
            bottom: 20,
            right: 20,
            child: FloatingActionButton(
              onPressed: () {},
              child: const Icon(Icons.refresh),
            ),
          )
        ],
      ),
    );
  }
}
