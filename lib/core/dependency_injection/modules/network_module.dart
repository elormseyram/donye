import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../constants/app_config.dart';
import '../../network/dio_client.dart';

@module
abstract class NetworkModule {
  @singleton
  Dio dio() {
    final d = Dio(
      BaseOptions(
        baseUrl: AppConfig.supabaseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'apikey': AppConfig.supabaseAnonKey,
          'Content-Type': 'application/json',
        },
      ),
    );
    d.interceptors.addAll([
      _AuthInterceptor(),
      LogInterceptor(requestBody: false, responseBody: false),
    ]);
    return d;
  }

  @singleton
  DioClient dioClient(Dio dio) => DioClient(dio);
}

class _AuthInterceptor extends Interceptor {
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    final session = Supabase.instance.client.auth.currentSession;
    if (session != null) {
      options.headers['Authorization'] = 'Bearer ${session.accessToken}';
    }
    handler.next(options);
  }
}
