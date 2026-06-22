import 'package:flutter/material.dart';

class TrilhaPage extends StatefulWidget {
  @override
  State<TrilhaPage> createState() => _TrilhaPageState();
}

class _TrilhaPageState extends State<TrilhaPage> {
  int _vidas = 5;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF623FBD),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.close,
                      color: Colors.white70,
                      size: 30,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Text(
                          '$_vidas ',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const Icon(
                          Icons.favorite,
                          color: Color.fromARGB(255, 224, 131, 122),
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: 80,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: const Icon(
                Icons.home_outlined,
                color: Colors.black38,
                size: 32,
              ),
              onPressed: () {},
            ),
            Image.asset('assets/images/logocirculo.png', height: 50),
            IconButton(
              icon: const Icon(
                Icons.bookmark_border,
                color: Colors.black38,
                size: 32,
              ),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
