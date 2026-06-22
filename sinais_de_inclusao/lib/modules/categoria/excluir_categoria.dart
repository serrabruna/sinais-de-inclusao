import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:sinais_de_inclusao/classes/icon_mapper.dart';
import 'package:sinais_de_inclusao/http/dio_client.dart';
import 'package:sinais_de_inclusao/widgets/custom_app_bar.dart';
import 'package:sinais_de_inclusao/widgets/footer_widget.dart';

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
        SnackBar(content: Text('Categoria ${widget.categoria['name']} excluída!'))
      );
      
      Navigator.pop(context, true); 
      
    } on DioException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro: ${e.response?.data['error'] ?? 'Falha ao excluir'}'))
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
                      'Excluir Categoria',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF5134A4),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  Center(
                    child: Container(
                      width: 140,
                      height: 140,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFB46E),
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            spreadRadius: 1,
                            blurRadius: 6,
                            offset: const Offset(0, 4),
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
                          Text(
                            widget.categoria['name'],
                            style: const TextStyle(
                              color: Color(0xFF623FBD),
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),

                  Center(
                    child: Text(
                      'Tem certeza de que deseja excluir esta categoria?',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
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
          const SizedBox(height: 50),
          const FooterWidget(),
        ],
      ),
    );
  }
}
