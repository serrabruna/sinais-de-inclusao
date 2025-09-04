// lib/screens/home_page.dart

import 'package:flutter/material.dart';
import 'package:sinais_de_inclusao/widgets/header_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: const [
          HeaderWidget(),
          
          Expanded(
            child: Center(
              child: Text('Conteúdo da Página'),
            ),
          ),
        ],
      ),
    );
  }
}