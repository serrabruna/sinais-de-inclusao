import 'package:flutter/material.dart';
import 'package:sinais_de_inclusao/http/dio_client.dart';
import 'package:sinais_de_inclusao/widgets/custom_app_bar.dart';
import 'package:sinais_de_inclusao/widgets/footer_widget.dart';

class FavoritosPage extends StatefulWidget {
  const FavoritosPage({super.key});

  @override
  State<FavoritosPage> createState() => _FavoritosPageState();
}

class _FavoritosPageState extends State<FavoritosPage> {
  late Future<List<dynamic>> _favoritosFuture;

  @override
  void initState() {
    super.initState();
    _favoritosFuture = _fetchFavoritos();
  }

  Future<List<dynamic>> _fetchFavoritos() async {
    try {
      final dio = await DioClient.getInstance();

      final response = await dio.get('/favorites/me');

      debugPrint('STATUS FAVORITOS: ${response.statusCode}');
      debugPrint('RETORNO FAVORITOS: ${response.data}');

      if (response.data is List) {
        return response.data as List<dynamic>;
      }

      return [];
    } catch (e) {
      debugPrint('ERRO AO BUSCAR FAVORITOS: $e');
      rethrow;
    }
  }

  Future<void> _toggleFavorito(int signId) async {
    try {
      final dio = await DioClient.getInstance();

      await dio.post('/favorites', data: {'signId': signId});

      if (!mounted) return;

      setState(() {
        _favoritosFuture = _fetchFavoritos();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sinal removido dos favoritos')),
      );
    } catch (e) {
      debugPrint('ERRO AO REMOVER FAVORITO: $e');

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao atualizar favorito')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF623FBD),

      appBar: const CustomAppBar(),

      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 25),
            child: Text(
              'Favoritos',
              style: TextStyle(
                color: Color(0xFFFFB46E),
                fontSize: 36,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          Expanded(
            child: FutureBuilder<List<dynamic>>(
              future: _favoritosFuture,

              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  );
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Erro ao carregar favoritos.\n${snapshot.error}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white),
                    ),
                  );
                }

                final favoritos = snapshot.data ?? [];

                if (favoritos.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.favorite_border,
                          color: Colors.white,
                          size: 70,
                        ),

                        SizedBox(height: 15),

                        Text(
                          'Nenhum sinal favoritado ainda.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        SizedBox(height: 8),

                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 35),
                          child: Text(
                            'Favorite os sinais que deseja encontrar mais facilmente.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 22),

                  itemCount: favoritos.length,

                  itemBuilder: (context, index) {
                    final favorito = favoritos[index];

                    debugPrint('FAVORITO $index: $favorito');

                    final sinal = favorito['sign'] ?? favorito;

                    return _buildCardSinal(sinal);
                  },
                );
              },
            ),
          ),
        ],
      ),

      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          height: 70,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: _bottomMenuItem(
                  titulo: 'Início',
                  icone: Icons.home,
                  onPressed: () {
                    Navigator.pushNamed(context, '/temas');
                  },
                ),
              ),
              Expanded(
                child: _bottomMenuItem(
                  titulo: 'Favoritos',
                  icone: Icons.favorite,
                  onPressed: () {
                    Navigator.pushNamed(context, '/favoritos');
                  },
                ),
              ),
              Expanded(
                child: _bottomMenuItem(
                  titulo: 'Perfil',
                  icone: Icons.person,
                  onPressed: () {
                    Navigator.pushNamed(context, '/perfil');
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCardSinal(dynamic sinal) {
    debugPrint('CARD SINAL: $sinal');

    final String imagePath = sinal['imagePath'] ?? '';

    return Padding(
      padding: const EdgeInsets.only(bottom: 25),

      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,

          borderRadius: BorderRadius.circular(25),

          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 6,
              offset: Offset(0, 4),
            ),
          ],
        ),

        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  height: 200,
                  width: double.infinity,

                  padding: const EdgeInsets.all(15),

                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(25),

                    child: imagePath.isNotEmpty
                        ? Image.network(
                            imagePath,

                            fit: BoxFit.contain,

                            errorBuilder: (context, error, stackTrace) {
                              debugPrint('ERRO IMAGEM: $error');

                              return Image.asset(
                                'assets/images/logocirculo.png',
                              );
                            },
                          )
                        : Image.asset('assets/images/logocirculo.png'),
                  ),
                ),

                Positioned(
                  top: 10,
                  right: 10,

                  child: IconButton(
                    icon: const Icon(
                      Icons.favorite,
                      color: Colors.red,
                      size: 32,
                    ),

                    onPressed: () {
                      final signId = sinal['id'] ?? sinal['signId'];

                      if (signId != null) {
                        _toggleFavorito(signId);
                      } else {
                        debugPrint('ID DO SINAL NÃO ENCONTRADO: $sinal');
                      }
                    },
                  ),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 25),

              child: Text(
                sinal['name'] ?? 'Sem nome',

                textAlign: TextAlign.center,

                style: const TextStyle(
                  color: Color(0xFF623FBD),

                  fontSize: 22,

                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _bottomMenuItem({
  required String titulo,
  required IconData icone,
  required VoidCallback onPressed,
}) {
  return InkWell(
    onTap: onPressed,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icone, size: 28, color: const Color(0xFF623FBD)),
        const SizedBox(height: 2),
        Text(
          titulo,
          style: const TextStyle(
            color: Color(0xFF623FBD),
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
  );
}
