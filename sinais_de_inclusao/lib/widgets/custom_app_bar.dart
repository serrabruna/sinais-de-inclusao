import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
//importa o pacote Shared , usado para salvar e ler dados simples diretamente no armazenamento interno do celular - nesse casso a utenticação do usuario

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  //implementaa o PreferredSizeWidget - exigido pra appbar no flutter
  const CustomAppBar({super.key});

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(100);
  //sobrescreve o metodo obg PreferredSizeWidget, define a altura da barrra com 100 px
}

class _CustomAppBarState extends State<CustomAppBar> {
  bool _autenticado = false; //cmc como falsa, ve se o usuario esta logado ou nao

  @override
  void initState() {
    super.initState();
    _verificarAutenticacao();
  }
  //sobrescreve o ciclo de vida initStatt, checa o login imediatamente

  Future<void> _verificarAutenticacao() async {
    //funcao assincrona de verificar a autentificacao
    final prefs = await SharedPreferences.getInstance();
    //instancia a shared Preferences

    final token = prefs.getString('token');
    //tenta ler uma string chamada token

    if (mounted) {
      //se ainda esta no app, aberto, evitar erros
      setState(() {
        //chama o setState, e muda o autenticado para vdd se o token nao for nulo e nao estiver vazio
        _autenticado = token != null && token.isNotEmpty;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 100,
      //altura interna 100px
      backgroundColor: const Color(0xFF623FBD),
      elevation: 0,
      //remove a sombra padrao - 0
      title: Image.asset('assets/images/logocirculo.png', height: 70),
      actions: [
        //coloca um menu a direita, um pop menu burron, que abre ao clicar nele
        PopupMenuButton<String>(
          icon: const Icon(Icons.menu, color: Colors.white, size: 35),

          onSelected: (value) async {
            if (value == 'temas') {
              Navigator.pushNamed(context, '/temas');
              //se o usuario selecionar a opção temas leva para a pagina temas
            } else if (value == 'logout') {
              final prefs = await SharedPreferences.getInstance();
              //abre a instancia do banco de dados local do celular, como é uma operação de leitura/escrita usa se await
              await prefs.remove('token');
              await prefs.remove('role');
              //apaga as chaves de seguraça
              if (context.mounted) {
                //verifica se a tela ainda existe associalda ao contexto visual
                Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
                //vai para a pagina home, destroi todas as telas anteriores que estavam salvas na memoria
              }
            }
          },
          itemBuilder: (BuildContext context) => [
            if (_autenticado)
            //so aparece se o usuario estiver autenticado
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
      //esconde o menu automatico
    );
  }
}