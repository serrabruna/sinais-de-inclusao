import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:sinais_de_inclusao/http/dio_client.dart';
import 'package:sinais_de_inclusao/model/sign_model.dart';
import 'package:sinais_de_inclusao/modules/questoes/edicao_questao.dart';
import 'package:sinais_de_inclusao/modules/questoes/excluir_questao.dart';
import 'package:sinais_de_inclusao/widgets/custom_app_bar.dart';

class ListagemQuestoesPage extends StatefulWidget {
  const ListagemQuestoesPage({super.key});

  @override
  State<ListagemQuestoesPage> createState() => _ListagemQuestoesPageState();
}

class _ListagemQuestoesPageState extends State<ListagemQuestoesPage> {
  late Future<List<SignModel>> _questoesFuture;

  @override
  void initState() {
    super.initState();
    _recarregarQuestoes();
  }

  void _recarregarQuestoes() {
    setState(() {
      _questoesFuture = _fetchQuestoes();
    });
  }

  Future<List<SignModel>> _fetchQuestoes() async {
    try {
      final dio = await DioClient.getInstance();
      
      final response = await dio.get('/signs'); 

      print("DEBUG - Dados da resposta: ${response.data}");

      if (response.data is List) {
        final List<dynamic> data = response.data;
        return data.map((json) => SignModel.fromJson(json)).toList();
      } else {
        print("DEBUG - O formato dos dados não é uma lista direta!");
        return [];
      }
    } on DioException catch (e) {
      print("DEBUG - Erro na requisição: ${e.message}");
      return [];
    }
  }
  void _abrirMenuQuestao(SignModel questao) {
  showModalBottomSheet(
    context: context,
    builder: (context) => Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("Questão: ${questao.name}", 
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.edit, color: Colors.blue),
            title: const Text("Editar Questão"),
            onTap: () {
              Navigator.pop(context); 
              
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EdicaoQuestaoPage(questao: questao),
                ),
              ).then((deveRecarregar) {
                if (deveRecarregar == true) _recarregarQuestoes();
              });
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete, color: Colors.red),
            title: const Text("Excluir Questão"),
            onTap: () {
              Navigator.pop(context); 
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ExcluirQuestaoPage(questao: questao),
                ),
              ).then((deveRecarregar) {
                if (deveRecarregar == true) _recarregarQuestoes();
              });
            },
          ),
        ],
      ),
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFFFB46E),
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.pushNamed(context, '/cadastro-questao').then((_) => _recarregarQuestoes());
        },
      ),
      body: Column(
        children: [
          const SizedBox(height: 10), 
          Expanded( 
            child: FutureBuilder<List<SignModel>>(
              future: _questoesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("Nenhuma questão cadastrada ou erro na conexão."));
                }

                final questoes = snapshot.data!;

                return ListView.builder(
                  itemCount: questoes.length,
                  itemBuilder: (context, i) {
                    return ListTile(
                      title: Text(questoes[i].name),
                      subtitle: Text(questoes[i].statement),
                      leading: const Icon(Icons.help_outline),
                      onTap: () => _abrirMenuQuestao(questoes[i]),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}