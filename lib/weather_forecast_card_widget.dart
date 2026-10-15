import 'package:flutter/material.dart';

class WeatherForecastCardWidget extends StatelessWidget {
  final String temp;
  final IconData icon;
  final String time;
  const WeatherForecastCardWidget({
    super.key,
    required this.temp,
    required this.icon,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      child: Card(
        elevation: 10,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text(
                time,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 8),
              Icon(icon),
              SizedBox(height: 8),
              Text(temp, style: TextStyle(fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }
}
