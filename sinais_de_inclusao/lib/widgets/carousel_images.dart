import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart' as carousel_slider;
//importa o pacote externo carousel_slider, as cria um tipo de apelido para o carrossel

class CarouselImages extends StatefulWidget {
  const CarouselImages({super.key});
//cria vinculo com a classe de estado privada _CarouselImages
  @override
  State<CarouselImages> createState() => _CarouselImagesState();
}

class _CarouselImagesState extends State<CarouselImages> {
  final List<List<String>> imageGroups = [
    [
      'assets/images/Sinal1.jpg',
      'assets/images/Sinal2.jpg',
    ],
    [
      'assets/images/Sinal3.jpg',
      'assets/images/Sinal4.jpg',
    ],
    [
      'assets/images/Sinal5.jpg',
      'assets/images/Sinal6.jpg',
    ],
  ];

  @override
  Widget build(BuildContext context) {
    return carousel_slider.CarouselSlider(
      //inicia o build que retorna o componente principal do carrossel importado da biblioteca externa

      options: carousel_slider.CarouselOptions(
        height: 300.0,
        autoPlay: true,
        //faz as imagens passarem sozinhas
        enlargeCenterPage: true,
        //da um efeito de centro/zoom
        viewportFraction: 0.8,
        //faz com que a
        aspectRatio: 16/9,
        //Define a proporção da tela
        initialPage: 0,
        //Garante que ele comece no index 0
      ),
      items: imageGroups.map((group) {
        //mapeia a ImageGroups, pegas os groups e transforma em um widget de slide individual
        return Builder(
          builder: (BuildContext context) {
            //para cada pagina do slide ele retorna uma linha - row, 
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: group.map((imagePath) {
                //mapeamento dos caminhos das imagens
                return Expanded(
                  //expandend- deixa o mesmo espaço para as duas imagens
                  child: Padding(
                    padding: const EdgeInsets.all(0.0), //padding 0, uma imagems fica encostada na outra
                    child: Image.asset( //careega a imagem
                      imagePath, // caminho da imagem
                      fit: BoxFit.cover, //estica e corta a imagem para ocupar todo espaço
                      height: 200,
                      width: 150
                    ),
                  ),
                );
              }).toList(),
              //os comandos .toList() fecham os mapeamentos e convertem os dados em listas  de widgets normais que flutter consegue ler
            );
          },
        );
      }).toList(),
    );
  }
}