import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

// ---------------------------------------------------------------------------
// Auth state representation
// ---------------------------------------------------------------------------
// The real AuthCubit (AUTH-001 / AUTH-015) exposes one of these values via
// its state.  The guard reads it through a ChangeNotifier-based listenable so
// GoRouter re-evaluates the redirect whenever auth changes.
//
// Replace the stub enum / notifier below with your real AuthCubit once it
// exists — nothing else in the router needs to change.
// ---------------------------------------------------------------------------

/// Minimal representation of authentication / role state the guard needs.
/// Replace with your real AuthState values from AuthCubit.
enum AuthStatus {
  /// App is still determining whether the user is logged in.
  unknown,

  /// No authenticated user.
  unauthenticated,

  /// Authenticated customer.
  customer,

  /// Authenticated waiter.
  waiter,

  /// Authenticated kitchen staff.
  kitchen,
}

/// A [ChangeNotifier] that GoRouter listens to via [GoRouter.refreshListenable].
///
/// In production, replace the manual [notify] calls with an adapter that
/// bridges your [AuthCubit]'s stream to this notifier — for example:
///
/// ```dart
/// authCubit.stream.listen((_) => routerNotifier.notify());
/// ```
///
/// That way every Cubit state change re-triggers the guard without any
/// coupling between go_router and flutter_bloc.
class RouterNotifier extends ChangeNotifier {
  AuthStatus _status = AuthStatus.unknown;

  AuthStatus get status => _status;

  /// Call this whenever [AuthCubit] emits a new state.
  void updateStatus(AuthStatus newStatus) {
    if (_status == newStatus) return;
    _status = newStatus;
    notifyListeners(); // triggers GoRouter to re-run redirect()
  }

  /// Convenience shorthand used in tests / splash logic.
  void notify() => notifyListeners();
}

// ---------------------------------------------------------------------------
// Route guard — pure redirect logic, no Widget dependencies
// ---------------------------------------------------------------------------

/// Decides where the user should be redirected based on [RouterNotifier.status].
///
/// Returns `null` to allow the requested route, or a path string to redirect.
String? routeGuard({
  required String currentPath,
  required AuthStatus status,
}) {
  final goingToSplash = currentPath == '/';
  final goingToAuth =
      currentPath == '/login' || currentPath == '/register';
  final goingToCustomer = currentPath.startsWith('/customer');
  final goingToWaiter = currentPath.startsWith('/waiter');
  final goingToKitchen = currentPath.startsWith('/kitchen');

  switch (status) {
    // Still loading — always show splash, nowhere to redirect yet
    case AuthStatus.unknown:
      return goingToSplash ? null : '/';

    // Not logged in — only auth screens are allowed
    case AuthStatus.unauthenticated:
      return goingToAuth ? null : '/login';

    // Logged-in customer — must stay in /customer/*
    case AuthStatus.customer:
      if (goingToAuth || goingToSplash) return '/customer/menu';
      if (goingToWaiter || goingToKitchen) return '/customer/menu';
      return null;

    // Logged-in waiter — must stay in /waiter/*
    case AuthStatus.waiter:
      if (goingToAuth || goingToSplash) return '/waiter/dashboard';
      if (goingToCustomer || goingToKitchen) return '/waiter/dashboard';
      return null;

    // Logged-in kitchen staff — must stay in /kitchen/*
    case AuthStatus.kitchen:
      if (goingToAuth || goingToSplash) return '/kitchen/kds';
      if (goingToCustomer || goingToWaiter) return '/kitchen/kds';
      return null;
  }
}
