import 'package:flutter/material.dart';

class AdditionalInformationWidget extends StatelessWidget {
  final IconData icon;
  final String condition;
  final String level;
  const AdditionalInformationWidget({
    super.key,
    required this.icon,
    required this.condition,
    required this.level,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 32),
        const SizedBox(height: 8),
        Text(
          condition,
          style: const TextStyle(fontSize: 14),
        ),
        const SizedBox(height: 8),
        Text(
          level,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
