import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(100);
}

class _CustomAppBarState extends State<CustomAppBar> {
  bool _autenticado = false;

  @override
  void initState() {
    super.initState();
    _verificarAutenticacao();
  }

  Future<void> _verificarAutenticacao() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (mounted) {
      setState(() {
        _autenticado = token != null && token.isNotEmpty;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 100,
      backgroundColor: const Color(0xFF623FBD),
      elevation: 0,
      title: Image.asset('assets/images/logocirculo.png', height: 70),
      actions: [
        PopupMenuButton<String>(
          icon: const Icon(Icons.menu, color: Colors.white, size: 35),
          onSelected: (value) async {
            if (value == 'temas') {
              Navigator.pushNamed(context, '/temas');
            } else if (value == 'logout') {
              final prefs = await SharedPreferences.getInstance();
              await prefs.remove('token');
              await prefs.remove('role');

              if (context.mounted) {
                Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
              }
            }
          },
          itemBuilder: (BuildContext context) => [
            if (_autenticado)
              const PopupMenuItem<String>(
                value: 'temas',
                child: Row(
                  children: [
                    Icon(Icons.menu_book, color: Color(0xFF623FBD)),
                    SizedBox(width: 10),
                    Text("Temas"),
                  ],
                ),
              ),
            const PopupMenuItem<String>(
              value: 'logout',
              child: Row(
                children: [
                  Icon(Icons.logout, color: Colors.red),
                  SizedBox(width: 10),
                  Text("Sair"),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(width: 10),
      ],
      automaticallyImplyLeading: false,
    );
  }
}