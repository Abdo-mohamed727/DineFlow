enum AppEnvironment { dev, staging, production }

class AppConfig {
  final AppEnvironment environment;
  final String apiBaseUrl;

  const AppConfig({required this.environment, required this.apiBaseUrl});

  static late AppConfig instance;
}
