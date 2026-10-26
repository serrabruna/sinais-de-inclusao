// lib/screens/home_page.dart

import 'package:flutter/material.dart';
import 'package:sinais_de_inclusao/widgets/banner_widget.dart';
import 'package:sinais_de_inclusao/widgets/footer_widget.dart';
import 'package:sinais_de_inclusao/widgets/gradient_background.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        backgroundColor: const Color(0xFF9475EF),
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: const DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF9475EF), Color(0xFF45239B)],
            ),
          ),
        ),
        title: Image.asset('assets/images/logocirculo.png', height: 70),
      ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GradientBackground(
              child: Column(
                children: [
                  BannerWidget(),
                  Image.asset('assets/images/ImagemTemas.png'),
                ],
              ),
            ),

            const SizedBox(height: 32),
            Center(
              child: Text(
                'Aprenda de um jeito diferente!',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF7458CF),
                ),
                textAlign: TextAlign.center,
              ),
            ),

            SizedBox(height: 18),

            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Aprenda Conosco!',
                  style: TextStyle(fontSize: 24, color: Color(0xFF7458CF)),
                  textAlign: TextAlign.center,
                ),
              ),
            ),

            SizedBox(height: 20),

            Center(
              child: Image.asset(
                'assets/images/ImagemSinais.png',
                height: 280,
                width: 320,
              ),
            ),

            SizedBox(height: 4),

            Center(
              child: Image.asset(
                'assets/images/ImagemAtividade.png',
                height: 280,
                width: 320,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  debugPrint('Erro ao carregar imagem: $error');
                  return const Text('Erro ao carregar imagem');
                },
              ),
            ),

            SizedBox(height: 4),

            Center(
              child: Image.asset(
                'assets/images/ImagemParabenizacao.png',
                height: 280,
                width: 320,
              ),
            ),

            SizedBox(height: 4),

            Center(
              child: Image.asset(
                'assets/images/ImagemPratica.png',
                height: 280,
                width: 320,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  debugPrint('Erro ao carregar imagem: $error');
                  return const Text('Erro ao carregar imagem');
                },
              ),
            ),
            SizedBox(height: 40),

            FooterWidget(),
          ],
        ),
      ),
    );
  }
}
