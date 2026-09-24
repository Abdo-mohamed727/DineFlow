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

  // Cart Endpoints
  static const String cart = '/api/cart';
  static const String cartItems = '/api/cart/items';

  // Order Endpoints
  static const String orders = '/api/orders';
  static const String startDining = '/api/dining-sessions';

  // Table Endpoints
  static const String tables = '/api/tables';
}
