import 'package:flutter/material.dart';
import 'package:sinais_de_inclusao/http/dio_client.dart';
import 'package:sinais_de_inclusao/modules/atividades/atividade_page.dart';

class FlowAtividadesPage extends StatefulWidget {
  final List<dynamic> questoes;
  const FlowAtividadesPage({super.key, required this.questoes});

  @override
  State<FlowAtividadesPage> createState() => _FlowAtividadesPageState();
}

class _FlowAtividadesPageState extends State<FlowAtividadesPage> {
  int _currentIndex = 0;
  int _xpTotalNoFluxo = 0;
  int _acertos = 0;

  @override
  void initState() {
    super.initState();
    _fetchXPInicial();
  }

  Future<void> _fetchXPInicial() async {
    try {
      final dio = await DioClient.getInstance();
      final response = await dio.get('/user/xp');
      if (mounted) {
        setState(() {
          _xpTotalNoFluxo = (response.data['xp'] ?? 0).toInt();
        });
      }
    } catch (e) {
      debugPrint("Erro ao carregar XP: $e");
    }
  }

  void _irParaProxima(int xpGanho) {
    setState(() {
      _xpTotalNoFluxo += xpGanho;
      if (xpGanho > 0) {
        _acertos++;
      }
    });

    if (_currentIndex < widget.questoes.length - 1) {
      setState(() => _currentIndex++);
    } else {
      _exibirModalParabens();
    }
  }

  void _exibirModalParabens() {
    final int total = widget.questoes.length;
    final double taxa = total > 0 ? (_acertos / total) : 0;

    int estrelas = 1;
    String tipoMedalha = 'Bronze';
    Color corMedalha = const Color(0xFFCD7F32); 

    if (taxa >= 0.8) {
      estrelas = 3;
      tipoMedalha = 'Ouro';
      corMedalha = const Color(0xFFFFD700); 
    } else if (taxa >= 0.5) {
      estrelas = 2;
      tipoMedalha = 'Prata';
      corMedalha = const Color(0xFFC0C0C0); 
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          contentPadding: const EdgeInsets.all(24),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Parabéns!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF623FBD),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Você concluiu todas as atividades!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15, color: Colors.grey[700]),
              ),
              const SizedBox(height: 18),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(3, (index) {
                  return Icon(
                    Icons.star_rounded,
                    size: 44,
                    color: index < estrelas ? corMedalha : Colors.grey[300],
                  );
                }),
              ),
              const SizedBox(height: 8),
              Text(
                '$estrelas ${estrelas == 1 ? "Estrela" : "Estrelas"} de $tipoMedalha',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: corMedalha == const Color(0xFFC0C0C0) ? Colors.blueGrey : corMedalha,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F1FA),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Text(
                      'Acertos: $_acertos de $total',
                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'XP ganho nesta sessão: +${_acertos * 10}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Color(0xFF623FBD),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF623FBD),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: () {
                    Navigator.pop(ctx);
                    Navigator.pop(context, {
                      'xp': _xpTotalNoFluxo,
                      'estrelas': estrelas,
                    });
                  },
                  child: const Text(
                    'Concluir',
                    style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.questoes.isEmpty || _currentIndex >= widget.questoes.length) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final q = widget.questoes[_currentIndex];
    return AtividadePage(
      idQuestao: (q['id'] ?? 0).toInt(),
      enunciado: (q['statement'] ?? 'Sem enunciado').toString(),
      urlMidia: (q['image_path'] ?? '').toString(),
      alternativas: q['options'] != null
          ? List<String>.from(q['options'])
          : [],
      alternativaCorreta: (q['correct_answer'] ?? '').toString(),
      onFinalizado: _irParaProxima,
    );
  }
}