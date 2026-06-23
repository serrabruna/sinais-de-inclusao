import 'package:flutter/material.dart';
import 'package:sinais_de_inclusao/modules/categoria/edicao_categoria.dart';

class SelecaoEdicaoPage extends StatelessWidget {
  final List<dynamic> temas;
  const SelecaoEdicaoPage({super.key, required this.temas});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Escolha o tema para editar")),
      body: ListView.builder(
        itemCount: temas.length,
        itemBuilder: (context, i) => ListTile(
          title: Text(temas[i]['name']),
          onTap: () => Navigator.push(
            context, 
            MaterialPageRoute(builder: (_) => EdicaoCategoriaPage(categoria: temas[i]))
          ),
        ),
      ),
    );
  }
}