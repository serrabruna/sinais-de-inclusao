// lib/main.dart

import 'package:flutter/material.dart';
import 'package:sinais_de_inclusao/pages/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Minha Aplicação Flutter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // A página inicial da sua aplicação
      home: const HomePage(), 
    );
  }
}