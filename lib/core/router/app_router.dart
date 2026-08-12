import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../widgets/app_scaffold.dart';
import 'app_routes.dart';
import 'route_guard.dart';

// ---------------------------------------------------------------------------
// Placeholder screens
// ---------------------------------------------------------------------------
// Each placeholder is a lightweight widget that shows the screen's intended
// name.  Swap it with the real screen once the feature layer is implemented —
// the route tree itself will not need to change.
// ---------------------------------------------------------------------------

// Each placeholder uses AppScaffold so the shared background and AppBar
// are visible immediately — swap builder with the real screen widget once
// the feature layer exists.
class _PlaceholderScreen extends StatelessWidget {
  const _PlaceholderScreen({
    required this.label,
    this.role,
    this.showAppBar = true,
  });
  final String label;
  final AppRole? role;
  final bool showAppBar;

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: label,
      role: role,
      showAppBar: showAppBar,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.construction_rounded,
              size: 48,
              color: (role?.accentColor ?? const Color(0xFFFF6B35))
                  .withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            Text(
              label,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: const Color(0xFFE5E2E1),
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Coming soon',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: const Color(0xFFE5E2E1).withValues(alpha: 0.4),
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Router factory
// ---------------------------------------------------------------------------

/// Builds and returns the application [GoRouter].
///
/// [notifier] is the [RouterNotifier] that wraps your [AuthCubit].
/// Pass it in from your DI layer (GetIt) so both the router and the cubit
/// share the same instance.
///
/// ### Wiring with AuthCubit (once it exists)
/// ```dart
/// final notifier = RouterNotifier();
///
/// // In your DI setup / app bootstrap:
/// authCubit.stream.listen((state) {
///   notifier.updateStatus(_toAuthStatus(state));
/// });
///
/// final router = createRouter(notifier: notifier);
/// ```
GoRouter createRouter({required RouterNotifier notifier}) {
  return GoRouter(
    debugLogDiagnostics: true,
    initialLocation: AppPaths.splash,
    refreshListenable: notifier,

    // ── Global redirect (runs on every navigation + every notifier change) ──
    redirect: (BuildContext context, GoRouterState state) {
      return routeGuard(
        currentPath: state.matchedLocation,
        status: notifier.status,
      );
    },

    routes: [
      // ── Splash ────────────────────────────────────────────────────────────
      GoRoute(
        path: AppPaths.splash,
        name: AppRoutes.splash,
        builder: (context, state) =>
            const _PlaceholderScreen(label: 'Splash', showAppBar: false),
      ),

      // ── Auth ──────────────────────────────────────────────────────────────
      GoRoute(
        path: AppPaths.login,
        name: AppRoutes.login,
        builder: (context, state) =>
            const _PlaceholderScreen(label: 'Login', showAppBar: false),
      ),
      GoRoute(
        path: AppPaths.register,
        name: AppRoutes.register,
        builder: (context, state) =>
            const _PlaceholderScreen(label: 'Register', showAppBar: false),
      ),

      // ── Customer shell ────────────────────────────────────────────────────
      ShellRoute(
        builder: (context, state, child) => _CustomerShell(child: child),
        routes: [
          GoRoute(
            path: '${AppPaths.customerShell}/${AppPaths.customerMenu}',
            name: AppRoutes.customerMenu,
            builder: (context, state) =>
                const _PlaceholderScreen(label: 'Menu', role: AppRole.customer),
          ),
          GoRoute(
            path: '${AppPaths.customerShell}/${AppPaths.customerCart}',
            name: AppRoutes.customerCart,
            builder: (context, state) =>
                const _PlaceholderScreen(label: 'Cart', role: AppRole.customer),
          ),
          GoRoute(
            path: '${AppPaths.customerShell}/${AppPaths.customerTables}',
            name: AppRoutes.customerTables,
            builder: (context, state) =>
                const _PlaceholderScreen(
                    label: 'Table Selection', role: AppRole.customer),
          ),
          GoRoute(
            path: '${AppPaths.customerShell}/${AppPaths.customerOrderTracking}',
            name: AppRoutes.customerOrderTracking,
            builder: (context, state) {
              final orderId = state.pathParameters['orderId']!;
              return _PlaceholderScreen(
                  label: 'Order Tracking — $orderId',
                  role: AppRole.customer);
            },
          ),
          GoRoute(
            path: '${AppPaths.customerShell}/${AppPaths.customerProfile}',
            name: AppRoutes.customerProfile,
            builder: (context, state) =>
                const _PlaceholderScreen(
                    label: 'Profile', role: AppRole.customer),
          ),
        ],
      ),

      // ── Waiter shell ──────────────────────────────────────────────────────
      ShellRoute(
        builder: (context, state, child) => _WaiterShell(child: child),
        routes: [
          GoRoute(
            path: '${AppPaths.waiterShell}/${AppPaths.waiterDashboard}',
            name: AppRoutes.waiterDashboard,
            builder: (context, state) =>
                const _PlaceholderScreen(
                    label: 'Waiter Dashboard', role: AppRole.waiter),
          ),
          GoRoute(
            path: '${AppPaths.waiterShell}/${AppPaths.waiterTables}',
            name: AppRoutes.waiterTables,
            builder: (context, state) =>
                const _PlaceholderScreen(
                    label: 'Waiter — Tables', role: AppRole.waiter),
          ),
          GoRoute(
            path: '${AppPaths.waiterShell}/${AppPaths.waiterRequests}',
            name: AppRoutes.waiterRequests,
            builder: (context, state) =>
                const _PlaceholderScreen(
                    label: 'Waiter — Requests', role: AppRole.waiter),
          ),
        ],
      ),

      // ── Kitchen shell ─────────────────────────────────────────────────────
      ShellRoute(
        builder: (context, state, child) => _KitchenShell(child: child),
        routes: [
          GoRoute(
            path: '${AppPaths.kitchenShell}/${AppPaths.kitchenKds}',
            name: AppRoutes.kitchenKds,
            builder: (context, state) =>
                const _PlaceholderScreen(
                    label: 'Kitchen Display System', role: AppRole.kitchen),
          ),
          GoRoute(
            path: '${AppPaths.kitchenShell}/${AppPaths.kitchenOrderDetail}',
            name: AppRoutes.kitchenOrderDetail,
            builder: (context, state) {
              final orderId = state.pathParameters['orderId']!;
              return _PlaceholderScreen(
                  label: 'Kitchen Order Detail — $orderId',
                  role: AppRole.kitchen);
            },
          ),
        ],
      ),
    ],

    // ── Error page ────────────────────────────────────────────────────────
    errorBuilder: (context, state) => AppScaffold(
      title: 'Page Not Found',
      showAppBar: true,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.warning_amber_rounded,
              size: 64,
              color: Color(0xFFFFB4AB),
            ),
            const SizedBox(height: 16),
            Text(
              'Page not found',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: const Color(0xFFE5E2E1),
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              state.error?.message ?? state.uri.toString(),
              style: const TextStyle(color: Color(0xFFA98A80)),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () => context.go(AppPaths.splash),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    ),
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// Shell wrappers — each shell provides the shared background + bottom nav
// without owning an AppBar (the individual screens do that via AppScaffold).
// ─────────────────────────────────────────────────────────────────────────────

class _CustomerShell extends StatelessWidget {
  const _CustomerShell({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    // Detect which tab is currently active so NavigationBar highlights it.
    final location = GoRouterState.of(context).matchedLocation;
    final index = switch (location) {
      String l when l.contains('/customer/cart')    => 1,
      String l when l.contains('/customer/tables')  => 2,
      String l when l.contains('/customer/profile') => 3,
      _                                              => 0,
    };

    return AppScaffold(
      showAppBar: false, // Each child screen renders its own AppBar.
      body: child,
      bottomNavigationBar: _AppNavBar(
        currentIndex: index,
        role: AppRole.customer,
        onTap: (i) {
          switch (i) {
            case 0: context.goNamed(AppRoutes.customerMenu);
            case 1: context.goNamed(AppRoutes.customerCart);
            case 2: context.goNamed(AppRoutes.customerTables);
            case 3: context.goNamed(AppRoutes.customerProfile);
          }
        },
        destinations: const [
          NavigationDestination(
              icon: Icon(Icons.restaurant_menu_outlined),
              selectedIcon: Icon(Icons.restaurant_menu),
              label: 'Menu'),
          NavigationDestination(
              icon: Icon(Icons.shopping_cart_outlined),
              selectedIcon: Icon(Icons.shopping_cart),
              label: 'Cart'),
          NavigationDestination(
              icon: Icon(Icons.table_restaurant_outlined),
              selectedIcon: Icon(Icons.table_restaurant),
              label: 'Tables'),
          NavigationDestination(
              icon: Icon(Icons.person_outline_rounded),
              selectedIcon: Icon(Icons.person_rounded),
              label: 'Profile'),
        ],
      ),
    );
  }
}

class _WaiterShell extends StatelessWidget {
  const _WaiterShell({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    final index = switch (location) {
      String l when l.contains('/waiter/tables')   => 1,
      String l when l.contains('/waiter/requests') => 2,
      _                                             => 0,
    };

    return AppScaffold(
      showAppBar: false,
      body: child,
      bottomNavigationBar: _AppNavBar(
        currentIndex: index,
        role: AppRole.waiter,
        onTap: (i) {
          switch (i) {
            case 0: context.goNamed(AppRoutes.waiterDashboard);
            case 1: context.goNamed(AppRoutes.waiterTables);
            case 2: context.goNamed(AppRoutes.waiterRequests);
          }
        },
        destinations: const [
          NavigationDestination(
              icon: Icon(Icons.dashboard_outlined),
              selectedIcon: Icon(Icons.dashboard),
              label: 'Dashboard'),
          NavigationDestination(
              icon: Icon(Icons.table_restaurant_outlined),
              selectedIcon: Icon(Icons.table_restaurant),
              label: 'Tables'),
          NavigationDestination(
              icon: Icon(Icons.inbox_outlined),
              selectedIcon: Icon(Icons.inbox),
              label: 'Requests'),
        ],
      ),
    );
  }
}

class _KitchenShell extends StatelessWidget {
  const _KitchenShell({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    final index = location.contains('/kitchen/kds') ? 0 : 0;

    return AppScaffold(
      showAppBar: false,
      body: child,
      bottomNavigationBar: _AppNavBar(
        currentIndex: index,
        role: AppRole.kitchen,
        onTap: (i) {
          if (i == 0) context.goNamed(AppRoutes.kitchenKds);
        },
        destinations: const [
          NavigationDestination(
              icon: Icon(Icons.kitchen_outlined),
              selectedIcon: Icon(Icons.kitchen),
              label: 'KDS'),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Shared themed NavigationBar
// ─────────────────────────────────────────────────────────────────────────────

/// A styled [NavigationBar] that honours the role's accent colour.
class _AppNavBar extends StatelessWidget {
  const _AppNavBar({
    required this.destinations,
    required this.onTap,
    required this.role,
    required this.currentIndex,
  });

  final List<NavigationDestination> destinations;
  final ValueChanged<int> onTap;
  final AppRole role;
  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    final accent = role.accentColor;
    return NavigationBarTheme(
      data: NavigationBarThemeData(
        backgroundColor: const Color(0xFF0E0E0E),
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.black54,
        elevation: 8,
        indicatorColor: accent.withValues(alpha: 0.18),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return IconThemeData(
            color: selected ? accent : const Color(0xFFE5E2E1).withValues(alpha: 0.4),
            size: 22,
          );
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return TextStyle(
            color: selected ? accent : const Color(0xFFE5E2E1).withValues(alpha: 0.4),
            fontSize: 11,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
          );
        }),
      ),
      child: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: onTap,
        destinations: destinations,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        animationDuration: const Duration(milliseconds: 300),
      ),
    );
  }
}
