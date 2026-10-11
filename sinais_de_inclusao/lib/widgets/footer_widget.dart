import 'package:flutter/material.dart';

class FooterWidget extends StatelessWidget {
  const FooterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: const Color(0xFFFFB76F),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const [
              Text(
                'Fale Conosco!',
                style: TextStyle(
                  color: Color(0xFF7458CF),
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 20),

              Text(
                'Localização',
                style: TextStyle(
                  color: Color(0xFF7458CF),
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: 8),

              Text(
                'Boituva, São Paulo',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),

              SizedBox(height: 22),

              Text(
                'Contato',
                style: TextStyle(
                  color: Color(0xFF7458CF),
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: 8),

              Text(
                'sinaisdeinclusao@gmail.com',
                style: TextStyle(color: Colors.white, fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}