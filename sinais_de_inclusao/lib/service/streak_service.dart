import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sinais_de_inclusao/http/dio_client.dart';

class StreakService {
  static const String _keyStreak = 'esquenta_streak';
  static const String _keyAtivoHoje = 'esquenta_ativo_hoje';
  static const String _keyWeeklyActivity = 'esquenta_weekly_activity';

  static Future<Map<String, dynamic>> obterStatusEsquenta() async {
    final prefs = await SharedPreferences.getInstance();

    try {
      final dio = await DioClient.getInstance();
      final response = await dio.get('user/profile');

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
    final List<dynamic> cachedWeekly = cachedWeeklyStr != null ? jsonDecode(cachedWeeklyStr) : [];

    return {
      'streak': prefs.getInt(_keyStreak) ?? 0,
      'ativoHoje': prefs.getBool(_keyAtivoHoje) ?? false,
      'weeklyActivity': cachedWeekly,
    };
  }

  
  static Future<Map<String, dynamic>> registrarTreinoConcluido() async {
    final prefs = await SharedPreferences.getInstance();
    try {
      final dio = await DioClient.getInstance();
      final response = await dio.post('user/streak');

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
    final List<dynamic> cachedWeekly = cachedWeeklyStr != null ? jsonDecode(cachedWeeklyStr) : [];

    return {
      'streak': prefs.getInt(_keyStreak) ?? 1,
      'ativoHoje': true,
      'xp': 0,
      'weeklyActivity': cachedWeekly,
    };
  }
}