import 'package:dio/dio.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:sinais_de_inclusao/http/dio_client.dart';
import 'package:sinais_de_inclusao/widgets/custom_app_bar.dart';
import 'package:sinais_de_inclusao/widgets/footer_widget.dart';

class CadastroPage extends StatefulWidget {
  const CadastroPage({super.key});

  @override
  State<CadastroPage> createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {
  late TextEditingController _nomeController;
  late TextEditingController _emailController;
  late TextEditingController _senhaController;
  late TextEditingController _senhaConfirmacaoController;

  // Variável para armazenar o perfil selecionado
  String? _perfilSelecionado;

  final List<String> _opcoesPerfil = ['Admin', 'Aluno'];

  bool _carregando = false;

  @override
  void initState() {
    super.initState();
    _nomeController = TextEditingController();
    _emailController = TextEditingController();
    _senhaController = TextEditingController();
    _senhaConfirmacaoController = TextEditingController();
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _senhaController.dispose();
    _senhaConfirmacaoController.dispose();
    super.dispose();
  }

  void _enviarDados() async {
      if (_perfilSelecionado == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Por favor, selecione um perfil!')),
        );
        return;
      }
      if (_senhaController.text.trim() != _senhaConfirmacaoController.text.trim()) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('As senhas não coincidem!')),
        );
        return;
      }

      setState(() => _carregando = true);

      try {
        final dio = await DioClient.getInstance();
        
        final response = await dio.post(
          'signup',
          data: {
            'email': _emailController.text.trim(),
            'password': _senhaController.text.trim(),
            'name': _nomeController.text.trim(),
            'role': _perfilSelecionado!.toLowerCase(),
          },
        );

        if (response.statusCode == 201) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Conta criada!')));
          if (Navigator.canPop(context)) {
            Navigator.pop(context);
          } else {
            Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
          }
        }
      } on DioException catch (e) {
        String erro = e.response?.data['error'] ?? 'Erro ao cadastrar';
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(erro), backgroundColor: Colors.red));
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
                      'Crie sua conta',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF5134A4),
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),

                  const Text(
                    'Nome completo:',
                    style: TextStyle(
                      color: Color(0xFF333333),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _construirCampoTexto(
                    controller: _nomeController,
                    hintText: 'Insira seu nome...',
                  ),
                  const SizedBox(height: 15),

                  const Text(
                    'Selecione seu perfil:',
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
                    'E-mail:',
                    style: TextStyle(
                      color: Color(0xFF333333),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _construirCampoTexto(
                    controller: _emailController,
                    hintText: 'Insira seu e-mail...',
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 15),

                  const Text(
                    'Senha:',
                    style: TextStyle(
                      color: Color(0xFF333333),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _construirCampoTexto(
                    controller: _senhaController,
                    hintText: 'Insira sua senha...',
                    obscureText: true,
                  ),
                  const SizedBox(height: 15),

                  const Text(
                    'Confirme a senha:',
                    style: TextStyle(
                      color: Color(0xFF333333),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _construirCampoTexto(
                    controller: _senhaConfirmacaoController,
                    hintText: 'Insira sua senha...',
                    obscureText: true,
                  ),
                  const SizedBox(height: 25),

                  Center(
                    child: GestureDetector(
                      onTap: () {},
                      child:  Text.rich(
                        TextSpan(
                          text: 'Já possui conta? ',
                          style: TextStyle(
                            color: Color(0xFF333333),
                            fontSize: 14,
                          ),
                          children: [
                            TextSpan(
                              text: 'Faça login',
                              style: TextStyle(
                                color: Color(0xFF623FBD),
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () => Navigator.pushReplacementNamed(context, '/login'),
                            ),
                          ],
                        ),
                      ),
                    ),
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
          value: _perfilSelecionado,
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
              _perfilSelecionado = novoValor;
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
