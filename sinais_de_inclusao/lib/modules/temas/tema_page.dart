import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sinais_de_inclusao/classes/icon_mapper.dart';
import 'package:sinais_de_inclusao/http/dio_client.dart';
import 'package:sinais_de_inclusao/modules/categoria/selecao_edicao_page.dart';
import 'package:sinais_de_inclusao/modules/categoria/selecao_exclusao_page.dart';
import 'package:sinais_de_inclusao/modules/sinais/sinais_page.dart'; // Importe sua SinaisPage
import 'package:sinais_de_inclusao/widgets/custom_app_bar.dart';
import 'package:sinais_de_inclusao/widgets/footer_widget.dart';
import 'package:sinais_de_inclusao/widgets/full_width_button.dart';
import 'package:sinais_de_inclusao/widgets/management_bottom_sheet.dart';
import 'package:sinais_de_inclusao/widgets/menu_button.dart';

class TemasPage extends StatefulWidget {
  const TemasPage({super.key});

  @override
  State<TemasPage> createState() => _TemasPageState();
}

class _TemasPageState extends State<TemasPage> {
  late Future<List<dynamic>> _temasFuture;
  bool _isAdmin = false;

  @override
  void initState() {
    super.initState();
    _temasFuture = _fetchTemas();
    _checkUserRole();
  }

  Future<void> _checkUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isAdmin = prefs.getString('role') == 'admin';
    });
  }

  Future<List<dynamic>> _fetchTemas() async {
    final dio = await DioClient.getInstance();
    final response = await dio.get('/categories');
    return response.data as List;
  }

  void _recarregarTemas() {
    setState(() {
      _temasFuture = _fetchTemas();
    });
  }

  void _mostrarOpcoesGerenciamento(BuildContext context, List<dynamic> temasAtuais) {
    showModalBottomSheet(
      context: context,
      builder: (context) => ManagementBottomSheet(
        onCadastrar: () async {
          Navigator.pop(context);
          await Navigator.pushNamed(context, '/cadastro-categoria');
          _recarregarTemas();
        },
        onEditar: () {
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SelecaoEdicaoPage(temas: temasAtuais)),
          ).then((_) => _recarregarTemas());
        },
        onExcluir: () {
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SelecaoExclusaoPage(temas: temasAtuais)),
          ).then((_) => _recarregarTemas());
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF623FBD),
      appBar: const CustomAppBar(),
      body: FutureBuilder<List<dynamic>>(
        future: _temasFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Colors.white));
          }
          if (snapshot.hasError || !snapshot.hasData) {
            return const Center(child: Text("Erro ao carregar temas", style: TextStyle(color: Colors.white)));
          }

          final temas = snapshot.data!;

          return ListView(
            children: [
              const Padding(
                padding: EdgeInsets.all(20.0),
                child: Text(
                  "Temas\nQuais sinais você quer aprender hoje?",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: temas.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, mainAxisSpacing: 20, crossAxisSpacing: 20,
                  ),
                  itemBuilder: (context, index) {
                    final tema = temas[index];
                    final String nome = tema is Map ? tema['name'] : tema.toString();
                    final int id = tema is Map ? tema['id'] : index;

                    return MenuButton(
                      titulo: nome,
                      icone: IconMapper.getIcon(nome),
                      onPressed: () {
                        // Navegação para a página de sinais
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SinaisPage(
                              idCategoria: id,
                              nomeTema: nome,
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),

              if (!_isAdmin) ...[
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: FullWidthButton(
                    titulo: "Começar Atividades",
                    icone: Icons.play_arrow,
                    onPressed: () => Navigator.pushNamed(context, '/trilha'),
                  ),
                ),
              ],
              
              if (_isAdmin) ...[
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      FullWidthButton(
                        titulo: "Gerenciar Temas",
                        icone: Icons.settings,
                        onPressed: () => _mostrarOpcoesGerenciamento(context, temas),
                      ),
                      const SizedBox(height: 15),
                      FullWidthButton(
                        titulo: "Gerenciar Questões",
                        icone: Icons.help_outline,
                        onPressed: () => Navigator.pushNamed(context, '/listagem_questoes')
                            .then((_) => _recarregarTemas()),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 30),
              const FooterWidget(),
            ],
          );
        },
      ),
    );
  }
}