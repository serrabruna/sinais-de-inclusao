import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:dio_cache_interceptor_hive_store/dio_cache_interceptor_hive_store.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DioClient {
  static Dio? _dio;

  static Future<Dio> getInstance() async {
    if (_dio == null) {
      var dir = await getTemporaryDirectory();
      final options = CacheOptions(
        store: HiveCacheStore(dir.path),
        policy: CachePolicy.request, // Mudança aqui
        hitCacheOnErrorExcept: [401, 403], 
        maxStale: const Duration(days: 7), 
      );

      _dio = Dio(
        BaseOptions(
          baseUrl: 'https://sinais-de-inclusao-api.onrender.com/',
          connectTimeout: const Duration(seconds: 5),
          persistentConnection: true,
        ),
      )..interceptors.add(DioCacheInterceptor(options: options));

      
      _dio!.interceptors.add(InterceptorsWrapper(
        onRequest: (options, handler) async {
          final prefs = await SharedPreferences.getInstance();
          await prefs.reload();

          final token = prefs.getString('token');
          
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
            print("DEBUG - Token injetado com sucesso no header: Bearer $token");
          } else {
            print("DEBUG - Token continua nulo no momento da requisição");
          }
          return handler.next(options);
        },
      ));
    }
    return _dio!;
  }
}
