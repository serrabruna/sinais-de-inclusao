
import 'package:flutter/material.dart';

class MenuButton extends StatelessWidget {
  final String titulo;
  final IconData icone;
  final VoidCallback onPressed;
  final bool usarGradiente;

  const MenuButton({
    super.key,
    required this.titulo,
    required this.icone,
    required this.onPressed,
    this.usarGradiente = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: usarGradiente
            ? const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFFFFCB98),
                  Color(0xFFFFB46E)
                ],
              )
            : null,
        color: usarGradiente
            ? null
            : const Color(0xFFFFB46E),
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.black,
          shadowColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
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
                color:  const Color(0xFF623FBD),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
