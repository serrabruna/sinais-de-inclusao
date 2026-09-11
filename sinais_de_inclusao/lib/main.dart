// lib/main.dart

import 'package:flutter/material.dart';
import 'package:sinais_de_inclusao/modules/atividades/atividade_page.dart';
import 'package:sinais_de_inclusao/modules/categoria/edicao_categoria.dart';
import 'package:sinais_de_inclusao/modules/categoria/cadastro_categoria.dart';
import 'package:sinais_de_inclusao/modules/cadastro/cadastro_page.dart';
import 'package:sinais_de_inclusao/modules/categoria/excluir_categoria.dart';
import 'package:sinais_de_inclusao/modules/home/home_page.dart';
import 'package:sinais_de_inclusao/modules/listarQuestoes/listagem_questoes_page.dart';
import 'package:sinais_de_inclusao/modules/login/login_page.dart';
import 'package:sinais_de_inclusao/modules/questoes/edicao_questao.dart';
import 'package:sinais_de_inclusao/modules/questoes/cadastro_questao.dart';
import 'package:sinais_de_inclusao/modules/questoes/excluir_questao.dart';
import 'package:sinais_de_inclusao/modules/sinais/sinais_page.dart';
import 'package:sinais_de_inclusao/modules/temas/tema_page.dart';
import 'package:sinais_de_inclusao/modules/trilha/trilha_page.dart';

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
      initialRoute: '/home',
      routes: {
        '/login': (context) => const LoginPage(),
        '/cadastro': (context) => const CadastroPage(),
        '/home': (context) => const HomePage(),
        '/cadastro-categoria': (context) => const CadastroCategoriaPage(),
        '/edicao-categoria': (context) => const EdicaoCategoriaPage(),
        '/temas': (context) => const TemasPage(),
        '/listagem_questoes': (context) => const ListagemQuestoesPage(),
        '/cadastro-questao': (context) => const CadastroQuestaoPage(),
        '/trilha': (context) => const TrilhaPage()
      }
    );
  }
}