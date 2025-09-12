// lib/main.dart

import 'package:flutter/material.dart';
import 'package:sinais_de_inclusao/modules/home/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Minha Aplicação Flutter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(), 
    );
  }
}