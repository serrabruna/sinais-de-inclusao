// lib/screens/home_page.dart

import 'package:flutter/material.dart';
import 'package:sinais_de_inclusao/widgets/banner_widget.dart';
import 'package:sinais_de_inclusao/widgets/footer_widget.dart';

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
        backgroundColor: const  Color(0xFF7458CF),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset(
              'assets/images/logocirculo.png',
              height: 70, 
            ),
          ],
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            BannerWidget(),
            Image.asset(
                'assets/images/imagemHome.png'
            ),

            SizedBox(height: 38),
            
            Center(
              child: Text(
                'Aprenda de um jeito diferente!',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color:  Color(0xFF7458CF),
                ),
                textAlign: TextAlign.center,
              ),
            ),

            SizedBox(height: 20),

            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Aprenda Conosco!',
                  style: TextStyle(
                    fontSize: 24,
                    color:  Color(0xFF7458CF),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),

            SizedBox(height: 24),

            Center(
              child: Image.asset(
                'assets/images/imagemUsoHome1.png',
                height: 350,
                width: 320,
              ),
            ),

            SizedBox(height: 5),

            Center(
              child: Image.asset(
                'assets/images/imagemUsoHome2.png',
                height: 350,
                width: 320,
              ),
            ),

            SizedBox(height: 5),

            Center(
              child: Image.asset(
                'assets/images/ImagemUsoHome3.png',
                height: 350,
                width: 320,
              ),
            ),

            SizedBox(height: 5),

            Center(
              child: Image.asset(
                'assets/images/ImagemUsoHome4.png',
                height: 350,
                width: 320,
              ),
            ),

            FooterWidget(),
          ],
        ),
      ),
    );
  }
}