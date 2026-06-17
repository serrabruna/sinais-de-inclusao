
import 'package:flutter/material.dart';
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
    String nome = _nomeController.text;
    String email = _emailController.text;
    String senha = _senhaController.text;
    String confirmacao = _senhaConfirmacaoController.text;

    if (nome.trim().isEmpty ||
        email.trim().isEmpty ||
        senha.trim().isEmpty ||
        confirmacao.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, preencha todos os campos!')),
      );
      return;
    }

    if (senha != confirmacao) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('As senhas não coincidem!')));
      return;
    }

    setState(() {
      _carregando = true;
    });

    await Future.delayed(const Duration(seconds: 3));

    setState(() {
      _carregando = false;
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Conta criada com sucesso!')));
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
                color: const Color(
                  0xFFF3F1FA,
                ), 
                borderRadius: BorderRadius.circular(
                  40,
                ), 
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
                      child: const Text.rich(
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
                                backgroundColor: const Color(
                                  0xFFFFB46E,
                                ), 
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    25,
                                  ), 
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

  Widget _construirCampoTexto({
    required TextEditingController controller,
    required String hintText,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(
          25,
        ), 
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

