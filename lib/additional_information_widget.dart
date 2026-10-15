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
        Icon(icon),
        SizedBox(height: 10),
        Text(condition),
        SizedBox(height: 10),
        Text(level),
      ],
    );
  }
}
