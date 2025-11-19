import 'package:flutter/material.dart';

class ProgressCard extends StatelessWidget {
  final String label;
  final double value;
  final Color color;

  const ProgressCard({
    super.key,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$label Progress",
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          LinearProgressIndicator(
            value: value,
            color: color,
            backgroundColor: Colors.grey[300],
            minHeight: 6,
          ),
        ],
      ),
    );
  }
}
