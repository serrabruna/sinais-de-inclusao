import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 100,
      backgroundColor: const Color(0xFF623FBD),
      elevation: 0,
      title: Image.asset('assets/images/logocirculo.png', height: 70),
      actions: [
        IconButton(
          icon: const Icon(Icons.menu, color: Colors.white, size: 35),
          onPressed: () {},
        ),
        const SizedBox(width: 10),
      ],
      automaticallyImplyLeading: false,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(100);
}