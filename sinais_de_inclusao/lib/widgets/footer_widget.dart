import 'package:flutter/material.dart';

class FooterWidget extends StatelessWidget {
  const FooterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18.0),
      color: const Color(0xFF152763),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: const [
          Text(
            'Fale Conosco!',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 22),

          Text(
            'Localização',
            style: TextStyle(
              color: Color(0xFFEDAD6B),
              fontSize: 22,
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 8),

          Text(
            'Boituva, São Paulo',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 22),

          Text(
            'Contato',
            style: TextStyle(
              color: Color(0xFFEDAD6B),
              fontSize: 22,
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 8),

          Text(
            'sinaisdeinclusao@gmail.com',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),

          Text(
            '+55 15 996941532',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),

        ],
      )
    );
  }
}