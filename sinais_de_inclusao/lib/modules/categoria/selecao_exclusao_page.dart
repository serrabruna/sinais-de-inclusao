import 'package:flutter/material.dart';
import 'package:sinais_de_inclusao/modules/categoria/excluir_categoria.dart';

class SelecaoExclusaoPage extends StatelessWidget {
  final List<dynamic> temas;
  const SelecaoExclusaoPage({super.key, required this.temas});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Escolha para excluir")),
      body: ListView.builder(
        itemCount: temas.length,
        itemBuilder: (context, i) => ListTile(
          title: Text(temas[i]['name']),
          trailing: const Icon(Icons.delete, color: Colors.red),
          onTap: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => ExcluirCategoriaPage(categoria: temas[i]))
            );
            if (result == true) Navigator.pop(context); 
          },
        ),
      ),
    );
  }
}