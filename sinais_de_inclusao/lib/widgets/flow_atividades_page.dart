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
  //controla o indice do exercicio atual
  int _xpTotalNoFluxo = 0; 
  //guarda o xp do usuario

  @override
  void initState() {
    super.initState();
    //no inicio ele chama o metodo para buscar quanto de xp o usuario ja tinha
    _fetchXPInicial(); 
  }

  Future<void> _fetchXPInicial() async {
    try {
      final dio = await DioClient.getInstance();
      final response = await dio.get('/user/xp'); 
      //faz a requisição http do tipo get na rota / user/xp para pegar o xp no bd
      if (mounted) {
        //mounted p nao dar nenhum tipo de erro
        setState(() {
          _xpTotalNoFluxo = (response.data['xp'] ?? 0).toInt(); //converte o xp em int
        });
      }
    } catch (e) {
      debugPrint("Erro ao carregar XP: $e");
    }
  }

  void _irParaProxima(int xpGanho) {
    setState(() {
      _xpTotalNoFluxo += xpGanho; 
      //soma o xp que o usario fez com que ele ja tinha
    });

    if (_currentIndex < widget.questoes.length - 1) {
      setState(() => _currentIndex++);
      //muda a questão se ele nao tiver terminado
    } else {
      Navigator.pop(context, _xpTotalNoFluxo); 
      //se ja tiver terminado fecha a aba de questoes
    }
  }

  @override
  Widget build(BuildContext context) {
    
    if (widget.questoes.isEmpty || _currentIndex >= widget.questoes.length) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    //verificacao, se a lista de questoes estiver vazia ou o indice estourar exibe uma barra de carregamento
    
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
      //pega a questao do currentIndex , pega as variaveis da API 
      //onFinalizado entrega o fluxo para para o AtvPage, avisando o fluxo quando deve avançar
    );
  }
}