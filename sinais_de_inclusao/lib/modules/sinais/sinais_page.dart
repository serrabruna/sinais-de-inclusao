import 'package:flutter/material.dart';
import 'package:sinais_de_inclusao/http/dio_client.dart';
import 'package:sinais_de_inclusao/widgets/custom_app_bar.dart';
import 'package:sinais_de_inclusao/widgets/footer_widget.dart';

class SinaisPage extends StatefulWidget {
  final int idCategoria;
  final String nomeTema;
  const SinaisPage({super.key, required this.idCategoria, required this.nomeTema});

  @override
  State<SinaisPage> createState() => _SinaisPageState();
}

class _SinaisPageState extends State<SinaisPage> {
  late Future<List<dynamic>> _sinaisFuture;

  @override
  void initState() {
    super.initState();
    _sinaisFuture = _fetchSinais();
  }

  Future<List<dynamic>> _fetchSinais() async {
    final dio = await DioClient.getInstance();
    
    final response = await dio.get('/categories/${widget.idCategoria}/signs');
    return response.data as List;
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
              style: const TextStyle(color: Color(0xFFFFB46E), fontSize: 36, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<dynamic>>(
              future: _sinaisFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(color: Colors.white));
                }
                if (snapshot.hasError) {
                  return const Center(child: Text("Erro ao carregar sinais", style: TextStyle(color: Colors.white)));
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
    );
  }

  
  Widget _buildCardSinal(dynamic sinal) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 25.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            const BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, 4))
          ],
        ),
        child: Column(
          children: [
            // Imagem
            Container(
              height: 200,
              padding: const EdgeInsets.all(15),
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
                child: Image.network(
                  sinal['imagePath'] ?? '',
                  fit: BoxFit.contain,
                  errorBuilder: (c, e, s) => Image.asset('assets/images/logocirculo.png'),
                ),
              ),
            ),
            // Título
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0, left: 20.0, right: 20.0),
              child: Text(
                sinal['name'] ?? 'Sem nome', 
                style: const TextStyle(
                  color: Color(0xFF623FBD), 
                  fontSize: 22, 
                  fontWeight: FontWeight.bold
                )
              ),
            ),
          ],
        ),
      ),
    );
  }
}