// lib/main.dart

import 'package:flutter/material.dart';
import 'package:sinais_de_inclusao/modules/categoria/edicao_categoria.dart';
import 'package:sinais_de_inclusao/modules/categoria/cadastro_categoria.dart';
import 'package:sinais_de_inclusao/modules/cadastro/cadastro_page.dart';
import 'package:sinais_de_inclusao/modules/home/home_page.dart';
import 'package:sinais_de_inclusao/modules/login/login_page.dart';

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
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFFB76F),
        ),
      ),
      home: const CadastroCategoriaPage(), 
    );
  }
}