import 'package:dineflow/core/di/servise_locator.dart';
import 'package:dineflow/core/enums/order_type.dart';
import 'package:dineflow/core/widgets/floating_bottom_nav_bar.dart';
import 'package:dineflow/features/auth/domain/entity/user_entity.dart';
import 'package:dineflow/features/auth/presintation/view/screens/login_view.dart';
import 'package:dineflow/features/auth/presintation/view/screens/register_view.dart';
import 'package:dineflow/features/auth/presintation/view/screens/splash_view.dart';
import 'package:dineflow/features/auth/presintation/view_mode/cubit/auth_cubit.dart';
import 'package:dineflow/features/menu/domain/entity/product_entity.dart';
import 'package:dineflow/features/menu/presentation/view/screens/categories_view.dart';
import 'package:dineflow/features/menu/presentation/view/screens/menu_view.dart';
import 'package:dineflow/features/menu/presentation/view/screens/product_details_view.dart';
import 'package:dineflow/features/menu/presentation/view/screens/search_view.dart';
import 'package:dineflow/features/profile/presintation/view/screens/edit_profile_view.dart';
import 'package:dineflow/features/profile/presintation/view/favourites_view.dart';
import 'package:dineflow/features/profile/presintation/view/screens/profile_view.dart';
import 'package:dineflow/features/profile/presintation/view_model/cubit/profile_cubit.dart';
import 'package:dineflow/features/cart/presentation/view/screens/cart_view.dart';
import 'package:dineflow/features/cart/presentation/view_model/cubit/cart_cubit.dart';
import 'package:dineflow/features/orders/domain/entity/order_entity.dart';
import 'package:dineflow/features/orders/presentation/view/screens/checkout_view.dart';
import 'package:dineflow/features/orders/presentation/view/screens/order_success_view.dart';
import 'package:dineflow/features/orders/presentation/view_model/cubit/checkout_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../widgets/app_scaffold.dart';
import 'app_routes.dart';
import 'route_guard.dart';

// ---------------------------------------------------------------------------
// Placeholder screens
// ---------------------------------------------------------------------------
class _PlaceholderScreen extends StatelessWidget {
  const _PlaceholderScreen({required this.label, this.role});
  final String label;
  final AppRole? role;

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: label,
      role: role,
      showAppBar: true,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.construction_rounded,
              size: 48,
              color: (role?.accentColor ?? const Color(0xFFFF6B35)).withValues(
                alpha: 0.5,
              ),
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
GoRouter createRouter({required RouterNotifier notifier}) {
  return GoRouter(
    debugLogDiagnostics: true,
    initialLocation: AppPaths.splash,
    refreshListenable: notifier,

    // ── Global redirect ───────────────────────────────────────────────────────
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
        builder: (context, state) => BlocProvider(
          create: (_) => sl<AuthCubit>(),
          child: const SplashView(),
        ),
      ),

      // ── Auth ──────────────────────────────────────────────────────────────
      GoRoute(
        path: AppPaths.login,
        name: AppRoutes.login,
        builder: (context, state) => BlocProvider(
          create: (_) => sl<AuthCubit>(),
          child: const LoginView(),
        ),
      ),
      GoRoute(
        path: AppPaths.register,
        name: AppRoutes.register,
        builder: (context, state) => BlocProvider(
          create: (_) => sl<AuthCubit>(),
          child: const RegisterView(),
        ),
      ),
      GoRoute(
        path: AppPaths.customerProductDetails,
        name: AppRoutes.customerProductDetails,
        builder: (context, state) {
          final product = state.extra as ProductEntity;
          return ProductDetailsView(product: product);
        },
      ),
      GoRoute(
        path: AppPaths.customerSearch,
        name: AppRoutes.customerSearch,
        builder: (context, state) {
          final query = state.extra as String?;
          return SearchView(initialQuery: query);
        },
      ),
      GoRoute(
        path: AppPaths.customerCart,
        name: AppRoutes.customerCart,
        builder: (context, state) => MultiBlocProvider(
          providers: [
            BlocProvider.value(value: sl<CartCubit>()..getCart()),
            BlocProvider(create: (_) => sl<CheckoutCubit>()..selectOrderType(OrderType.takeaway)),
          ],
          child: const CartView(),
        ),
      ),
      GoRoute(
        path: AppPaths.customerCheckout,
        name: AppRoutes.customerCheckout,
        builder: (context, state) => MultiBlocProvider(
          providers: [
            BlocProvider.value(value: sl<CartCubit>()),
            BlocProvider(create: (_) => sl<CheckoutCubit>()),
          ],
          child: const CheckoutView(),
        ),
      ),
      GoRoute(
        path: AppPaths.customerOrderSuccess,
        name: AppRoutes.customerOrderSuccess,
        builder: (context, state) {
          final order = state.extra as OrderEntity;
          return OrderSuccessView(order: order);
        },
      ),

      // ── Customer Shell (StatefulShellRoute for indexed tab state) ─────────
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return _CustomerShell(navigationShell: navigationShell);
        },
        branches: [
          // Branch 0: Menu
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '${AppPaths.customerShell}/${AppPaths.customerMenu}',
                name: AppRoutes.customerMenu,
                builder: (context, state) => const MenuView(),
                routes: [
                  GoRoute(
                    path: AppPaths.customerCategories,
                    name: AppRoutes.customerCategories,
                    builder: (context, state) => const CategoriesView(),
                  ),
                ],
              ),
            ],
          ),

          // Branch 1: Orders
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '${AppPaths.customerShell}/${AppPaths.customerOrders}',
                name: AppRoutes.customerOrders,
                builder: (context, state) => const _PlaceholderScreen(
                  label: 'Orders',
                  role: AppRole.customer,
                ),
              ),
            ],
          ),

          // Branch 2: Favourites
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '${AppPaths.customerShell}/${AppPaths.customerFavourites}',
                name: AppRoutes.customerFavourites,
                builder: (context, state) => const FavouritesView(),
              ),
            ],
          ),

          // Branch 3: Profile
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '${AppPaths.customerShell}/${AppPaths.customerProfile}',
                name: AppRoutes.customerProfile,
                builder: (context, state) => MultiBlocProvider(
                  providers: [
                    BlocProvider(create: (_) => sl<ProfileCubit>()),
                    BlocProvider(create: (_) => sl<AuthCubit>()),
                  ],
                  child: const ProfileView(),
                ),
                routes: [
                  GoRoute(
                    path: AppPaths.customerEditProfile,
                    name: AppRoutes.customerEditProfile,
                    builder: (context, state) {
                      final user = state.extra as UserEntity?;
                      return BlocProvider(
                        create: (_) => sl<ProfileCubit>(),
                        child: EditProfileView(
                          user: user ??
                              const UserEntity(
                                id: '',
                                name: '',
                                email: '',
                                role: UserRole.customer,
                              ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ],
      ),

      // ── Waiter Shell (StatefulShellRoute) ────────────────────────────────
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return _WaiterShell(navigationShell: navigationShell);
        },
        branches: [
          // Branch 0: Dashboard
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '${AppPaths.waiterShell}/${AppPaths.waiterDashboard}',
                name: AppRoutes.waiterDashboard,
                builder: (context, state) => const _PlaceholderScreen(
                  label: 'Waiter Dashboard',
                  role: AppRole.waiter,
                ),
              ),
            ],
          ),

          // Branch 1: Tables
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '${AppPaths.waiterShell}/${AppPaths.waiterTables}',
                name: AppRoutes.waiterTables,
                builder: (context, state) => const _PlaceholderScreen(
                  label: 'Waiter — Tables',
                  role: AppRole.waiter,
                ),
              ),
            ],
          ),

          // Branch 2: Requests
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '${AppPaths.waiterShell}/${AppPaths.waiterRequests}',
                name: AppRoutes.waiterRequests,
                builder: (context, state) => const _PlaceholderScreen(
                  label: 'Waiter — Requests',
                  role: AppRole.waiter,
                ),
              ),
            ],
          ),
        ],
      ),

      // ── Kitchen Shell (StatefulShellRoute) ───────────────────────────────
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return _KitchenShell(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '${AppPaths.kitchenShell}/${AppPaths.kitchenKds}',
                name: AppRoutes.kitchenKds,
                builder: (context, state) => const _PlaceholderScreen(
                  label: 'Kitchen Display System',
                  role: AppRole.kitchen,
                ),
                routes: [
                  GoRoute(
                    path: AppPaths.kitchenOrderDetail,
                    name: AppRoutes.kitchenOrderDetail,
                    builder: (context, state) {
                      final orderId = state.pathParameters['orderId']!;
                      return _PlaceholderScreen(
                        label: 'Kitchen Order Detail — $orderId',
                        role: AppRole.kitchen,
                      );
                    },
                  ),
                ],
              ),
            ],
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
// Shell wrappers — using StatefulNavigationShell & FloatingBottomNavBar
// ─────────────────────────────────────────────────────────────────────────────

class _CustomerShell extends StatelessWidget {
  const _CustomerShell({required this.navigationShell});
  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: sl<CartCubit>()..getCart(),
      child: AppScaffold(
        showAppBar: false,
        body: navigationShell,
        bottomNavigationBar: FloatingBottomNavBar(
          currentIndex: navigationShell.currentIndex,
          accentColor: AppRole.customer.accentColor,
          onTap: (index) {
            navigationShell.goBranch(
              index,
              initialLocation: index == navigationShell.currentIndex,
            );
          },
          items: const [
            FloatingNavItem(
              icon: Icons.restaurant_menu_outlined,
              selectedIcon: Icons.restaurant_menu,
              label: 'Home',
            ),
            FloatingNavItem(
              icon: Icons.shopping_bag_outlined,
              selectedIcon: Icons.shopping_bag_rounded,
              label: 'Orders',
            ),
            FloatingNavItem(
              icon: Icons.favorite_border_rounded,
              selectedIcon: Icons.favorite_rounded,
              label: 'Favourites',
            ),
            FloatingNavItem(
              icon: Icons.person_outline_rounded,
              selectedIcon: Icons.person_rounded,
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}

class _WaiterShell extends StatelessWidget {
  const _WaiterShell({required this.navigationShell});
  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      showAppBar: false,
      body: navigationShell,
      bottomNavigationBar: FloatingBottomNavBar(
        currentIndex: navigationShell.currentIndex,
        accentColor: AppRole.waiter.accentColor,
        onTap: (index) {
          navigationShell.goBranch(
            index,
            initialLocation: index == navigationShell.currentIndex,
          );
        },
        items: const [
          FloatingNavItem(
            icon: Icons.dashboard_outlined,
            selectedIcon: Icons.dashboard,
            label: 'Dashboard',
          ),
          FloatingNavItem(
            icon: Icons.table_restaurant_outlined,
            selectedIcon: Icons.table_restaurant,
            label: 'Tables',
          ),
          FloatingNavItem(
            icon: Icons.inbox_outlined,
            selectedIcon: Icons.inbox,
            label: 'Requests',
          ),
        ],
      ),
    );
  }
}

class _KitchenShell extends StatelessWidget {
  const _KitchenShell({required this.navigationShell});
  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      showAppBar: false,
      body: navigationShell,
      bottomNavigationBar: FloatingBottomNavBar(
        currentIndex: navigationShell.currentIndex,
        accentColor: AppRole.kitchen.accentColor,
        onTap: (index) {
          navigationShell.goBranch(
            index,
            initialLocation: index == navigationShell.currentIndex,
          );
        },
        items: const [
          FloatingNavItem(
            icon: Icons.kitchen_outlined,
            selectedIcon: Icons.kitchen,
            label: 'KDS',
          ),
        ],
      ),
    );
  }
}
