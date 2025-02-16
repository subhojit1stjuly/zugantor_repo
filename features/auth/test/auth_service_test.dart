import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zugantor_core/zugantor_core.dart';
import '../lib/src/data/auth_service.dart';
import '../lib/src/data/auth_repository.dart';

void main() {
  late ProviderContainer container;

  setUp(() {
    // Similar to Hilt's TestInstallIn, but more straightforward
    container = ProviderContainer(
      overrides: [
        // Mock dependencies
        dioProvider.overrideWithValue(
          Dio(BaseOptions(baseUrl: 'https://mock-api.test')),
        ),
        // Mock repository
        authRepositoryProvider.overrideWith((ref) => MockAuthRepository()),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  test('authentication flow', () async {
    final authService = container.read(authServiceProvider.notifier);
    
    // Initial state
    expect(
      container.read(authServiceProvider).value?.isAuthenticated,
      false,
    );

    // Login
    await authService.login('test_user', 'password');
    
    expect(
      container.read(authServiceProvider).value?.isAuthenticated,
      true,
    );

    // Logout
    await authService.logout();
    
    expect(
      container.read(authServiceProvider).value?.isAuthenticated,
      false,
    );
  });
}

class MockAuthRepository extends AuthRepository {
  String? _token;

  @override
  Future<String?> getToken() async => _token;

  @override
  Future<void> saveToken(String token) async {
    _token = token;
  }

  @override
  Future<void> deleteToken() async {
    _token = null;
  }
}