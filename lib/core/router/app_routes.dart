 
abstract final class AppRoutes {
  // ── Auth ────────────────────────────────────────────────────────────────
  static const String splash = 'splash';
  static const String login = 'login';
  static const String register = 'register';

  // ── Customer shell ───────────────────────────────────────────────────────
  static const String customerShell = 'customer-shell';
  static const String customerMenu = 'customer-menu';
  static const String customerCategories = 'customer-categories';
  static const String customerProductDetails = 'customer-product-details';
  static const String customerSearch = 'customer-search';
  static const String customerOrders = 'customer-orders';
  static const String customerOrderTracking = 'customer-order-tracking';
  static const String customerFavourites = 'customer-favourites';
  static const String customerProfile = 'customer-profile';
  static const String customerEditProfile = 'customer-edit-profile';
  static const String customerCart = 'customer-cart';
  static const String customerCheckout = 'customer-checkout';
  static const String customerOrderSuccess = 'customer-order-success';

  // ── Waiter shell ─────────────────────────────────────────────────────────
  static const String waiterShell = 'waiter-shell';
  static const String waiterDashboard = 'waiter-dashboard';
  static const String waiterTables = 'waiter-tables';
  static const String waiterRequests = 'waiter-requests';

  // ── Kitchen shell ────────────────────────────────────────────────────────
  static const String kitchenShell = 'kitchen-shell';
  static const String kitchenKds = 'kitchen-kds';
  static const String kitchenOrderDetail = 'kitchen-order-detail';
}

/// Central registry of every route *path* (used by GoRouter internally).
///
/// Prefer navigating by **name** (`AppRoutes`). Paths here exist mainly
/// so GoRouter can build its routing tree.
abstract final class AppPaths {
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';

  // Customer
  static const String customerShell = '/customer';
  static const String customerMenu = 'menu';
  static const String customerCategories = 'categories';
  static const String customerProductDetails = '/product-details';
  static const String customerSearch = '/search';
  static const String customerOrders = 'orders';
  static const String customerOrderTracking = 'order/:orderId';
  static const String customerFavourites = 'favourites';
  static const String customerProfile = 'profile';
  static const String customerEditProfile = 'edit';
  static const String customerCart = '/cart';
  static const String customerCheckout = '/checkout';
  static const String customerOrderSuccess = '/order-success';

  // Waiter
  static const String waiterShell = '/waiter';
  static const String waiterDashboard = 'dashboard';
  static const String waiterTables = 'tables';
  static const String waiterRequests = 'requests';

  // Kitchen
  static const String kitchenShell = '/kitchen';
  static const String kitchenKds = 'kds';
  static const String kitchenOrderDetail = 'order/:orderId';
}
