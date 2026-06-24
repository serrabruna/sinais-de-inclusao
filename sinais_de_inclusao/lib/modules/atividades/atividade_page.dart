import 'package:flutter/material.dart';
import 'package:sinais_de_inclusao/http/dio_client.dart';

class AtividadePage extends StatefulWidget {
  final int idQuestao;
  final String enunciado;
  final String urlMidia;
  final List<String> alternativas;
  final String alternativaCorreta;
  final void Function(int) onFinalizado;

  const AtividadePage({
    super.key,
    required this.idQuestao,
    required this.enunciado,
    required this.urlMidia,
    required this.alternativas,
    required this.alternativaCorreta,
    required this.onFinalizado,
  });

  @override
  State<AtividadePage> createState() => _AtividadePageState();
}

class _AtividadePageState extends State<AtividadePage> {
  bool? _foiCorreto;
  String? _alternativaSelecionada;
  bool _enviando = false;

  // ESTA É A CHAVE PARA O PROBLEMA DE ESTADO AO MUDAR DE ATIVIDADE
  @override
  void didUpdateWidget(covariant AtividadePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.idQuestao != widget.idQuestao) {
      setState(() {
        _alternativaSelecionada = null;
        _foiCorreto = null;
        _enviando = false;
      });
    }
  }

  Future<void> _verificarResposta(String resposta) async {
    if (_enviando || _alternativaSelecionada != null) return;

    setState(() {
      _alternativaSelecionada = resposta;
      _enviando = true;
    });

    try {
      final dio = await DioClient.getInstance();
      final response = await dio.post('/answer', 
        data: {'sign_id': widget.idQuestao, 'user_answer': resposta}
      );

      final String mensagem = response.data['message']?.toString() ?? "";
      final bool acertou = mensagem.contains("Parabéns") || mensagem.contains("acertou");

      setState(() {
        _foiCorreto = acertou;
        _enviando = false;
      });

      if (acertou) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Correto! +10 XP'), backgroundColor: Colors.green)
        );
        Future.delayed(const Duration(seconds: 1), () {
          if (mounted) widget.onFinalizado(10);
        });
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Resposta errada, tente novamente!'), backgroundColor: Colors.red)
        );
        
        // Reset para permitir nova tentativa
        Future.delayed(const Duration(seconds: 1), () {
          if (mounted) {
            setState(() {
              _alternativaSelecionada = null;
              _foiCorreto = null;
            });
          }
        });
      }
    } catch (e) {
      if (mounted) setState(() => _enviando = false);
      debugPrint("Erro na API: $e");
    }
  }

  Color _obterCorBotao(String alternativa) {
    if (_alternativaSelecionada == null) return Colors.white;
    if (_alternativaSelecionada == alternativa) {
      if (_enviando) return Colors.white70;
      return (_foiCorreto == true) ? Colors.green : Colors.red;
    }
    return const Color.fromARGB(184, 161, 160, 160);
  }

  Color _obterCorTextoBotao(String alternativa) {
    if (_alternativaSelecionada == null) return const Color(0xFF333333);
    if (_alternativaSelecionada == alternativa) return Colors.white;
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
                    icon: const Icon(Icons.close, color: Colors.white70, size: 30),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(20)),
                    child: Row(
                      children: const [
                        Text('XP +10', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        SizedBox(width: 5),
                        Icon(Icons.star, color: Colors.amber, size: 20),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Center(
                child: Container(
                  width: 250, height: 250,
                  decoration: BoxDecoration(color: const Color(0xFFF3F1FA), borderRadius: BorderRadius.circular(40)),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: Image.network(widget.urlMidia, fit: BoxFit.contain, 
                      errorBuilder: (c, e, s) => Image.asset('assets/images/logocirculo.png')),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Text(widget.enunciado, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
              const SizedBox(height: 30),
              Expanded(
                child: ListView(
                  children: widget.alternativas.map((alternativa) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: ElevatedButton(
                        onPressed: () => _verificarResposta(alternativa),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _obterCorBotao(alternativa),
                          foregroundColor: _obterCorTextoBotao(alternativa),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                          padding: const EdgeInsets.symmetric(vertical: 20),
                        ),
                        child: Text(alternativa, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}