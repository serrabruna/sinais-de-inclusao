import 'package:flutter/material.dart';

class MenuButton extends StatelessWidget {
  final String titulo;
  final IconData icone;
  final VoidCallback onPressed;

  const MenuButton({
    super.key,
    required this.titulo,
    required this.icone,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFFFB76F),
        foregroundColor: Colors.black,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        padding: EdgeInsets.zero,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icone,
            size: 45,
            color: const Color(0xFF623FBD),
          ),

          const SizedBox(height: 8),

          Text(
            titulo,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}