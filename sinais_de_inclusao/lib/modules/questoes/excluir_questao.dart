import 'package:flutter/material.dart';
import 'package:sinais_de_inclusao/widgets/custom_app_bar.dart';
import 'package:sinais_de_inclusao/widgets/footer_widget.dart';

class ExcluirQuestaoPage extends StatefulWidget {
  final String nomeQuestao;

  const ExcluirQuestaoPage({super.key, required this.nomeQuestao});

  @override
  State<ExcluirQuestaoPage> createState() => _ExcluirQuestaoPageState();
}

class _ExcluirQuestaoPageState extends State<ExcluirQuestaoPage> {
  bool _carregando = false;

  void _voltar() {
    Navigator.pop(context); 
  }

  void _enviarDados() async {
    setState(() {
      _carregando = true; 
    });

    await Future.delayed(const Duration(seconds: 3));

    setState(() {
      _carregando = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Atividade ${widget.nomeQuestao} excluída com sucesso!',
        ),
      ),
    );

    Navigator.pop(context); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF623FBD),
      appBar: const CustomAppBar(),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 25.0,
              vertical: 10.0,
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 25.0,
                vertical: 35.0,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFFF3F1FA),
                borderRadius: BorderRadius.circular(40),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Center(
                    child: Text(
                      'Excluir Atividade',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF5134A4),
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),

                  Center(
                    child: Text(
                      'Tem certeza de que deseja excluir a atividade "${widget.nomeQuestao}"?', 
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.normal,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 25),

                  const Center(
                    child: Text(
                      'ATENÇÃO:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                  ),
                  const Center(
                    child: Text(
                      'Esta ação não pode ser desfeita',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        color: Colors.black54,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 35),

                  _carregando
                      ? const Center(child: CircularProgressIndicator())
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 130,
                              height: 50,
                              child: ElevatedButton(
                                onPressed: _voltar,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFFFB46E),
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                ),
                                child: const Text(
                                  'Voltar',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 15),

                            SizedBox(
                              width: 130,
                              height: 50,
                              child: ElevatedButton(
                                onPressed: _enviarDados,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFFF5A4A),
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                ),
                                child: const Text(
                                  'Excluir',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 200),
          const FooterWidget(),
        ],
      ),
    );
  }
}