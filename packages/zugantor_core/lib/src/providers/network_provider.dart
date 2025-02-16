// HTTP client provider with configuration
@riverpod
Dio dio(DioRef ref) {
  final dio = Dio(BaseOptions(
    baseUrl: 'https://api.your-domain.com',
    connectTimeout: const Duration(seconds: 5),
    receiveTimeout: const Duration(seconds: 3),
  ));
  
  // Add interceptors
  dio.interceptors.addAll([
    LogInterceptor(responseBody: true),
    // You can add auth interceptor here
  ]);

  // Cleanup on dispose
  ref.onDispose(() {
    dio.close();
  });

  return dio;
}