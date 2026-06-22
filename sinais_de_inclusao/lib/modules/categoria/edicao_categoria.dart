import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:sinais_de_inclusao/http/dio_client.dart';
import 'package:sinais_de_inclusao/widgets/custom_app_bar.dart';
import 'package:sinais_de_inclusao/widgets/footer_widget.dart';

class EdicaoCategoriaPage extends StatefulWidget {
  final Map<String, dynamic>? categoria;
  const EdicaoCategoriaPage({super.key, this.categoria});
  

  @override
  State<EdicaoCategoriaPage> createState() => _EdicaoCategoriaPageState();
}

class _EdicaoCategoriaPageState extends State<EdicaoCategoriaPage> {
  late TextEditingController _nomeController;
  late TextEditingController _ordemController;
  late TextEditingController _descricaoController;

  bool _carregando = false;

  @override
  void initState() {
    super.initState();
    _nomeController = TextEditingController(text: widget.categoria!['name']);
    _ordemController = TextEditingController(text: widget.categoria!['order']?.toString());
    _descricaoController = TextEditingController(text: widget.categoria!['description']);
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _ordemController.dispose();
    _descricaoController.dispose();
    super.dispose();
  }

  void _enviarDados() async {
    if (_nomeController.text.trim().isEmpty || _descricaoController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Preencha os campos!')));
      return;
    }

    setState(() => _carregando = true);

    try {
      final dio = await DioClient.getInstance();
      
      await dio.put('/categories/${widget.categoria!['id']}', data: {
        'name': _nomeController.text.trim(),
        'description': _descricaoController.text.trim(),
        'order': int.tryParse(_ordemController.text) ?? 0,
      });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Categoria atualizada!')));
      Navigator.pop(context, true);
    } on DioException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro: ${e.response?.data['error'] ?? 'Falha'}')));
    } finally {
      if (mounted) setState(() => _carregando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF623FBD),
      appBar:const CustomAppBar(),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10.0),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 35.0),
              decoration: BoxDecoration(
                color: const Color(0xFFF3F1FA),
                borderRadius: BorderRadius.circular(40),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Center(
                    child: Text(
                      'Editar Categoria',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF5134A4),
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),

                  const Text(
                    'Nome da Categoria:',
                    style: TextStyle(color: Color(0xFF333333), fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 8),
                  _construirCampoTexto(
                    controller: _nomeController,
                    hintText: 'Ex: Animais',
                  ),
                  const SizedBox(height: 15),

                  const Text(
                    'Ordem:',
                    style: TextStyle(color: Color(0xFF333333), fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 8),
                  _construirCampoTexto(
                    controller: _ordemController,
                    hintText: 'Sequência que deve aparecer na tela. Ex: 3',
                    keyboardType: TextInputType.number, 
                  ),
                  const SizedBox(height: 15),

                  const Text(
                    'Descrição:',
                    style: TextStyle(color: Color(0xFF333333), fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 8),
                  _construirCampoTexto(
                    controller: _descricaoController,
                    hintText: 'Insira a Descrição...',
                    obscureText: false, 
                  ),
                  const SizedBox(height: 25),

                  _carregando
                      ? const Center(child: CircularProgressIndicator())
                      : Center(
                          child: SizedBox(
                            width: 220,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: _enviarDados,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFFFB46E),
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                              ),
                              child: const Text(
                                'Continuar',
                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
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

  Widget _construirCampoTexto({
    required TextEditingController controller,
    required String hintText,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(91, 106, 94, 94),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.black26, fontSize: 15),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          border: InputBorder.none,
        ),
      ),
    );
  }
}