// lib/screens/home_page.dart

import 'package:flutter/material.dart';
import 'package:sinais_de_inclusao/widgets/banner_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}


class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        backgroundColor: const Color(0xFF152763),
        title: Image.asset(
          'assets/images/logocirculo.png',
          height: 70, 
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      endDrawer: Drawer(
        backgroundColor: const Color(0xFF152763),
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xFF152763),
              ),
              child: Text (
                'Menu',
                style:TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                )
              )
            ),

            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              iconColor: Colors.white,
              textColor: Colors.white,
              onTap: () {
                Navigator.pop(context);
              },
            ),

            ListTile(
              leading: const Icon(Icons.group),
              title: const Text('Equipe'),
              iconColor: Colors.white,
              textColor: Colors.white,
              onTap: () {
                Navigator.pop(context);
              },
            ),

            ListTile(
              leading: const Icon(Icons.contact_mail),
              title: const Text('Contato'),
              iconColor: Colors.white,
              textColor: Colors.white,
              onTap: () {
                Navigator.pop(context);
              },
            ),

            ListTile(
              leading: const Icon(Icons.description),
              title: const Text('Plano'),
              iconColor: Colors.white,
              textColor: Colors.white,
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
            const BannerWidget(),
        ],
      )
    );
  }
}