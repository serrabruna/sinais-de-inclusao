import 'package:flutter/material.dart';
import 'package:sinais_de_inclusao/http/dio_client.dart';
import 'package:sinais_de_inclusao/modules/atividades/atividade_page.dart';
import 'package:sinais_de_inclusao/service/streak_service.dart';

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

    int estrelas = 0;
    String titulo = 'Parabéns!';
    String subtitulo = 'Você concluiu todas as atividades!';
    String labelMedalha = '';
    Color corMedalha = Colors.grey[400]!;

    if (_acertos == 0) {
      titulo = 'Que pena!';
      subtitulo = 'Você não acertou nenhuma questão dessa vez.';
      labelMedalha = 'Tente novamente para ganhar estrelas!';
      corMedalha = Colors.grey[400]!;
      estrelas = 0;
    } else if (taxa >= 0.8) {
      estrelas = 3;
      labelMedalha = '3 Estrelas de Ouro';
      corMedalha = const Color(0xFFFFD700); 
    } else if (taxa >= 0.5) {
      estrelas = 2;
      labelMedalha = '2 Estrelas de Prata';
      corMedalha = const Color(0xFFC0C0C0); 
    } else {
      estrelas = 1;
      labelMedalha = '1 Estrela de Bronze';
      corMedalha = const Color(0xFFCD7F32); 
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
              Text(
                titulo,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: _acertos == 0 ? Colors.redAccent : const Color(0xFF623FBD),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                subtitulo,
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
                labelMedalha,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: _acertos == 0
                      ? Colors.grey[600]
                      : (corMedalha == const Color(0xFFC0C0C0)
                          ? Colors.blueGrey
                          : corMedalha),
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
                  onPressed: () async {
                    if (_acertos > 0) {
                      await StreakService.registrarTreinoConcluido();
                    }
                    if (!ctx.mounted) return;
                    Navigator.pop(ctx);
                    Navigator.pop(context, {
                      'xp': _xpTotalNoFluxo,
                      'estrelas': estrelas,
                    });
                  },
                  child: Text(
                    _acertos == 0 ? 'Tentar Novamente' : 'Concluir',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
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
      return const Scaffold(
        backgroundColor: Color(0xFF623FBD),
        body: Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
      );
    }

    final double progresso = widget.questoes.isNotEmpty
        ? (_currentIndex + 1) / widget.questoes.length
        : 0.0;

    final q = widget.questoes[_currentIndex];

    return Scaffold(
      backgroundColor: const Color(0xFF623FBD),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
              child: Row(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: TweenAnimationBuilder<double>(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        tween: Tween<double>(
                          begin: 0,
                          end: progresso,
                        ),
                        builder: (context, value, _) => LinearProgressIndicator(
                          value: value,
                          minHeight: 10,
                          backgroundColor: Colors.white24,
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            Color(0xFF58CC02),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    '${_currentIndex + 1}/${widget.questoes.length}',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: AtividadePage(
                key: ValueKey((q['id'] ?? _currentIndex)),
                idQuestao: (q['id'] ?? 0).toInt(),
                enunciado: (q['statement'] ?? 'Sem enunciado').toString(),
                urlMidia: (q['image_path'] ?? '').toString(),
                alternativas: q['options'] != null
                    ? List<String>.from(q['options'])
                    : [],
                alternativaCorreta: (q['correct_answer'] ?? '').toString(),
                onFinalizado: _irParaProxima,
              ),
            ),
          ],
        ),
      ),
    );
  }
}