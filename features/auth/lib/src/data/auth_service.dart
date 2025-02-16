import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:zugantor_core/zugantor_core.dart';
import '../models/auth_state.dart';
import 'auth_repository.dart';

part 'auth_service.g.dart';

@riverpod
class AuthService extends _$AuthService {
  @override
  FutureOr<AuthState> build() async {
    // Initialize state by checking stored token
    final token = await ref.read(authRepositoryProvider).getToken();
    return AuthState(
      isAuthenticated: token != null,
      token: token,
    );
  }

  Future<void> login(String username, String password) async {
    state = const AsyncValue.loading();
    
    try {
      // Use Dio instance from core package
      final dio = ref.read(dioProvider);
      final response = await dio.post('/auth/login', data: {
        'username': username,
        'password': password,
      });

      final token = response.data['token'] as String;
      await ref.read(authRepositoryProvider).saveToken(token);

      state = AsyncValue.data(AuthState(
        isAuthenticated: true,
        token: token,
      ));
    } catch (error, stack) {
      state = AsyncValue.error(error, stack);
    }
  }

  Future<void> logout() async {
    state = const AsyncValue.loading();
    
    try {
      await ref.read(authRepositoryProvider).deleteToken();
      state = const AsyncValue.data(AuthState());
    } catch (error, stack) {
      state = AsyncValue.error(error, stack);
    }
  }
}