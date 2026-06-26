import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:sinais_de_inclusao/http/dio_client.dart';
import 'package:sinais_de_inclusao/model/sign_model.dart';
import 'package:sinais_de_inclusao/widgets/custom_app_bar.dart';
import 'package:sinais_de_inclusao/widgets/footer_widget.dart';

class EdicaoQuestaoPage extends StatefulWidget {
  final SignModel questao;
  const EdicaoQuestaoPage({super.key, required this.questao});
  
  @override
  State<EdicaoQuestaoPage> createState() => _EdicaoQuestaoPageState();
}

class _EdicaoQuestaoPageState extends State<EdicaoQuestaoPage> {
  final _nomeController = TextEditingController();
  final _enunciadoController = TextEditingController();
  final _urlController = TextEditingController();
  final _altCorretaController = TextEditingController();
  final _alt1Controller = TextEditingController();
  final _alt2Controller = TextEditingController();
  final _alt3Controller = TextEditingController();
  
  int? _idCategoriaSelecionada;
  List<Map<String, dynamic>> _listaCategorias = [];
  bool _carregando = false;

  @override
  void initState() {
    super.initState();
    _nomeController.text = widget.questao.name;
    _enunciadoController.text = widget.questao.statement;
    _urlController.text = widget.questao.imagePath;
    _altCorretaController.text = widget.questao.correctAnswer;
    _idCategoriaSelecionada = widget.questao.categoryId;

    if (widget.questao.options.length >= 5) { 
      _alt1Controller.text = widget.questao.options[1];
      _alt2Controller.text = widget.questao.options[2];
      _alt3Controller.text = widget.questao.options[3];
    }
    _buscarCategorias();
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _enunciadoController.dispose();
    _urlController.dispose();
    _altCorretaController.dispose();
    _alt1Controller.dispose();
    _alt2Controller.dispose();
    _alt3Controller.dispose();
    super.dispose();
  }

  Future<void> _buscarCategorias() async {
    try {
      final dio = await DioClient.getInstance();
      final response = await dio.get('/categories');
      setState(() {
        _listaCategorias = List<Map<String, dynamic>>.from(response.data);
        bool existe = _listaCategorias.any((cat) => cat['id'] == widget.questao.categoryId);
        _idCategoriaSelecionada = existe ? widget.questao.categoryId : null;
      });
    } catch (e) {
      debugPrint("Erro ao carregar categorias: $e");
    }
  }

  Future<void> _enviarDados() async {
    if (_idCategoriaSelecionada == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Selecione uma categoria válida!')));
      return;
    }

    setState(() => _carregando = true);

    try {
      final dio = await DioClient.getInstance();
      await dio.put('/signs/${widget.questao.id}', data: {
        'categoryId': _idCategoriaSelecionada,
        'name': _nomeController.text.trim(),
        'statement': _enunciadoController.text.trim(),
        'imagePath': _urlController.text.trim(),
        'correctAnswer': _altCorretaController.text.trim(),
        'options': [
          _altCorretaController.text.trim(),
          _alt1Controller.text.trim(),
          _alt2Controller.text.trim(),
          _alt3Controller.text.trim(),
        ],
      });

      if (!mounted) return;
      Navigator.pop(context, true);
    } on DioException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro: ${e.response?.data.toString()}')));
    } finally {
      if (mounted) setState(() => _carregando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF623FBD),
      body: ListView(
        children: [
          const CustomAppBar(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10.0),
            child: Container(
              padding: const EdgeInsets.all(25.0),
              decoration: BoxDecoration(color: const Color(0xFFF3F1FA), borderRadius: BorderRadius.circular(40)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Center(child: Text('Editar Atividade', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF5134A4)))),
                  const SizedBox(height: 20),
                  
                  DropdownButtonFormField<int>(
                    value: _idCategoriaSelecionada,
                    decoration: InputDecoration(labelText: "Categoria", border: OutlineInputBorder(borderRadius: BorderRadius.circular(25))),
                    items: _listaCategorias.map((cat) => DropdownMenuItem<int>(
                      value: cat['id'] as int,
                      child: Text(cat['name']),
                    )).toList(),
                    onChanged: (val) => setState(() => _idCategoriaSelecionada = val),
                  ),
                  
                  _construirCampoTexto(controller: _nomeController, hintText: 'Nome da Questão'),
                  _construirCampoTexto(controller: _enunciadoController, hintText: 'Enunciado'),
                  _construirCampoTexto(controller: _urlController, hintText: 'URL da Imagem'),
                  _construirCampoTexto(controller: _altCorretaController, hintText: 'Alternativa Correta'),
                  _construirCampoTexto(controller: _alt1Controller, hintText: 'Alternativa 1'),
                  _construirCampoTexto(controller: _alt2Controller, hintText: 'Alternativa 2'),
                  _construirCampoTexto(controller: _alt3Controller, hintText: 'Alternativa 3'),
        
                  const SizedBox(height: 25),
                  _carregando ? const Center(child: CircularProgressIndicator()) 
                    : Center(
                        child: SizedBox(
                          width: 220, height: 50,
                          child: ElevatedButton(
                            onPressed: _enviarDados,
                            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFFB46E), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25))),
                            child: const Text('Salvar Alterações', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ),
                ],
              ),
            ),
          ),

        ],
      ),
    );
  }

  Widget _construirCampoTexto({required TextEditingController controller, required String hintText}) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white, 
          borderRadius: BorderRadius.circular(25),
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4, offset: const Offset(0, 2))],
        ),
        child: TextField(
          controller: controller,
          decoration: InputDecoration(hintText: hintText, contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15), border: InputBorder.none),
        ),
      ),
    );
  }
}