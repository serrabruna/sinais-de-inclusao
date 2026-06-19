import 'package:flutter/material.dart';
import 'package:sinais_de_inclusao/widgets/custom_app_bar.dart';
import 'package:sinais_de_inclusao/widgets/footer_widget.dart'; 

class TemasPage extends StatelessWidget {
  const TemasPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF623FBD),
      appBar: const CustomAppBar(),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(20.0),
            child: Text(
              "Temas\nQuais sinais você quer aprender hoje?",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              padding: const EdgeInsets.all(20),
              mainAxisSpacing: 20,
              crossAxisSpacing: 20,
              children: [
                _buildCard("Animais", Icons.pets),
                _buildCard("Objetos", Icons.menu_book),
                _buildCard("Saudações", Icons.chat),
                _buildCard("Alimentos", Icons.fastfood),
                _buildCard("Cores", Icons.palette),
                _buildCard("Verbos", Icons.directions_run),
              ],
            ),
          ),
          const FooterWidget(),
        ],
      ),
    );
  }

  Widget _buildCard(String titulo, IconData icone) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFFB76F),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icone, size: 50, color: const Color(0xFF623FBD)),
          Text(titulo, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        ],
      ),
    );
  }
}