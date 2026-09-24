import 'package:flutter/material.dart';

class HeartsBadge extends StatelessWidget {
  final int hearts;

  const HeartsBadge({super.key, required this.hearts});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white24,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.favorite,
            color: hearts > 0 ? Colors.redAccent : Colors.white38,
            size: 20,
          ),
          const SizedBox(width: 4),
          Text(
            '$hearts',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}