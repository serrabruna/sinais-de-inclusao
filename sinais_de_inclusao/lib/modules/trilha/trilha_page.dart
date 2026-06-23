import 'package:flutter/material.dart';
import 'package:sinais_de_inclusao/classes/icon_mapper.dart';
import 'package:sinais_de_inclusao/modules/atividades/atividade_page.dart';

class TrilhaPage extends StatefulWidget {
  const TrilhaPage({super.key});

  @override
  State<TrilhaPage> createState() => _TrilhaPageState();
}

class _TrilhaPageState extends State<TrilhaPage> {
  int _xpTotal = 0;

  final List<Map<String, dynamic>> _niveis = [
    {'name': 'Animais', 'xpNecessario': 0, 'corFundo': const Color(0xFFA2E0FC)},
    {'name': 'Objetos', 'xpNecessario': 100, 'corFundo': const Color(0xFFA2E0FC)},
    {'name': 'Saudações', 'xpNecessario': 200, 'corFundo': Colors.white},
    {'name': 'Alimentos', 'xpNecessario': 300, 'corFundo': Colors.white},
    {'name': 'Cores', 'xpNecessario': 400, 'corFundo': Colors.white},
    {'name': 'Verbos', 'xpNecessario': 500, 'corFundo': Colors.white},
  ];

  void _irParaAtividade() async {
    final xpGanho = await Navigator.push<int>(
      context,
      MaterialPageRoute(
        builder: (context) => const AtividadePage(
          enunciado: 'Qual é este sinal?',
          urlMidia: 'https://i.imgur.com/YfU2j3w.png',
          alternativas: ['Girafa', 'Macaco', 'Leão'],
          alternativaCorreta: 'Macaco',
        ),
      ),
    );

    if (xpGanho != null) {
      setState(() {
        _xpTotal += xpGanho;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF623FBD),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.close,
                      color: Colors.white70,
                      size: 30,
                    ),
                    onPressed: () {},
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Text(
                          '$_xpTotal ',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        const Icon(Icons.favorite, color: Colors.red, size: 22),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: Column(
                    children: [
                      _construirItemTrilha(0, bias: 0.0), 
                      const SizedBox(height: 10),
                      _construirItemTrilha(1, bias: -0.6), 
                      const SizedBox(height: 10),
                      _construirItemTrilha(2, bias: 0.6), 
                      const SizedBox(height: 10),
                      _construirItemTrilha(3, bias: 0.0), 
                      const SizedBox(height: 10),
                      _construirItemTrilha(4, bias: -0.6), 
                      const SizedBox(height: 10),
                      _construirItemTrilha(5, bias: 0.6), 
                    ],
                  ),
                ),
              ),
            ),

            Container(
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
                      Icons.home,
                      color: Color(0xFF623FBD),
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
          ],
        ),
      ),
    );
  }

  Widget _construirItemTrilha(int index, {required double bias}) {
    final nivel = _niveis[index];
    final String nome = nivel['name'];
    final int xpNecessario = nivel['xpNecessario'];
    final Color corFundo = nivel['corFundo'];

    final bool estaLiberado = _xpTotal >= xpNecessario;

    final Color corIcone = corFundo == Colors.white
        ? const Color(0xFF623FBD)
        : const Color(0xFF5134A4);

    return AlignmentPlatform(
      alignment: Alignment(bias, 0.0),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Opacity(
          opacity: estaLiberado ? 1.0 : 0.4,
          child: GestureDetector(
            onTap: estaLiberado 
                ? _irParaAtividade 
                : () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Bloqueado! Você precisa de $xpNecessario XP.'),
                        backgroundColor: Colors.amber[800],
                      ),
                    );
                  },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 95, 
                      height: 95,
                      decoration: BoxDecoration(
                        color: corFundo,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: const Color.fromARGB(116, 0, 0, 0),
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Icon(
                        IconMapper.getIcon(nome),
                        size: 45, 
                        color: corIcone,
                      ),
                    ),
                    if (!estaLiberado)
                      Positioned(
                        bottom: 0,
                        right: 4,
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.lock,
                            color: Color(0xFF623FBD),
                            size: 18,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  nome,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AlignmentPlatform extends StatelessWidget {
  final Alignment alignment;
  final Widget child;
  const AlignmentPlatform({
    super.key,
    required this.alignment,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: SizedBox(width: 140, child: child),
    );
  }
}