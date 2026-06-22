import 'package:flutter/material.dart';

class AtividadePage extends StatefulWidget {
  final String enunciado;
  final String urlMidia;
  final List<String> alternativas;
  final String alternativaCorreta;

  const AtividadePage({
    super.key,
    required this.enunciado,
    required this.urlMidia,
    required this.alternativas,
    required this.alternativaCorreta,
  });

  @override
  State<AtividadePage> createState() => _AtividadePageState();
}

class _AtividadePageState extends State<AtividadePage> {
  int _vidas = 5;
  String? _alternativaSelecionada;

  void _verificarResposta(String resposta) {
    if (_alternativaSelecionada != null) return;

    setState(() {
      _alternativaSelecionada = resposta;
    });

    if (resposta == widget.alternativaCorreta) {
      setState(() {
        _vidas += 10;
        
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Parabéns! Resposta correta! +10 XP 🎉'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      setState(() {
        if (_vidas > 0) _vidas--;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ops! Resposta errada! -1 XP 😢'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Color _obterCorBotao(String alternativa) {
    if (_alternativaSelecionada == null) {
      return Colors.white;
    }

    if (alternativa == widget.alternativaCorreta) {
      return Colors.green;
    }

    if (_alternativaSelecionada == alternativa) {
      return Colors.red;
    }

    return const Color.fromARGB(184, 161, 160, 160);
  }

  Color _obterCorTextoBotao(String alternativa) {
    if (_alternativaSelecionada == null) {
      return const Color(0xFF333333);
    }
    if (alternativa == widget.alternativaCorreta ||
        _alternativaSelecionada == alternativa) {
      return Colors.white;
    }
    return const Color.fromARGB(172, 51, 51, 51);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF623FBD),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.close,
                      color: Colors.white70,
                      size: 30,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      const SizedBox(
                        width: 45,
                        height: 45,
                        child: CircularProgressIndicator(
                          value: 0.1,
                          color: Colors.white,
                          backgroundColor: Colors.white24,
                          strokeWidth: 3,
                        ),
                      ),
                      const Text(
                        '01',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Text(
                          '$_vidas ',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const Icon(
                          Icons.favorite,
                          color: Color.fromARGB(255, 224, 131, 122),
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),

              Center(
                child: Container(
                  width: 250,
                  height: 250,
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F1FA),
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: Image.network(
                      widget.urlMidia,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          'assets/images/logocirculo.png',
                          fit: BoxFit.contain,
                        );
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),

              Center(
                child: Text(
                  widget.enunciado,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 30),

              Expanded(
                child: Column(
                  children: widget.alternativas.map((alternativa) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton(
                          onPressed: () => _verificarResposta(alternativa),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _obterCorBotao(alternativa),
                            foregroundColor: _obterCorTextoBotao(alternativa),
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                          child: Text(
                            alternativa,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: 80,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: const Icon(
                Icons.home_outlined,
                color: Colors.black38,
                size: 32,
              ),
              onPressed: () {},
            ),
            Image.asset('assets/images/logocirculo.png', height: 50),
            IconButton(
              icon: const Icon(
                Icons.bookmark_border,
                color: Colors.black38,
                size: 32,
              ),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
