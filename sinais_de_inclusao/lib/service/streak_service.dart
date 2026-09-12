import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sinais_de_inclusao/http/dio_client.dart';

class StreakService {
  static const String _keyStreak = 'esquenta_streak';
  static const String _keyAtivoHoje = 'esquenta_ativo_hoje';
  static const String _keyWeeklyActivity = 'esquenta_weekly_activity';
  static const String _keyDiasAtividade = 'esquenta_dias_concluidos';

  static String _formatarData(DateTime data) {
    final mes = data.month.toString().padLeft(2, '0');
    final dia = data.day.toString().padLeft(2, '0');
    return '${data.year}-$mes-$dia';
  }

  static Future<Map<String, dynamic>> obterStatusEsquenta() async {
    final prefs = await SharedPreferences.getInstance();

    try {
      final dio = await DioClient.getInstance();
      final response = await dio.get('/user/profile');

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data;
        final int streak = (data['streak'] ?? 0) as int;
        final bool ativoHoje = (data['streakActiveToday'] ?? false) as bool;
        final List<dynamic> weekly = (data['weeklyActivity'] ?? []) as List<dynamic>;

        await prefs.setInt(_keyStreak, streak);
        await prefs.setBool(_keyAtivoHoje, ativoHoje);
        await prefs.setString(_keyWeeklyActivity, jsonEncode(weekly));

        return {
          'streak': streak,
          'ativoHoje': ativoHoje,
          'weeklyActivity': weekly,
        };
      }
    } catch (e) {
      debugPrint("Aviso [StreakService]: Falha ao buscar perfil na API, usando cache: $e");
    }

    final cachedWeeklyStr = prefs.getString(_keyWeeklyActivity);
    final List<dynamic> cachedWeekly =
        cachedWeeklyStr != null ? jsonDecode(cachedWeeklyStr) : [];

    return {
      'streak': prefs.getInt(_keyStreak) ?? 0,
      'ativoHoje': prefs.getBool(_keyAtivoHoje) ?? false,
      'weeklyActivity': cachedWeekly,
    };
  }

  static Future<Map<String, dynamic>> registrarTreinoConcluido() async {
    final prefs = await SharedPreferences.getInstance();
    final DateTime now = DateTime.now();

    
    final String hojeStr = _formatarData(now);
    final List<String> dias = prefs.getStringList(_keyDiasAtividade) ?? [];
    if (!dias.contains(hojeStr)) {
      dias.add(hojeStr);
      await prefs.setStringList(_keyDiasAtividade, dias);
    }

    try {
      final dio = await DioClient.getInstance();
      final response = await dio.post('/user/streak');

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data;
        final int streak = (data['streak'] ?? 1) as int;
        final bool ativoHoje = (data['streakActiveToday'] ?? true) as bool;
        final int xp = (data['xp'] ?? 0) as int;
        final List<dynamic> weekly = (data['weeklyActivity'] ?? []) as List<dynamic>;

        await prefs.setInt(_keyStreak, streak);
        await prefs.setBool(_keyAtivoHoje, ativoHoje);
        await prefs.setString(_keyWeeklyActivity, jsonEncode(weekly));

        return {
          'streak': streak,
          'ativoHoje': ativoHoje,
          'xp': xp,
          'weeklyActivity': weekly,
        };
      }
    } catch (e) {
      debugPrint("Erro [StreakService]: Falha ao registrar treino na API: $e");
    }

    final cachedWeeklyStr = prefs.getString(_keyWeeklyActivity);
    final List<dynamic> cachedWeekly =
        cachedWeeklyStr != null ? jsonDecode(cachedWeeklyStr) : [];

    return {
      'streak': (prefs.getInt(_keyStreak) ?? 0) + 1,
      'ativoHoje': true,
      'xp': 0,
      'weeklyActivity': cachedWeekly,
    };
  }

  static Future<List<Map<String, dynamic>>> obterAtividadeSemanal() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> diasCompletos = prefs.getStringList(_keyDiasAtividade) ?? [];

    final DateTime now = DateTime.now();
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