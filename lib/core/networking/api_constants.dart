abstract class ApiConstants {
  static const String baseUrl = 'http://10.0.2.2:3000';

  // Auth Endpoints
  static const String login = '/api/auth/login';
  static const String register = '/api/auth/register';
  static const String logout = '/api/auth/logout';
  static const String me = '/api/auth/me';

  // Menu Endpoints
  static const String categories = '/api/categories';
  static const String products = '/api/products';

  // Profile Endpoints
  static const String profile = '/api/users/me';
}
