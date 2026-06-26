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
    });

    if (_currentIndex < widget.questoes.length - 1) {
      setState(() => _currentIndex++);
    } else {
      Navigator.pop(context, _xpTotalNoFluxo); 
    }
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