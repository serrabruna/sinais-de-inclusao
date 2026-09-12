import 'package:flutter/material.dart';

class ProgressoSemanal extends StatelessWidget {
  final List<DateTime> diasComAtividade;

  const ProgressoSemanal({
    super.key,
    required this.diasComAtividade,
  });

  bool _fezAtividade(DateTime dia) {
    return diasComAtividade.any(
      (atividade) =>
          atividade.year == dia.year &&
          atividade.month == dia.month &&
          atividade.day == dia.day,
    );
  }

  @override
  Widget build(BuildContext context) {
    final hoje = DateTime.now();

    final inicioSemana = hoje.subtract(
      Duration(days: hoje.weekday - 1),
    );

    final diasSemana = List.generate(
      7,
      (index) => inicioSemana.add(Duration(days: index)),
    );

    const nomes = [
      'Seg',
      'Ter',
      'Qua',
      'Qui',
      'Sex',
      'Sáb',
      'Dom',
    ];

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
        crossAxisAlignment: CrossAxisAlignment.center,
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

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(7, (index) {
              final dia = diasSemana[index];

              final fezAtividade = _fezAtividade(dia);

              final ehHoje =
                  dia.year == hoje.year &&
                  dia.month == hoje.month &&
                  dia.day == hoje.day;

              return Expanded(
                child: Column(
                  children: [
                    Text(
                      nomes[index],
                      style: TextStyle(
                        color: ehHoje
                            ? const Color(0xFF623FBD)
                            : Colors.black54,
                        fontSize: 13,
                        fontWeight: ehHoje
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: fezAtividade
                            ? const Color(0xFFFFB46E)
                            : const Color(0xFFF3F1FA),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: ehHoje
                              ? const Color(0xFF623FBD)
                              : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: Icon(
                        fezAtividade
                            ? Icons.local_fire_department_rounded
                            : Icons.circle_outlined,
                        color: fezAtividade
                            ? Colors.white
                            : Colors.black12,
                        size: fezAtividade ? 24 : 18,
                      ),
                    ),

                    const SizedBox(height: 5),

                    Text(
                      '${dia.day}',
                      style: const TextStyle(
                        color: Colors.black45,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}