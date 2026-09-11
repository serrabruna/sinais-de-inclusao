import 'package:shared_preferences/shared_preferences.dart';

class StreakService {
  static const String _keyStreak = 'esquenta_streak';
  static const String _keyLastDate = 'esquenta_last_date';
  
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
}