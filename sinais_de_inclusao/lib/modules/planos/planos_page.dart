import 'package:flutter/material.dart';
import 'package:sinais_de_inclusao/widgets/gradient_background.dart';

class PlanosPage extends StatefulWidget {
  const PlanosPage({super.key});

  @override
  State<PlanosPage> createState() => _PlanosPageState();
}

class _PlanosPageState extends State<PlanosPage> {
  
  int _planoSelecionado = 1; 
  bool _processandoAssinatura = false;

  final List<Map<String, dynamic>> _planos = [
    {
      'id': 'mensal',
      'titulo': 'Mensal',
      'preco': 'R\$ 19,90',
      'periodo': '/mês',
      'descricao': 'Cancele quando quiser',
      'badge': null,
    },
    {
      'id': 'anual',
      'titulo': 'Anual',
      'preco': 'R\$ 14,90',
      'periodo': '/mês',
      'detalhe': 'R\$ 178,80 faturado anualmente',
      'badge': 'ECONOMIZE 25%',
    },
  ];

  final List<Map<String, dynamic>> _beneficios = [
    {
      'icone': Icons.block_rounded,
      'titulo': 'Sem Anúncios',
      'descricao': 'Aprenda sem interrupções nem distrações.',
      'cor': Colors.redAccent,
    },
    {
      'icone': Icons.all_inclusive_rounded,
      'titulo': 'Vidas Infinitas',
      'descricao': 'Erre o quanto precisar sem ter que esperar recarregar.',
      'cor': Colors.pinkAccent,
    },
    {
      'icone': Icons.auto_awesome_rounded,
      'titulo': 'Melhor Prática & Revisão',
      'descricao': 'Modo de treino inteligente focado nos seus erros e dúvidas.',
      'cor': Colors.amber,
    },
  ];

  Future<void> _assinarPlano() async {
    setState(() {
      _processandoAssinatura = true;
    });

    try {
      final plano = _planos[_planoSelecionado];

      
      await Future.delayed(const Duration(seconds: 2)); 

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Plano ${plano['titulo']} assinado com sucesso! 🎉'),
          backgroundColor: const Color(0xFF623FBD),
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Falha ao processar assinatura. Tente novamente.'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _processandoAssinatura = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF7458CF),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded, size: 28),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          TextButton(
            onPressed: () {
              
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Restaurando compras anteriores...')),
              );
            },
            child: const Text(
              'Restaurar',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: GradientBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
            child: Column(
              children: [
                
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFB46E),
                    shape: BoxShape.circle,
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.workspace_premium_rounded,
                    size: 48,
                    color: Color(0xFF623FBD),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Eleve o seu aprendizado',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Desbloqueie todo o potencial com o Plano Premium',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 25),

                
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: _beneficios.map((b) => _buildItemBeneficio(b)).toList(),
                  ),
                ),
                const SizedBox(height: 25),

                
                Row(
                  children: List.generate(_planos.length, (index) {
                    final plano = _planos[index];
                    final selecionado = _planoSelecionado == index;

                    return Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(
                          right: index == 0 ? 8.0 : 0,
                          left: index == 1 ? 8.0 : 0,
                        ),
                        child: _buildCardOpcaoPlano(
                          plano: plano,
                          selecionado: selecionado,
                          onTap: () {
                            setState(() {
                              _planoSelecionado = index;
                            });
                          },
                        ),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 25),

                
                Container(
                  width: double.infinity,
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFFB46E), Color(0xFFFF8A00)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: _processandoAssinatura ? null : _assinarPlano,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                    ),
                    child: _processandoAssinatura
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: Color(0xFF623FBD),
                              strokeWidth: 3,
                            ),
                          )
                        : const Text(
                            'Continuar para Pagamento',
                            style: TextStyle(
                              color: Color(0xFF623FBD),
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 16),

                
                const Text(
                  'A renovação é automática. Você pode cancelar a qualquer momento nas configurações da sua conta.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white60,
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildItemBeneficio(Map<String, dynamic> item) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: (item['cor'] as Color).withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(
              item['icone'] as IconData,
              color: item['cor'] as Color,
              size: 24,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['titulo'] as String,
                  style: const TextStyle(
                    color: Color(0xFF333333),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  item['descricao'] as String,
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardOpcaoPlano({
    required Map<String, dynamic> plano,
    required bool selecionado,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 14),
            decoration: BoxDecoration(
              color: selecionado ? Colors.white : Colors.white.withOpacity(0.85),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: selecionado ? const Color(0xFFFFB46E) : Colors.transparent,
                width: 3,
              ),
              boxShadow: [
                BoxShadow(
                  color: selecionado ? Colors.black26 : Colors.black12,
                  blurRadius: selecionado ? 8 : 4,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  plano['titulo'] as String,
                  style: TextStyle(
                  color: selecionado ? const Color(0xFF623FBD) : Colors.black87,                    
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      plano['preco'] as String,
                      style: const TextStyle(
                        color: Color(0xFF333333),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      plano['periodo'] as String,
                      style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                if (plano['detalhe'] != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    plano['detalhe'] as String,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.black45,
                      fontSize: 11,
                    ),
                  ),
                ] else if (plano['descricao'] != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    plano['descricao'] as String,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.black45,
                      fontSize: 11,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (plano['badge'] != null)
            Positioned(
              top: -10,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF8A00),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    plano['badge'] as String,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}