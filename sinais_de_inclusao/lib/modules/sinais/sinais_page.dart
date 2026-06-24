import 'package:flutter/material.dart';
import 'package:sinais_de_inclusao/widgets/custom_app_bar.dart';
import 'package:sinais_de_inclusao/widgets/footer_widget.dart';

class SinaisPage extends StatefulWidget {
  final String nomeTema;
  const SinaisPage({super.key, required this.nomeTema});

  @override
  State<SinaisPage> createState() => _SinaisPageState();
}

class _SinaisPageState extends State<SinaisPage> {
  final List<dynamic> _sinaisExemplo = [
    {
      'id': 1,
      'categoryId': 1,
      'name': 'Cachorro',
      'statement':
          'Configuração de mão em rastro batendo levemente na perna ou estalando os dedos.',
      'imagePath': 'https://i.imgur.com/YfU2j3w.png',
    },
    {
      'id': 2,
      'categoryId': 1,
      'name': 'Gato',
      'statement':
          'Passar os dedos indicador e polegar ao lado do rosto, simulando os bigodes do gato.',
      'imagePath': 'https://i.imgur.com/YfU2j3w.png',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF623FBD),
      appBar: const CustomAppBar(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 25.0),
            child: Text(
              widget.nomeTema,
              style: const TextStyle(
                color: Color(0xFFFFB46E),
                fontSize: 36,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 22.0),
              itemCount: _sinaisExemplo.length,
              itemBuilder: (context, index) {
                final sinal = _sinaisExemplo[index];
                final String titulo = sinal['name'];
                final String descricao = sinal['statement'];
                final String urlImagem = sinal['imagePath'];

                return Padding(
                  padding: const EdgeInsets.only(bottom: 25.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF623FBD),
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: const Color.fromARGB(103, 0, 0, 0),
                          spreadRadius: 1,
                          blurRadius: 6,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          height: 200,
                          padding: const EdgeInsets.all(15),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(25),
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(25),
                            ),
                            child: Image.network(
                              urlImagem,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) {
                                return Image.asset(
                                  'assets/images/logocirculo.png',
                                  fit: BoxFit.contain,
                                );
                              },
                            ),
                          ),
                        ),

                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20.0,
                            vertical: 20.0,
                          ),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.vertical(
                              bottom: Radius.circular(25),
                            ),
                          ),
                          child: Column(
                            children: [
                              Text(
                                titulo,
                                style: const TextStyle(
                                  color: const Color(0xFF623FBD),
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                descricao,
                                style: const TextStyle(
                                  color: Colors.black54,
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 50),
          const FooterWidget(),
        ],
      ),
    );
  }
}
