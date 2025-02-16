import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zugantor_core/zugantor_core.dart';

// Environment configuration provider
@riverpod
class Environment extends _$Environment {
  @override
  String build() => const String.fromEnvironment('ENV', defaultValue: 'dev');

  bool get isDev => state == 'dev';
  bool get isProd => state == 'prod';
}

// API configuration based on environment (similar to Dagger modules)
@riverpod
class ApiConfig extends _$ApiConfig {
  @override
  String build() {
    final env = ref.watch(environmentProvider);
    switch (env) {
      case 'prod':
        return 'https://api.zugantor.com';
      case 'staging':
        return 'https://staging-api.zugantor.com';
      default:
        return 'https://dev-api.zugantor.com';
    }
  }
}

// Override example for testing
class TestOverrides extends ProviderOverride {
  @override
  List<Override> get overrides => [
    environmentProvider.overrideWith((ref) => 'test'),
    dioProvider.overrideWith((ref) => Dio(BaseOptions(
      baseUrl: 'https://mock-api.zugantor.com',
    ))),
  ];
}