import 'package:bidlotto/services/auth.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DioInterceptor extends Interceptor {
  final Ref ref;

  DioInterceptor(this.ref);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final authState = ref.read(authServiceProvider);
    final token = authState.token;

    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    super.onRequest(options, handler);
  }
}

final dioProvider = Provider((ref) {
  final dio = Dio();
  dio.interceptors.add(DioInterceptor(ref));
  return dio;
});
