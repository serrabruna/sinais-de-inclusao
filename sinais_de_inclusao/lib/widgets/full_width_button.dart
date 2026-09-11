import 'package:flutter/material.dart';

class FullWidthButton extends StatelessWidget {
  final String titulo;
  final IconData icone;
  final VoidCallback onPressed;

  const FullWidthButton({
    super.key,
    required this.titulo,
    required this.icone,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 65,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFFB46E),
          foregroundColor: const Color(0xFF623FBD),

          elevation: 6,
          shadowColor: Colors.black38,

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),

          padding: const EdgeInsets.symmetric(horizontal: 20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Círculo do ícone
            Container(
              width: 38,
              height: 38,
              decoration: const BoxDecoration(
                color: Color.fromARGB(159, 255, 255, 255),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.play_arrow_rounded,
                color: Color(0xFF623FBD),
                size: 28,
              ),
            ),

            const SizedBox(width: 12),

            Text(
              titulo,
              style: const TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
                color: Color(0xFF623FBD),
              ),
            ),
          ],
        ),
      ),
    );
  }
}