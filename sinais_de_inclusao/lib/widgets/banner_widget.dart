import 'package:flutter/material.dart';
//importa o material oficial do flutter -> Sacaffold, Container, Text, ElevatedButton
import 'package:sinais_de_inclusao/widgets/carousel_images.dart';

class BannerWidget extends StatefulWidget {
  const BannerWidget({super.key});
  //cria a classe principal do componente chamado BannerWidget

  @override
  State<BannerWidget> createState() => _BannerWidgetState();
  //sobrescreve o metordo createState, conectando com o Banner widget sate
}

class _BannerWidgetState extends State<BannerWidget> {
  @override
  Widget build(BuildContext context) {
    //método build, é executado toda vez que o flutter desenha o elemento na tela
    return Container(
      width: double.infinity,
      //esticar até as bordas laterais do celular
      padding: const EdgeInsets.all(18.0),
      //suspiro interno de 18px
      color: Color(0xFF7458CF),
      child: SingleChildScrollView(
        //Permite que o conteudo role verticalmente se a tela do celular for pequena demais
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,//centralizar tudo
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Sinais de Inclusão',
              style: TextStyle(color: Colors.white, fontSize: 28),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24),
            Text(
              'Um aplicativo que ensina Libras de forma prática, dinâmica e gratuita.',
              style: TextStyle(color: Colors.white, fontSize: 18),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 26),
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min, //ocupar apenas o espaço necessario ps botoes
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/cadastro');
                      //executa o toque do usuario e chama a rota cadastro
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFEDAD6B),
                      minimumSize: Size(150, 50),
                    ),
                    child: Text(
                      'Cadastrar',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),

                  SizedBox(height: 16),

                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/login');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFEDAD6B),
                      minimumSize: Size(150, 50),
                    ),
                    child: Text(
                      'Login',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),

                  SizedBox(height: 24),
                  //renderizacao do carrossel
                  const CarouselImages(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
