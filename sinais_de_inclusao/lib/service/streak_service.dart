import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sinais_de_inclusao/http/dio_client.dart';

class StreakService {
  static const String _keyStreak = 'esquenta_streak';
  static const String _keyAtivoHoje = 'esquenta_ativo_hoje';

  static Future<Map<String, dynamic>> obterStatusEsquenta() async {
    final prefs = await SharedPreferences.getInstance();

    try {
      final dio = await DioClient.getInstance();
      final response = await dio.get('user/profile');

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data;
        final int streak = (data['streak'] ?? 0) as int;
        final bool ativoHoje = (data['streakActiveToday'] ?? false) as bool;

        await prefs.setInt(_keyStreak, streak);
        await prefs.setBool(_keyAtivoHoje, ativoHoje);

        return {'streak': streak, 'ativoHoje': ativoHoje};
      }
    } catch (e) {
      debugPrint("Aviso: Erro ao buscar streak do backend, usando cache local: $e");
    }
    return {
      'streak': prefs.getInt(_keyStreak) ?? 0,
      'ativoHoje': prefs.getBool(_keyAtivoHoje) ?? false,
    };
  }

  static Future<int> registrarTreinoConcluido() async {
    final prefs = await SharedPreferences.getInstance();

    try {
      final dio = await DioClient.getInstance();
      final response = await dio.post('user/streak');

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data;
        final int streak = (data['streak'] ?? 1) as int;
        final bool ativoHoje = (data['activeToday'] ?? true) as bool;

        await prefs.setInt(_keyStreak, streak);
        await prefs.setBool(_keyAtivoHoje, ativoHoje);

        return streak;
      }
    } catch (e) {
      debugPrint("Erro ao registrar treino no backend: $e");
    }
    return prefs.getInt(_keyStreak) ?? 1;
  }
}