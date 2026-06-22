import 'package:flutter/material.dart';

class ManagementBottomSheet extends StatelessWidget {
  final VoidCallback onCadastrar;
  final VoidCallback onEditar;
  final VoidCallback onExcluir;
  const ManagementBottomSheet({super.key, required this.onCadastrar, required this.onEditar, required this.onExcluir});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Gerenciar Categorias",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          ListTile(
            leading: const Icon(Icons.add_circle, color: Color(0xFF623FBD)),
            title: const Text("Criar Categoria"),
            onTap: onCadastrar
          ),
          ListTile(
            leading: const Icon(Icons.edit, color: Colors.orange),
            title: const Text("Editar Categoria"),
            onTap: onEditar,
          ),
          ListTile(
            leading: const Icon(Icons.delete, color: Colors.red),
            title: const Text("Excluir Categoria"),
            onTap: () {
              Navigator.pop(context);
              onExcluir();
            },
          ),
        ],
      ),
    );
  }
}