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

import '../widgets/auth_bottom_link.dart';
import '../widgets/auth_form_card.dart';
import '../widgets/auth_header.dart';
import '../widgets/login_form.dart';

/// Login screen — thin composer with responsive layout preventing flex overflow.
class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      showAppBar: false,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: (constraints.maxHeight - 48.0).clamp(0.0, double.infinity),
                ),
                child: IntrinsicHeight(
                  child: BlocListener<AuthCubit, AuthState>(
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
                        error: (message) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(message),
                              backgroundColor: AppColors.error,
                            ),
                          );
                        },
                      );
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const AuthHeader(
                          title: 'Welcome Back',
                          subtitle: 'Sign in to continue your delicious journey.',
                        ),
                        const SizedBox(height: 24.0),
                        const AuthFormCard(child: LoginForm()),
                        const SizedBox(height: 24.0),
                        AuthBottomLink(
                          label: "Don't have an account? ",
                          linkText: 'Register',
                          onTap: () => context.goNamed(AppRoutes.register),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
