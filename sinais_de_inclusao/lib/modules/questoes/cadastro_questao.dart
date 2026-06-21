import 'package:flutter/material.dart';
import 'package:sinais_de_inclusao/widgets/footer_widget.dart';

class CadastroQuestaoPage extends StatefulWidget {
  const CadastroQuestaoPage({super.key});
  @override
  State<CadastroQuestaoPage> createState() => _CadastroQuestaoPageState();
}

class _CadastroQuestaoPageState extends State<CadastroQuestaoPage> {
  late TextEditingController _nomeController;
  late TextEditingController _enunciadoController;
  late TextEditingController _urlController;
  late TextEditingController _alternativa1Controller;
  late TextEditingController _alternativa2Controller;
  late TextEditingController _alternativa3Controller;
  late TextEditingController _alternativaCorretaController;
  String? _categoriaSelecionada;

  final List<String> _opcoesPerfil = [
    'Animais',
    'Objetos',
    'Saudações',
    'Alimentos',
    'Cores',
    'Verbos',
  ];
  bool _carregando = false;

  @override
  void initState() {
    super.initState();
    _nomeController = TextEditingController();
    _enunciadoController = TextEditingController();
    _urlController = TextEditingController();
    _alternativaCorretaController = TextEditingController();
    _alternativa1Controller = TextEditingController();
    _alternativa2Controller = TextEditingController();
    _alternativa3Controller = TextEditingController();
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _enunciadoController.dispose();
    _urlController.dispose();
    _alternativa1Controller.dispose();
    _alternativa2Controller.dispose();
    _alternativa3Controller.dispose();
    _alternativaCorretaController.dispose();
    super.dispose();
  }

  void _enviarDados() async {
    String nome = _nomeController.text;
    String enunciado = _enunciadoController.text;
    String url = _urlController.text;
    String alternativaCorreta = _alternativaCorretaController.text;
    String alternativa1 = _alternativa1Controller.text;
    String alternativa2 = _alternativa2Controller.text;
    String alternativa3 = _alternativa3Controller.text;

    if (nome.trim().isEmpty ||
        enunciado.trim().isEmpty ||
        url.trim().isEmpty ||
        alternativaCorreta.trim().isEmpty ||
        alternativa1.trim().isEmpty ||
        alternativa2.trim().isEmpty ||
        alternativa3.trim().isEmpty ||
        _categoriaSelecionada == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Por favor, preencha todos os campos e escolha a categoria!',
          ),
        ),
      );
      return;
    }

    setState(() {
      _carregando = true;
    });

    await Future.delayed(const Duration(seconds: 3));

    setState(() {
      _carregando = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Atividade ${_nomeController.text} cadastrada!')), 
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF623FBD),
      appBar: AppBar(
        toolbarHeight: 100,
        backgroundColor: const Color(0xFF623FBD),
        elevation: 0,
        title: Image.asset('assets/images/logocirculo.png', height: 70),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu, color: Colors.white, size: 35),
            onPressed: () {},
          ),
          const SizedBox(width: 10),
        ],
        automaticallyImplyLeading: false,
      ),
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
                      'Criar Atividade',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF5134A4),
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),

                  const Text(
                    'Selecione a Categoria:',
                    style: TextStyle(
                      color: Color(0xFF333333),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _construirCampoSelect(),
                  const SizedBox(height: 15),

                  const Text(
                    'Nome da Categoria:', 
                    style: TextStyle(
                      color: Color(0xFF333333),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _construirCampoTexto(
                    controller: _nomeController,
                    hintText: 'Ex: Animais',
                  ),
                  const SizedBox(height: 15),

                  const Text(
                    'Enunciado:',
                    style: TextStyle(
                      color: Color(0xFF333333),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _construirCampoTexto(
                    controller: _enunciadoController,
                    hintText: 'Insira o enunciado...',
                  ),
                  const SizedBox(height: 15),

                  const Text(
                    'URL da mídia:',
                    style: TextStyle(
                      color: Color(0xFF333333),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _construirCampoTexto(
                    controller: _urlController,
                    hintText: 'Insira a URL...',
                  ),
                  const SizedBox(height: 15),

                  const Text(
                    'Alternativa correta:',
                    style: TextStyle(
                      color: Color(0xFF333333),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _construirCampoTexto(
                    controller: _alternativaCorretaController,
                    hintText: 'Insira a alternativa correta...',
                  ),
                  const SizedBox(height: 15),

                  const Text(
                    'Alternativa 1:',
                    style: TextStyle(
                      color: Color(0xFF333333),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _construirCampoTexto(
                    controller: _alternativa1Controller,
                    hintText: 'Insira a primeira alternativa...',
                  ),
                  const SizedBox(height: 15),

                  const Text(
                    'Alternativa 2:',
                    style: TextStyle(
                      color: Color(0xFF333333),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _construirCampoTexto(
                    controller: _alternativa2Controller,
                    hintText: 'Insira a segunda alternativa...',
                  ),
                  const SizedBox(height: 15),

                  const Text(
                    'Alternativa 3:',
                    style: TextStyle(
                      color: Color(0xFF333333),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _construirCampoTexto(
                    controller: _alternativa3Controller,
                    hintText: 'Insira a terceira alternativa...',
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
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
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

  Widget _construirCampoSelect() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
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
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _categoriaSelecionada,
          hint: const Text(
            'Escolha uma opção...',
            style: TextStyle(color: Colors.black26, fontSize: 15),
          ),
          isExpanded: true,
          icon: const Icon(
            Icons.arrow_drop_down,
            color: Color(0xFF623FBD),
            size: 30,
          ),
          style: const TextStyle(color: Colors.black, fontSize: 16),
          borderRadius: BorderRadius.circular(20),
          onChanged: (String? novoValor) {
            setState(() {
              _categoriaSelecionada = novoValor;
            });
          },
          items: _opcoesPerfil.map<DropdownMenuItem<String>>((String valor) {
            return DropdownMenuItem<String>(value: valor, child: Text(valor));
          }).toList(),
        ),
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
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 15,
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }
}