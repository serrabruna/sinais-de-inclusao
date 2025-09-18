import 'package:flutter/material.dart';
import 'package:sinais_de_inclusao/widgets/carousel_images.dart';

class BannerWidget extends StatefulWidget{
  const BannerWidget({super.key});

  @override
  State<BannerWidget> createState() => _BannerWidgetState();
}

class _BannerWidgetState extends State<BannerWidget> {
  @override
  Widget build(BuildContext context){
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18.0),
      color: Color(0xFF152763),
      child : SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Sinais de Inclusão',
              style: TextStyle(
                color: Color(0xFFEDAD6B),
                fontSize: 28,
              ),
            ),

            Text(
            'Um aplicativo que ensina Libras de forma prática, dinâmica e gratuita.',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),

            SizedBox(height: 24),
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      //Direcionar para a página de cadastro
                    }, 
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFEDAD6B),
                      minimumSize: Size(150, 50)
                    ),
                    child: Text('Cadastrar'),
                  ),

                  SizedBox(height: 16),

                  ElevatedButton(onPressed: () {
                    //Direcionar para a página de login
                    }, 
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFEDAD6B),
                      minimumSize: Size(150, 50)
                    ),
                    child: Text('Login'),
                  ),

                  SizedBox(height: 24),
                  const CarouselImages(),
                ],
              ),
            )
          ],

        )
      )
    );
  }
}