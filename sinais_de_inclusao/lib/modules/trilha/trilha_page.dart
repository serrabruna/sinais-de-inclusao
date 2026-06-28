import 'package:flutter/material.dart';
import 'package:sinais_de_inclusao/classes/icon_mapper.dart';
import 'package:sinais_de_inclusao/http/dio_client.dart';
import 'package:sinais_de_inclusao/widgets/flow_atividades_page.dart';

class TrilhaPage extends StatefulWidget {
  const TrilhaPage({super.key});

  @override
  State<TrilhaPage> createState() => _TrilhaPageState();
}

class _TrilhaPageState extends State<TrilhaPage> {
  int _xpTotal = 0;
  late Future<List<dynamic>> _categoriasFuture;
  bool _isLoadingXp = true;

  @override
  void initState() {
    super.initState();
    _categoriasFuture = _fetchCategorias();
    _fetchXP();
  }

  Future<List<dynamic>> _fetchCategorias() async {
    final dio = await DioClient.getInstance();
    final response = await dio.get('/categories');
    return response.data as List;
  }

  Future<void> _fetchXP() async {
  try {
    final dio = await DioClient.getInstance();
    final response = await dio.get('/user/xp'); 
    
    if (mounted && response.data != null) {
      setState(() {
        _xpTotal = (response.data['xp'] ?? 0).toInt();
        _isLoadingXp = false;
      });
    }
  } catch (e) {
    debugPrint("Erro ao carregar XP: $e");
    if (mounted) setState(() => _isLoadingXp = false);
  }
}

  void _iniciarTrilha(int idCategoria) async {
    try {
      final dio = await DioClient.getInstance();
      final response = await dio.get('/categories/$idCategoria/signs');
      final List<dynamic> questoes = (response.data is List)
          ? response.data
          : [];

      if (questoes.isNotEmpty) {
        if (!mounted) return;

        final novoXp = await Navigator.push<int>(
          context,
          MaterialPageRoute(
            builder: (context) => FlowAtividadesPage(questoes: questoes),
          ),
        );

        if (novoXp != null) {
          setState(() {
            _xpTotal = novoXp;
          });
        } else {
          _fetchXP();
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Nenhuma atividade disponível neste tema."),
          ),
        );
      }
    } catch (e) {
      debugPrint("Erro ao carregar sinais: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF623FBD),
      body: SafeArea(
        child: FutureBuilder<List<dynamic>>(
          future: _categoriasFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting ||
                _isLoadingXp) {
              return const Center(
                child: CircularProgressIndicator(color: Colors.white),
              );
            }
            if (!snapshot.hasData || snapshot.hasError) {
              return const Center(
                child: Text(
                  "Erro ao carregar trilha",
                  style: TextStyle(color: Colors.white),
                ),
              );
            }

            final categorias = snapshot.data!;

            return Column(
              children: [
                _buildHeader(),
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: Column(
                        children: List.generate(categorias.length, (index) {
                          double bias = index % 3 == 0
                              ? 0.0
                              : (index % 3 == 1 ? -0.6 : 0.6);
                          return _construirItemTrilha(
                            categorias[index],
                            index,
                            bias: bias,
                          );
                        }),
                      ),
                    ),
                  ),
                ),
                _buildFooter(),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _construirItemTrilha(
    dynamic categoria,
    int index, {
    required double bias,
  }) {
    final String nome = (categoria['name'] ?? 'Desconhecido').toString();
    final int id = (categoria['id'] ?? 0).toInt();
    final bool estaLiberado = _xpTotal >= (index * 100);

    return AlignmentPlatform(
      alignment: Alignment(bias, 0.0),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Opacity(
          opacity: estaLiberado ? 1.0 : 0.4,
          child: GestureDetector(
            onTap: estaLiberado
                ? () => _iniciarTrilha(id)
                : () => ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Bloqueado! Complete níveis anteriores.'),
                    ),
                  ),
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 95,
                      height: 95,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 5,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Icon(
                        IconMapper.getIcon(nome),
                        size: 45,
                        color: const Color(0xFF623FBD),
                      ),
                    ),
                    if (!estaLiberado)
                      const Positioned(
                        bottom: 0,
                        right: 4,
                        child: CircleAvatar(
                          radius: 12,
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.lock,
                            color: Color(0xFF623FBD),
                            size: 14,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  nome,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() => Padding(
    padding: const EdgeInsets.all(20.0),
    child: Column( 
      children: [
        Row( 
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(Icons.close, color: Colors.white70, size: 30),
              onPressed: () => Navigator.pop(context),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Text(
                    '$_xpTotal ',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const Icon(Icons.star, color: Colors.amber, size: 22),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 20), 
        const Text(
          "Faça 100 pontos para desbloquear um novo nível",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white70, 
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    ),
  );

  Widget _buildFooter() => Container(
    height: 80,
    decoration: const BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        IconButton(
          icon: const Icon(Icons.home, color: Color(0xFF623FBD), size: 32),
          onPressed: () {},
        ),
        Image.asset('assets/images/logocirculo.png', height: 50),
        IconButton(
          icon: const Icon(
            Icons.bookmark_border,
            color: Colors.black38,
            size: 32,
          ),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Em breve!"),
                duration: Duration(seconds: 2),
              ),
            );
          },
        ),
      ],
    ),
  );
}

class AlignmentPlatform extends StatelessWidget {
  final Alignment alignment;
  final Widget child;
  const AlignmentPlatform({
    super.key,
    required this.alignment,
    required this.child,
  });
  @override
  Widget build(BuildContext context) => Align(
    alignment: alignment,
    child: SizedBox(width: 140, child: child),
  );
}
