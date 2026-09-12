import 'package:shared_preferences/shared_preferences.dart';

class StreakService {
  static const String _keyStreak = 'esquenta_streak';
  static const String _keyLastDate = 'esquenta_last_date';
  static const String _keyDiasAtividade = 'esquenta_dias_concluidos';

  static String _formatarData(DateTime data) {
    final mes = data.month.toString().padLeft(2, '0');
    final dia = data.day.toString().padLeft(2, '0');
    return '${data.year}-$mes-$dia';
  }

  static Future<Map<String, dynamic>> obterStatusEsquenta() async {
    final prefs = await SharedPreferences.getInstance();
    final int streak = prefs.getInt(_keyStreak) ?? 0;
    final String? lastDateStr = prefs.getString(_keyLastDate);

    if (lastDateStr == null) {
      return {'streak': 0, 'ativoHoje': false};
    }

    final DateTime lastDate = DateTime.parse(lastDateStr);
    final DateTime now = DateTime.now();

    final DateTime dataUltima = DateTime(lastDate.year, lastDate.month, lastDate.day);
    final DateTime dataHoje = DateTime(now.year, now.month, now.day);
    final int diff = dataHoje.difference(dataUltima).inDays;

    if (diff == 0) {
      return {'streak': streak, 'ativoHoje': true};
    } else if (diff == 1) {
      return {'streak': streak, 'ativoHoje': false};
    } else {
      await prefs.setInt(_keyStreak, 0);
      return {'streak': 0, 'ativoHoje': false};
    }
  }

  static Future<int> registrarTreinoConcluido() async {
    final prefs = await SharedPreferences.getInstance();
    final int streakAtual = prefs.getInt(_keyStreak) ?? 0;
    final String? lastDateStr = prefs.getString(_keyLastDate);
    final DateTime now = DateTime.now();

    // Registra o dia de hoje no conjunto de dias concluídos
    final String hojeStr = _formatarData(now);
    final List<String> dias = prefs.getStringList(_keyDiasAtividade) ?? [];
    if (!dias.contains(hojeStr)) {
      dias.add(hojeStr);
      await prefs.setStringList(_keyDiasAtividade, dias);
    }

    if (lastDateStr != null) {
      final DateTime lastDate = DateTime.parse(lastDateStr);
      final DateTime dataUltima = DateTime(lastDate.year, lastDate.month, lastDate.day);
      final DateTime dataHoje = DateTime(now.year, now.month, now.day);
      final int diff = dataHoje.difference(dataUltima).inDays;

      if (diff == 0) {
        return streakAtual;
      } else if (diff == 1) {
        final novoStreak = streakAtual + 1;
        await prefs.setInt(_keyStreak, novoStreak);
        await prefs.setString(_keyLastDate, now.toIso8601String());
        return novoStreak;
      }
    }

    const novoStreak = 1;
    await prefs.setInt(_keyStreak, novoStreak);
    await prefs.setString(_keyLastDate, now.toIso8601String());
    return novoStreak;
  }

  /// Retorna os 7 dias da semana atual (Domingo a Sábado) com o status de conclusão
  static Future<List<Map<String, dynamic>>> obterAtividadeSemanal() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> diasCompletos = prefs.getStringList(_keyDiasAtividade) ?? [];
    
    final DateTime now = DateTime.now();
    // Início da semana (Domingo): weekday 7 vira 0 dias de recuo
    final int diasDesdeDomingo = now.weekday % 7;
    final DateTime inicioSemana = DateTime(now.year, now.month, now.day).subtract(
      Duration(days: diasDesdeDomingo),
    );

    final List<Map<String, dynamic>> semana = [];

    for (int i = 0; i < 7; i++) {
      final DateTime diaAtual = inicioSemana.add(Duration(days: i));
      final String diaStr = _formatarData(diaAtual);

      semana.add({
        'date': diaStr,
        'completed': diasCompletos.contains(diaStr),
      });
    }

    return semana;
  }
}