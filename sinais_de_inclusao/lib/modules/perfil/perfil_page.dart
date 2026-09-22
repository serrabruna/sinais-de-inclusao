import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sinais_de_inclusao/http/dio_client.dart';
import 'package:sinais_de_inclusao/widgets/progresso_semanal.dart';
import 'package:sinais_de_inclusao/widgets/gradient_background.dart';
import 'package:sinais_de_inclusao/service/streak_service.dart';

class PerfilPage extends StatefulWidget {
  const PerfilPage({super.key});

  @override
  State<PerfilPage> createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
  bool _carregando = true;
  bool _salvandoAvatar = false;
  String? _erro;

  String _nome = '';
  String _email = '';
  int _xp = 0;
  int _nivel = 0;
  int _streak = 0;
  bool _streakAtivoHoje = false;
  List<Map<String, dynamic>> _atividadeSemanal = [];
  String _icone = 'face_1';
  int _avatarSelecionado = 0;

  final List<Map<String, dynamic>> avatares = [
    {'nome': 'face_1', 'icone': Icons.face},
    {'nome': 'face_2', 'icone': Icons.face_2},
    {'nome': 'face_3', 'icone': Icons.face_3},
    {'nome': 'face_4', 'icone': Icons.face_4},
    {'nome': 'face_5', 'icone': Icons.face_5},
    {'nome': 'face_6', 'icone': Icons.face_6},
    {'nome': 'smile', 'icone': Icons.sentiment_satisfied_alt},
    {'nome': 'account', 'icone': Icons.account_circle},
  ];

  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  
  Future<void> _carregarDados() async {
    await Future.wait([
      _carregarPerfil(),
      _carregarStreak(),
    ]);
  }

  Future<void> _carregarPerfil() async {
    try {
      final dio = await DioClient.getInstance();
      final response = await dio.get('/user/profile');
      final data = response.data;

      if (!mounted) return;

      setState(() {
        _nome = data['name']?.toString() ?? 'Usuário';
        _email = data['email']?.toString() ?? '';
        _xp = int.tryParse(data['xp']?.toString() ?? '') ?? (data['xp'] ?? 0);
        _nivel = int.tryParse(data['unlockedLevel']?.toString() ?? '') ?? (data['unlockedLevel'] ?? 0);
        _icone = data['icon']?.toString() ?? 'face_1';

        _avatarSelecionado = avatares.indexWhere(
          (avatar) => avatar['nome'] == _icone,
        );

        if (_avatarSelecionado == -1) {
          _avatarSelecionado = 0;
        }

        _carregando = false;
      });
    } catch (e) {
      debugPrint('Erro ao carregar perfil: $e');

      if (!mounted) return;

      setState(() {
        _erro = 'Não foi possível carregar o perfil.';
        _carregando = false;
      });
    }
  }

  Future<void> _carregarStreak() async {
    try {
      final status = await StreakService.obterStatusEsquenta();
      final semana = await StreakService.obterAtividadeSemanal();

      if (!mounted) return;

      setState(() {
        _streak = status['streak'] ?? 0;
        _streakAtivoHoje = status['ativoHoje'] ?? false;
        _atividadeSemanal = semana;
      });

      debugPrint('STREAK: $_streak | ATIVO HOJE: $_streakAtivoHoje');
    } catch (e) {
      debugPrint('ERRO AO CARREGAR STREAK: $e');
    }
  }

  Future<void> _salvarAvatar() async {
    try {
      setState(() {
        _salvandoAvatar = true;
      });

      final dio = await DioClient.getInstance();
      await dio.patch('/user/profile', data: {'name': _nome, 'icon': _icone});

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Avatar atualizado com sucesso!')),
      );
    } catch (e) {
      debugPrint('Erro ao salvar avatar: $e');

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Não foi possível atualizar o avatar.')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _salvandoAvatar = false;
        });
      }
    }
  }

  void _selecionarAvatar() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Escolha seu avatar',
                style: TextStyle(
                  color: Color(0xFF623FBD),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 25),
              GridView.builder(
                shrinkWrap: true,
                itemCount: avatares.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  mainAxisSpacing: 15,
                  crossAxisSpacing: 15,
                ),
                itemBuilder: (context, index) {
                  final selecionado = index == _avatarSelecionado;

                  return GestureDetector(
                    onTap: () async {
                      final avatarAnterior = _avatarSelecionado;
                      final iconeAnterior = _icone;

                      setState(() {
                        _avatarSelecionado = index;
                        _icone = avatares[index]['nome'] as String;
                      });

                      Navigator.pop(context);

                      try {
                        await _salvarAvatar();
                      } catch (e) {
                        if (!mounted) return;

                        setState(() {
                          _avatarSelecionado = avatarAnterior;
                          _icone = iconeAnterior;
                        });
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: selecionado
                            ? const Color(0xFF623FBD)
                            : const Color(0xFFFFB46E),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: selecionado
                              ? const Color(0xFFFFB46E)
                              : const Color(0xFF623FBD),
                          width: 3,
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 5,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(
                        avatares[index]['icone'] as IconData,
                        color: selecionado
                            ? Colors.white
                            : const Color(0xFF623FBD),
                        size: 38,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  Future<void> _sair() async {
    await StreakService.limparDadosLocais();

    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys();

    for (final key in keys) {
      if (key == 'token' ||
          key.startsWith('estrelas_categoria_') ||
          key.startsWith('esquenta_')) {
        await prefs.remove(key);
      }
    }

    if (!mounted) return;

    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF7458CF),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
        title: const Text(
          'Meu Perfil',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      extendBodyBehindAppBar: true,
      body: GradientBackground(
        child: SafeArea(
          child: _carregando
              ? const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                )
              : _erro != null
              ? Center(
                  child: Text(
                    _erro!,
                    style: const TextStyle(color: Colors.white),
                  ),
                )
              : RefreshIndicator(
                  color: const Color(0xFF623FBD),
                  onRefresh: _carregarDados,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: _salvandoAvatar ? null : _selecionarAvatar,
                          child: Stack(
                            children: [
                              Container(
                                width: 105,
                                height: 105,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFB46E),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 4,
                                  ),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.black26,
                                      blurRadius: 8,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: _salvandoAvatar
                                    ? const Padding(
                                        padding: EdgeInsets.all(30),
                                        child: CircularProgressIndicator(
                                          color: Color(0xFF623FBD),
                                          strokeWidth: 3,
                                        ),
                                      )
                                    : Icon(
                                        avatares[_avatarSelecionado]['icone']
                                            as IconData,
                                        size: 65,
                                        color: const Color(0xFF623FBD),
                                      ),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  width: 34,
                                  height: 34,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: const Color(0xFFFFB46E),
                                      width: 2,
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.edit,
                                    size: 17,
                                    color: Color(0xFF623FBD),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 15),
                        Text(
                          _nome,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          _email,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 30),
                        ProgressoSemanal(atividadeSemanal: _atividadeSemanal),
                        const SizedBox(height: 30),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 20,
                            horizontal: 10,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Row(
                            children: [
                              _estatistica(
                                Icons.star_rounded,
                                '$_xp',
                                'XP',
                                Colors.amber,
                              ),
                              _divisor(),
                              _estatistica(
                                Icons.emoji_events_rounded,
                                '$_nivel',
                                'Nível',
                                const Color(0xFF623FBD),
                              ),
                              _divisor(),
                              
                              _estatistica(
                                Icons.local_fire_department_rounded,
                                '$_streak',
                                _streakAtivoHoje ? 'Ofensiva ativa' : 'Pendente hoje',
                                _streakAtivoHoje ? Colors.orange : Colors.grey.shade400,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 25),
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Column(
                            children: [
                              _informacao(Icons.person_outline, 'Nome', _nome),
                              const Divider(height: 30),
                              _informacao(Icons.email_outlined, 'E-mail', _email),
                            ],
                          ),
                        ),
                        const SizedBox(height: 25),

                        
                        _botaoUpgradePremium(),

                        const SizedBox(height: 15),

                        
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton.icon(
                            onPressed: _sair,
                            icon: const Icon(Icons.logout_rounded),
                            label: const Text(
                              'Sair da conta',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white.withOpacity(0.18),
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                                side: const BorderSide(
                                  color: Colors.white38,
                                  width: 1.5,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }

  Widget _botaoUpgradePremium() {
    return Container(
      width: double.infinity,
      height: 54,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFFB46E), Color(0xFFFF8A00)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(25),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: ElevatedButton.icon(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Redirecionando para o Plano Premium...'),
            ),
          );
        },
        icon: const Icon(
          Icons.arrow_upward_rounded,
          color: Color(0xFF623FBD),
          size: 24,
        ),
        label: const Text(
          'Fazer Upgrade para Premium',
          style: TextStyle(
            color: Color(0xFF623FBD),
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
      ),
    );
  }

  Widget _estatistica(IconData icone, String valor, String titulo, Color cor) {
    return Expanded(
      child: Column(
        children: [
          Icon(icone, color: cor, size: 30),
          const SizedBox(height: 5),
          Text(
            valor,
            style: const TextStyle(
              color: Color(0xFF333333),
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            titulo,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.black54, fontSize: 11),
          ),
        ],
      ),
    );
  }

  Widget _divisor() {
    return Container(height: 45, width: 1, color: Colors.black12);
  }

  Widget _informacao(IconData icone, String titulo, String valor) {
    return Row(
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: const BoxDecoration(
            color: Color(0xFFF3F1FA),
            shape: BoxShape.circle,
          ),
          child: Icon(icone, color: const Color(0xFF623FBD), size: 22),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                titulo,
                style: const TextStyle(color: Colors.black45, fontSize: 12),
              ),
              const SizedBox(height: 2),
              Text(
                valor,
                style: const TextStyle(
                  color: Color(0xFF333333),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}