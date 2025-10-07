// lib/screens/coming_soon_screen.dart

import 'package:flutter/material.dart';
import '../widgets/info_card.dart'; // InfoCard विजेट को इम्पोर्ट करें

class ComingSoonScreen extends StatelessWidget {
  final String featureName;
  final IconData icon;
  const ComingSoonScreen({super.key, required this.featureName, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: InfoCard(
          title: 'Coming Soon: $featureName',
          subtitle:
              'This feature is under development and will be available shortly.',
          icon: icon,
        ),
      ),
    );
  }
}
