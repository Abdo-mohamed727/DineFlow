import 'package:dineflow/core/di/servise_locator.dart';
import 'package:dineflow/core/router/route_guard.dart';
import 'package:dineflow/core/theme/app_colors.dart';
import 'package:dineflow/core/widgets/app_scaffold.dart';
import 'package:dineflow/features/auth/domain/entity/user_entity.dart';
import 'package:dineflow/features/auth/presintation/view_mode/cubit/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// SplashView — checks for an existing session on app launch.
///
/// Strategy:
/// - Dispatches [AuthCubit.getCurrentUserData()] after the first frame.
/// - On any result (authenticated / unauthenticated / error) it updates
///   [RouterNotifier], which triggers GoRouter's `redirect` automatically.
///   No manual `context.go` needed here — the router handles everything.
class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    // Dispatch after first frame so context is fully mounted
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<AuthCubit>().getCurrentUserData();
      }
    });
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
              // Update RouterNotifier → GoRouter redirect fires automatically
              sl<RouterNotifier>().updateStatus(status);
            },
            unauthenticated: () {
              sl<RouterNotifier>().updateStatus(AuthStatus.unauthenticated);
            },
            error: (_) {
              // Treat any error as unauthenticated so we don't get stuck
              sl<RouterNotifier>().updateStatus(AuthStatus.unauthenticated);
            },
          );
        },
        child: const Center(
          child: _SplashContent(),
        ),
      ),
    );
  }
}

/// Isolated widget that owns its own animation lifecycle safely.
/// Keeping animations in a separate widget ensures [initState] always
/// completes before [build] runs — preventing LateInitializationError.
class _SplashContent extends StatefulWidget {
  const _SplashContent();

  @override
  State<_SplashContent> createState() => _SplashContentState();
}

class _SplashContentState extends State<_SplashContent>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scale;
  late final Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _scale = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.elasticOut),
    );
    _fade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeIn),
    );
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: ScaleTransition(
        scale: _scale,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                color: AppColors.primaryContainer.withValues(alpha: 0.15),
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.primaryContainer.withValues(alpha: 0.25),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryContainer.withValues(alpha: 0.20),
                    blurRadius: 32,
                    spreadRadius: 4,
                  ),
                ],
              ),
              child: const Icon(
                Icons.restaurant_rounded,
                size: 48,
                color: AppColors.primaryContainer,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'DineFlow',
              style: TextStyle(
                color: AppColors.onSurface,
                fontSize: 26,
                fontWeight: FontWeight.bold,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Your smart dining experience',
              style: TextStyle(
                color: AppColors.onSurfaceVariant.withValues(alpha: 0.6),
                fontSize: 13,
                letterSpacing: 0.2,
              ),
            ),
            const SizedBox(height: 48),
            SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                color: AppColors.primaryContainer.withValues(alpha: 0.7),
                strokeWidth: 2.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
