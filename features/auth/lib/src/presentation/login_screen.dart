import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/auth_service.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch auth state - automatically rebuilds on changes
    final authState = ref.watch(authServiceProvider);

    // Similar to Hilt's ViewModelScope, state is automatically disposed
    return authState.when(
      loading: () => const CircularProgressIndicator(),
      error: (error, stack) => Text('Error: $error'),
      data: (state) => state.isAuthenticated
          ? const Text('Logged In!')
          : LoginForm(
              onLogin: (username, password) {
                // Dependency injection handled automatically
                ref.read(authServiceProvider.notifier).login(username, password);
              },
            ),
    );
  }
}

class LoginForm extends StatelessWidget {
  final void Function(String username, String password) onLogin;
  
  const LoginForm({super.key, required this.onLogin});

  @override
  Widget build(BuildContext context) {
    final usernameController = TextEditingController();
    final passwordController = TextEditingController();

    return Column(
      children: [
        TextField(
          controller: usernameController,
          decoration: const InputDecoration(labelText: 'Username'),
        ),
        TextField(
          controller: passwordController,
          decoration: const InputDecoration(labelText: 'Password'),
          obscureText: true,
        ),
        ElevatedButton(
          onPressed: () => onLogin(
            usernameController.text,
            passwordController.text,
          ),
          child: const Text('Login'),
        ),
      ],
    );
  }
}