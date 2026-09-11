import 'package:flutter/material.dart';
import 'package:sinais_de_inclusao/http/dio_client.dart';
import 'package:sinais_de_inclusao/widgets/custom_app_bar.dart';
import 'package:sinais_de_inclusao/widgets/footer_widget.dart';
import 'package:sinais_de_inclusao/widgets/menu_button.dart';

class SinaisPage extends StatefulWidget {
  final int idCategoria;
  final String nomeTema;
  const SinaisPage({
    super.key,
    required this.idCategoria,
    required this.nomeTema,
  });

  @override
  State<SinaisPage> createState() => _SinaisPageState();
}

class _SinaisPageState extends State<SinaisPage> {
  late Future<List<dynamic>> _sinaisFuture;

  final Set<int> _favoritosIds = {};
  @override
  void initState() {
    super.initState();

    _sinaisFuture = _fetchSinais();
    _fetchFavoritos();
  }

  Future<List<dynamic>> _fetchSinais() async {
    final dio = await DioClient.getInstance();

    final response = await dio.get('/categories/${widget.idCategoria}/signs');
    return response.data as List;
  }

  Future<void> _fetchFavoritos() async {
    try {
      final dio = await DioClient.getInstance();

      final response = await dio.get('/favorites/me');

      final List<dynamic> favoritos = response.data;

      if (!mounted) return;

      setState(() {
        _favoritosIds.clear();

        for (final favorito in favoritos) {
          final sinal = favorito['sign'] ?? favorito;

          if (sinal['id'] != null) {
            _favoritosIds.add(sinal['id']);
          }
        }
      });
    } catch (e) {
      debugPrint('Erro ao carregar favoritos: $e');
    }
  }

  Future<void> _toggleFavorito(int signId) async {
    try {
      final dio = await DioClient.getInstance();

      await dio.post('/favorites', data: {'signId': signId});

      if (!mounted) return;

      setState(() {
        if (_favoritosIds.contains(signId)) {
          _favoritosIds.remove(signId);
        } else {
          _favoritosIds.add(signId);
        }
      });
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao atualizar favorito.')),
      );

      debugPrint('Erro ao favoritar: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF623FBD),
      appBar: const CustomAppBar(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 25.0),
            child: Text(
              widget.nomeTema,
              style: const TextStyle(
                color: Color(0xFFFFB46E),
                fontSize: 36,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<dynamic>>(
              future: _sinaisFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  );
                }
                if (snapshot.hasError) {
                  return const Center(
                    child: Text(
                      "Erro ao carregar sinais",
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                }

                final sinais = snapshot.data ?? [];

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 22.0),
                  itemCount: sinais.length,
                  itemBuilder: (context, index) {
                    final sinal = sinais[index];
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
                    Navigator.pushReplacementNamed(context, '/temas');
                  },
                ),
              ),
              Expanded(
                child: _bottomMenuItem(
                  titulo: 'Favoritos',
                  icone: Icons.favorite,
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/favoritos');
                  },
                ),
              ),
              Expanded(
                child: _bottomMenuItem(
                  titulo: 'Perfil',
                  icone: Icons.person,
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/perfil');
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
    final int signId = sinal['id'];
    final bool favoritado = _favoritosIds.contains(signId);

    return Padding(
      padding: const EdgeInsets.only(bottom: 25.0),

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
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(25),
                    ),

                    child: Image.network(
                      sinal['image_path'] ?? '',
                      fit: BoxFit.contain,

                      errorBuilder: (c, e, s) =>
                          Image.asset('assets/images/logocirculo.png'),
                    ),
                  ),
                ),

                Positioned(
                  top: 10,
                  right: 10,

                  child: IconButton(
                    onPressed: () {
                      _toggleFavorito(signId);
                    },

                    icon: Icon(
                      favoritado ? Icons.favorite : Icons.favorite_border,

                      color: favoritado ? Colors.red : const Color(0xFF623FBD),

                      size: 32,
                    ),
                  ),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.only(bottom: 20, left: 20, right: 20),

              child: Text(
                sinal['name'] ?? 'Sem nome',

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
