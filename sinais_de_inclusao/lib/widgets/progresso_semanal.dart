import 'package:flutter/material.dart';

class ProgressoSemanal extends StatelessWidget {
  final List<Map<String, dynamic>> atividadeSemanal;

  const ProgressoSemanal({
    super.key,
    required this.atividadeSemanal,
  });

  static const List<String> nomesDias = [
    'Dom',
    'Seg',
    'Ter',
    'Qua',
    'Qui',
    'Sex',
    'Sáb',
  ];

  @override
  Widget build(BuildContext context) {
    debugPrint('WIDGET RECEBEU: $atividadeSemanal');

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 20,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            'Seu progresso',
            style: TextStyle(
              color: Color(0xFF623FBD),
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          if (atividadeSemanal.isEmpty)
            const Text(
              'Nenhuma atividade encontrada',
              style: TextStyle(color: Colors.black45),
            )
          else
            Row(
              children: List.generate(
                atividadeSemanal.length,
                (index) {
                  final item = atividadeSemanal[index];
                  final String dataStr = item['date']?.toString() ?? '';

                  // Checagem flexível de completude (bool, int ou string)
                  final dynamic val = item['completed'] ?? item['done'] ?? item['active'];
                  final bool completou = val == true ||
                      val == 1 ||
                      val?.toString().toLowerCase() == 'true';

                  // Obtenção segura do dia e do dia da semana
                  String numeroDia = '';
                  String nomeDia = index < nomesDias.length ? nomesDias[index] : '';

                  if (dataStr.contains('-')) {
                    final partes = dataStr.split('-');
                    if (partes.length == 3) {
                      numeroDia = int.tryParse(partes[2])?.toString() ?? partes[2];
                      final ano = int.tryParse(partes[0]) ?? 2026;
                      final mes = int.tryParse(partes[1]) ?? 1;
                      final dia = int.tryParse(partes[2]) ?? 1;
                      
                      // DateTime sem timezone para não deslocar dia
                      final dateObj = DateTime(ano, mes, dia);
                      nomeDia = nomesDias[dateObj.weekday % 7];
                    }
                  }

                  debugPrint('RENDER DIA: $dataStr | DIA: $numeroDia | COMPLETADO: $completou');

                  return Expanded(
                    child: Column(
                      children: [
                        Text(
                          nomeDia,
                          style: const TextStyle(
                            color: Colors.black54,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            color: completou
                                ? const Color(0xFFFFB46E)
                                : const Color(0xFFF3F1FA),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            completou
                                ? Icons.local_fire_department_rounded
                                : Icons.circle_outlined,
                            color: completou ? Colors.white : Colors.black12,
                            size: completou ? 24 : 18,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          numeroDia,
                          style: const TextStyle(
                            color: Colors.black45,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}