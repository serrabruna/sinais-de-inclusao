import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:sinais_de_inclusao/http/dio_client.dart';
import 'package:ultralytics_yolo/ultralytics_yolo.dart';

class PraticaPage extends StatefulWidget {
  const PraticaPage({super.key});

  @override
  State<PraticaPage> createState() => _PraticaPageState();
}

class _PraticaPageState extends State<PraticaPage> {
  int tempoRestante = 30;
  Timer? _timer;
  final List<String> sinaisDisponiveis = [
    'A',
    'B',
    'C',
    'D',
    'E',
    'F',
    'G',
    'I',
    'L',
    'M',
    'N',
    'O',
    'P',
    'Q',
    'R',
    'S',
    'T',
    'U',
    'V',
    'W',
    'Y',
  ];

  late String sinalAlvo;
  String sinalDetectado = 'Nenhum';
  double confianca = 0;
  bool _processandoAcerto = false;
  int _xpGanhoSessao = 0;

  @override
  void initState() {
    super.initState();
    sinalAlvo = sinaisDisponiveis[Random().nextInt(sinaisDisponiveis.length)];
    _iniciarTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _timer = null;
    super.dispose();
  }

  void _iniciarTimer() {
    _timer?.cancel();
    _timer = null;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;

      if (_processandoAcerto) {
        timer.cancel();
        _timer = null;
        return;
      }

      if (tempoRestante > 0) {
        setState(() {
          tempoRestante--;
        });
      } else {
        timer.cancel();
        _timer = null;
        if (!_processandoAcerto) {
          _tempoEsgotado();
        }
      }
    });
  }

  void _tempoEsgotado() {
    if (!mounted || _processandoAcerto) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text('Tempo esgotado!'),
          content: const Text('O tempo da prática terminou.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _reiniciarPratica();
              },
              child: const Text('Tentar novamente'),
            ),
          ],
        );
      },
    );
  }

  void _reiniciarPratica() {
    _timer?.cancel();
    _timer = null;

    setState(() {
      tempoRestante = 30;
      sinalAlvo = sinaisDisponiveis[Random().nextInt(sinaisDisponiveis.length)];
      sinalDetectado = 'Nenhum';
      confianca = 0;
      _processandoAcerto = false;
    });

    _iniciarTimer();
  }

  void _proximoSinal() {
    _timer?.cancel();
    _timer = null;

    setState(() {
      tempoRestante = 30;
      sinalAlvo = sinaisDisponiveis[Random().nextInt(sinaisDisponiveis.length)];
      sinalDetectado = 'Nenhum';
      confianca = 0;
      _processandoAcerto = false;
    });

    _iniciarTimer();
  }

  Future<void> _enviarAcerto() async {
    try {
      final dio = await DioClient.getInstance();
      final response = await dio.post(
        '/user/xp',
        data: {
          'xp': 10,
        },
      );

      debugPrint('Resposta do /user/xp: ${response.statusCode} - ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        _xpGanhoSessao += 10;
      }
    } catch (e) {
      debugPrint('ERRO ao registrar XP na API: $e');
    }

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Sinal Correto! +10 XP'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 1),
      ),
    );

    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        _proximoSinal();
      }
    });
  }

  void _processarResultados(List<YOLOResult> resultados) {
    if (resultados.isEmpty || _processandoAcerto) {
      return;
    }

    final melhorResultado = resultados.reduce(
      (atual, proximo) =>
          proximo.confidence > atual.confidence ? proximo : atual,
    );

    if (!mounted) return;

    final classeLimpa = melhorResultado.className.trim().toUpperCase();
    final alvoLimpo = sinalAlvo.trim().toUpperCase();

    setState(() {
      sinalDetectado = melhorResultado.className.trim();
      confianca = melhorResultado.confidence;
    });

    if (classeLimpa == alvoLimpo && melhorResultado.confidence >= 0.50) {
      _processandoAcerto = true;
      _timer?.cancel();
      _timer = null;
      _enviarAcerto();
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, _xpGanhoSessao);
        return false;
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF623FBD),
        appBar: AppBar(
          backgroundColor: const Color(0xFF623FBD),
          foregroundColor: Colors.white,
          title: const Text('Prática'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context, _xpGanhoSessao),
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        const Text(
                          'SINAL ALVO',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.2,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          sinalAlvo,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.25),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.timer_outlined,
                                color: Colors.white,
                                size: 18,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '00:${tempoRestante.toString().padLeft(2, '0')}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        const Text(
                          'SINAL CAPTURADO',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.0,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          sinalDetectado == 'Nenhum' ? '-' : sinalDetectado,
                          style: TextStyle(
                            color: sinalDetectado.toUpperCase() ==
                                    sinalAlvo.toUpperCase()
                                ? const Color.fromARGB(255, 15, 216, 25)
                                : Colors.white,
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(20),
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: YOLOView(
                  modelPath: 'assets/models/model.tflite',
                  task: YOLOTask.detect,
                  lensFacing: LensFacing.front,
                  onResult: _processarResultados,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: Column(
                children: [
                  const Text(
                    'Posicione sua mão na câmera',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Confiança: ${(confianca * 100).toStringAsFixed(0)}%',
                    style: const TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}