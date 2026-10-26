import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:sinais_de_inclusao/classes/icon_mapper.dart';
import 'package:sinais_de_inclusao/http/dio_client.dart';
import 'package:sinais_de_inclusao/widgets/custom_app_bar.dart';
import 'package:sinais_de_inclusao/widgets/footer_widget.dart';
import 'package:sinais_de_inclusao/widgets/gradient_background.dart';

class ExcluirCategoriaPage extends StatefulWidget {
  final Map<String, dynamic> categoria;

  const ExcluirCategoriaPage({super.key, required this.categoria});

  @override
  State<ExcluirCategoriaPage> createState() => _ExcluirCategoriaPageState();
}

class _ExcluirCategoriaPageState extends State<ExcluirCategoriaPage> {
  bool _carregando = false;

  void _voltar() {
    Navigator.pop(context);
  }

  void _enviarDados() async {
    setState(() => _carregando = true);

    try {
      final dio = await DioClient.getInstance();

      await dio.delete('/categories/${widget.categoria['id']}');

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Categoria ${widget.categoria['name']} excluída!'),
        ),
      );

      Navigator.pop(context, true);
    } on DioException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Erro: ${e.response?.data['error'] ?? 'Falha ao excluir'}',
          ),
        ),
      );
    } finally {
      if (mounted) setState(() => _carregando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF45239B),
      appBar: const CustomAppBar(),

      body: GradientBackground(
        child: ListView(
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
                        'Excluir Categoria',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF5134A4),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Cartão da categoria
                    Center(
                      child: Container(
                        width: 140,
                        height: 140,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFB46E),
                          borderRadius: BorderRadius.circular(25),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 6,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              IconMapper.getIcon(widget.categoria['name']),
                              size: 55,
                              color: const Color(0xFF623FBD),
                            ),

                            const SizedBox(height: 8),

                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                              ),
                              child: Text(
                                widget.categoria['name'],
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Color(0xFF623FBD),
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 25),

                    const Text(
                      'Tem certeza de que deseja excluir esta categoria?',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 20),

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
                        style: TextStyle(fontSize: 16, color: Colors.black54),
                        textAlign: TextAlign.center,
                      ),
                    ),

                    const SizedBox(height: 35),

                    // Botões de ação
                    _carregando
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: Color(0xFF623FBD),
                            ),
                          )
                        : Row(
                            children: [
                              // Botão Voltar
                              Expanded(
                                child: SizedBox(
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
                                      padding: EdgeInsets.zero,
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
                              ),

                              const SizedBox(width: 15),

                              // Botão Excluir
                              Expanded(
                                child: SizedBox(
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
                                      padding: EdgeInsets.zero,
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
                              ),
                            ],
                          ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
