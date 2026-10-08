abstract class ApiConstants {
  // static const String baseUrl = 'http://192.168.1.9:3000';
  static const String baseUrl = 'http://192.168.1.12:3000';
  static const String socketUrl = 'http://192.168.1.12:3000';


  // static const String socketUrl = 'http://192.168.1.9:3000';

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
  static const String profileImage = '/api/users/me/profile-image';

  // Cart Endpoints
  static const String cart = '/api/cart';
  static const String cartItems = '/api/cart/items';

  // Order Endpoints
  static const String orders = '/api/orders';
  static String updateOrder(String id) => '/api/orders/$id/status';

  static const String startDining = '/api/dining-sessions';

  // Table Endpoints
  static const String tables = '/api/tables';

  // Notification Endpoints
  static const String notifications = '/api/notifications';
  static const String markAllNotificationsAsRead =
      '/api/notifications/read-all';
  static String markNotificationAsRead(String id) =>
      '/api/notifications/$id/read';
  static const String registerDeviceToken = '/api/notifications/device-token';
  static const String unregisterDeviceToken = '/api/notifications/device-token';

  // Waiter Endpoints
   static const String waiterRequests = '/api/waiter-requests';

  static String updateWaiterRequestStatus(String requestId) =>
      '/api/waiter-requests/$requestId/status';
  static const String createOrder = '/api/orders';
  
}

class RealtimeEvents {
  static const orderCreated = 'order_created';
  static const orderStatusChanged = 'order_status_changed';
}
