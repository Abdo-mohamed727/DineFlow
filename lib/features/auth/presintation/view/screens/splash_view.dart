import 'package:dineflow/core/di/servise_locator.dart';
import 'package:dineflow/core/router/app_routes.dart';
import 'package:dineflow/core/router/route_guard.dart';
import 'package:dineflow/core/theme/app_colors.dart';
import 'package:dineflow/core/widgets/app_scaffold.dart';
import 'package:dineflow/features/auth/domain/entity/user_entity.dart';
import 'package:dineflow/features/auth/presintation/view_mode/cubit/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

/// SplashView checks whether an active user session exists when the app launches.
/// If authenticated -> routes to role home (Customer / Waiter / Kitchen).
/// If unauthenticated or error -> routes to LoginView.
class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    // Check for existing saved session on startup
    context.read<AuthCubit>().getCurrentUserData();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      showAppBar: false,
      body: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          state.whenOrNull(
            authenticated: (user) {
              final status = switch (user.role) {
                UserRole.customer => AuthStatus.customer,
                UserRole.waiter => AuthStatus.waiter,
                UserRole.kitchen => AuthStatus.kitchen,
              };
              sl<RouterNotifier>().updateStatus(status);

              switch (user.role) {
                case UserRole.customer:
                  context.goNamed(AppRoutes.customerMenu);
                case UserRole.waiter:
                  context.goNamed(AppRoutes.waiterDashboard);
                case UserRole.kitchen:
                  context.goNamed(AppRoutes.kitchenKds);
              }
            },
            unauthenticated: () {
              sl<RouterNotifier>().updateStatus(AuthStatus.unauthenticated);
              context.goNamed(AppRoutes.login);
            },
            error: (_) {
              sl<RouterNotifier>().updateStatus(AuthStatus.unauthenticated);
              context.goNamed(AppRoutes.login);
            },
          );
        },
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppColors.primaryContainer.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.restaurant_rounded,
                  size: 44,
                  color: AppColors.primaryContainer,
                ),
              ),
              const SizedBox(height: 24),
              const CircularProgressIndicator(
                color: AppColors.primaryContainer,
                strokeWidth: 2.5,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
