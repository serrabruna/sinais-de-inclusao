import 'package:flutter/material.dart';
import 'package:sinais_de_inclusao/widgets/custom_app_bar.dart';
import 'package:sinais_de_inclusao/widgets/footer_widget.dart'; 
import 'package:sinais_de_inclusao/widgets/full_width_button.dart';
import 'package:sinais_de_inclusao/widgets/menu_button.dart';

class TemasPage extends StatelessWidget {
  const TemasPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF623FBD),
      appBar: const CustomAppBar(),
      body: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.all(20.0),
            child: Text(
              "Temas\nQuais sinais você quer aprender hoje?",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white, 
                fontSize: 20, 
                fontWeight: FontWeight.bold
              ),
            ),
          ),
          
          // Grid dos Temas
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: GridView.count(
              shrinkWrap: true, 
              physics: const NeverScrollableScrollPhysics(), 
              crossAxisCount: 2,
              mainAxisSpacing: 20,
              crossAxisSpacing: 20,
              children: [
                MenuButton(titulo: "Animais", icone: Icons.pets, onPressed: () => print("Animais")),
                MenuButton(titulo: "Objetos", icone: Icons.menu_book, onPressed: () => print("Objetos")),
                MenuButton(titulo: "Saudações", icone: Icons.chat, onPressed: () => print("Saudações")),
                MenuButton(titulo: "Alimentos", icone: Icons.fastfood, onPressed: () => print("Alimentos")),
                MenuButton(titulo: "Cores", icone: Icons.palette, onPressed: () => print("Cores")),
                MenuButton(titulo: "Verbos", icone: Icons.directions_run, onPressed: () => print("Verbos")),
              ],
            ),
          ),
          
          const SizedBox(height: 30),
          
          // Botões de Gerenciamento
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                FullWidthButton(
                  titulo: "Gerenciar Temas", 
                  icone: Icons.settings, 
                  onPressed: () => print("Gerenciar Temas")
                ),
                const SizedBox(height: 15), 
                FullWidthButton(
                  titulo: "Gerenciar Questões", 
                  icone: Icons.help_outline, 
                  onPressed: () => print("Gerenciar Questões")
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 30), 
          const FooterWidget(),
        ],
      ),
    );
  }
}
