import 'package:flutter/widgets.dart';

enum AuthStatus { unknown, unauthenticated, customer, waiter, kitchen }

class RouterNotifier extends ChangeNotifier {
  AuthStatus _status = AuthStatus.unknown;

  AuthStatus get status => _status;

  void updateStatus(AuthStatus newStatus) {
    if (_status == newStatus) return;
    _status = newStatus;
    notifyListeners();
  }

  void notify() => notifyListeners();
}

String? routeGuard({required String currentPath, required AuthStatus status}) {
  final goingToSplash = currentPath == '/';
  final goingToAuth = currentPath == '/login' || currentPath == '/register';
  final goingToCustomer = currentPath.startsWith('/customer');
  final goingToWaiter = currentPath.startsWith('/waiter');
  final goingToKitchen = currentPath.startsWith('/kitchen');

  switch (status) {
    case AuthStatus.unknown:
      return goingToSplash ? null : '/';

    case AuthStatus.unauthenticated:
      return goingToAuth ? null : '/login';

    case AuthStatus.customer:
      if (goingToAuth || goingToSplash) return '/customer/menu';
      if (goingToWaiter || goingToKitchen) return '/customer/menu';
      return null;

    case AuthStatus.waiter:
      if (goingToAuth || goingToSplash) return '/waiter/dashboard';
      if (goingToCustomer || goingToKitchen) return '/waiter/dashboard';
      return null;

    case AuthStatus.kitchen:
      if (goingToAuth || goingToSplash) return '/kitchen/kds';
      if (goingToCustomer || goingToWaiter) return '/kitchen/kds';
      return null;
  }
}
