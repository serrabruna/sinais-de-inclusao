import 'package:flutter/material.dart';

class FullWidthButton extends StatelessWidget {
  //steteless pq ele nao atualiza, muda nada, apenas exibe
  final String titulo;
  final IconData icone;
  final VoidCallback onPressed;
  //função ou ação quanod clicar
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
      height: 55,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: const Color(0xFF623FBD),
          elevation: 2,
          //elevation é sombra 
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
            //altera a borda para um borda crsular 15
          ),
        ),
        icon: Icon(icone),
        label: Text(
          titulo,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
    );
  }
}