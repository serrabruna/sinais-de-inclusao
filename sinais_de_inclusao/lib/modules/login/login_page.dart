import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sinais_de_inclusao/widgets/custom_app_bar.dart';
import 'package:sinais_de_inclusao/widgets/footer_widget.dart';
import 'package:dio/dio.dart';
import 'package:sinais_de_inclusao/http/dio_client.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late TextEditingController _emailController;
  late TextEditingController _senhaController;

  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'https://sinais-de-inclusao-api.onrender.com',
    connectTimeout: const Duration(seconds: 5),
  ));

  bool _carregando = false;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _senhaController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  Future<void> _enviarDados() async {
    String email = _emailController.text.trim();
    String senha = _senhaController.text.trim();

    if (email.isEmpty || senha.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, preencha todos os campos!')),
      );
      return;
    }

    setState(() => _carregando = true);

    try {
      final dio = await DioClient.getInstance();

      final response = await dio.post(
        '/login',
        data: {'email': email, 'password': senha},
      );

      if (response.statusCode == 200) {

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', response.data['token']);
        await prefs.setString('role', response.data['role']);

        if (!mounted) return;
        Navigator.pushNamed(context, '/temas');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login realizado com sucesso!')),
        );
      }
    } on DioException catch (e) {
      if (!mounted) return;
      String mensagem = e.response?.data['error'] ?? 'Erro no servidor';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(mensagem),
          backgroundColor: Colors.red,
        ),
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
              horizontal: 30.0,
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
                      'Acesse sua conta',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF5134A4),
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),

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
                  const SizedBox(height: 20),

                  Center(
                    child: GestureDetector(
                      onTap: () {},
                      child: Text.rich(
                        TextSpan(
                          text: 'Ainda não possui conta? ',
                          style: TextStyle(
                            color: Color(0xFF333333),
                            fontSize: 14,
                          ),

                          children: [
                            TextSpan(
                              text: 'Cadastre-se',
                              style: TextStyle(
                                color: Color(0xFF623FBD),
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () => Navigator.pushReplacementNamed(context, '/cadastro'),
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
                                'Entrar',
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
          const SizedBox(height: 150),
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
