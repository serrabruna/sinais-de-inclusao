import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:sinais_de_inclusao/http/dio_client.dart';
import 'package:sinais_de_inclusao/model/sign_model.dart';
import 'package:sinais_de_inclusao/widgets/custom_app_bar.dart';
import 'package:sinais_de_inclusao/widgets/footer_widget.dart';

class ExcluirQuestaoPage extends StatefulWidget {
  final SignModel questao;

  const ExcluirQuestaoPage({super.key, required this.questao});

  @override
  State<ExcluirQuestaoPage> createState() => _ExcluirQuestaoPageState();
}

class _ExcluirQuestaoPageState extends State<ExcluirQuestaoPage> {
  bool _carregando = false;

  void _voltar() => Navigator.pop(context);

  Future<void> _enviarDados() async {
    setState(() => _carregando = true);

    try {
      final dio = await DioClient.getInstance();
      await dio.delete('/signs/${widget.questao.id}');

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Atividade "${widget.questao.name}" excluída!')),
      );

      Navigator.pop(context, true); 
    } on DioException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao excluir: ${e.response?.data['message'] ?? 'Falha'}')),
      );
    } finally {
      if (mounted) setState(() => _carregando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF623FBD),
      appBar: const CustomAppBar(),
      
      body: Center(
        child: ListView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          children: [
            Container(
              padding: const EdgeInsets.all(25.0),
              decoration: BoxDecoration(
                color: const Color(0xFFF3F1FA),
                borderRadius: BorderRadius.circular(40),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min, 
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
                  Text(
                    'Tem certeza de que deseja excluir a atividade "${widget.questao.name}"?',
                    style: const TextStyle(fontSize: 20, color: Colors.black),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 25),
                  const Center(
                    child: Text('ATENÇÃO:',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red)),
                  ),
                  const Center(
                    child: Text('Esta ação não pode ser desfeita',
                        style: TextStyle(fontSize: 16, color: Colors.black54)),
                  ),
                  const SizedBox(height: 35),
                  _carregando
                      ? const Center(child: CircularProgressIndicator())
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _botaoAcao('Voltar', const Color(0xFFFFB46E), _voltar),
                            const SizedBox(width: 15),
                            _botaoAcao('Excluir', const Color(0xFFFF5A4A), _enviarDados),
                          ],
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _botaoAcao(String texto, Color cor, VoidCallback onPressed) {
    return SizedBox(
      width: 130,
      height: 50,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: cor,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        ),
        child: Text(texto, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ),
    );
  }
}