import 'package:dineflow/core/router/app_routes.dart';
import 'package:dineflow/core/theme/app_colors.dart';
import 'package:dineflow/core/widgets/app_scaffold.dart';
import 'package:dineflow/features/auth/presintation/view_mode/cubit/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../widgets/auth_bottom_link.dart';
import '../widgets/auth_form_card.dart';
import '../widgets/auth_header.dart';
import '../widgets/register_form.dart';

/// Register screen — thin composer with responsive layout preventing flex overflow.
class RegisterView extends StatelessWidget {
  const RegisterView({super.key});

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
                          title: 'Create Account',
                          subtitle: "Let's get started with your cravings.",
                        ),
                        const SizedBox(height: 24.0),
                        const AuthFormCard(child: RegisterForm()),
                        const SizedBox(height: 24.0),
                        AuthBottomLink(
                          label: 'Already have an account? ',
                          linkText: 'Login',
                          onTap: () => context.goNamed(AppRoutes.login),
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
