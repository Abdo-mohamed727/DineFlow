import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/widgets/app_primary_button.dart';
import '../../../../../core/widgets/app_text_form_field.dart';
import '../../../domain/usecase/login_usecase.dart';
import '../../view_mode/cubit/auth_cubit.dart';

/// Login form containing Email & Password fields plus the submit button.
/// Owns its own [GlobalKey<FormState>] and [TextEditingController]s.
/// Reads [AuthCubit] from context to dispatch [AuthCubit.login].
class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final _emailRegex = RegExp(r'^[\w\-\.]+@([\w\-]+\.)+[\w\-]{2,4}$');

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthCubit>().login(
        LoginParams(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Email ────────────────────────────────────────────────────────
          AppTextFormField(
            label: 'Email',
            hintText: 'you@example.com',
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            prefixIcon: const Icon(
              Icons.mail_outline_rounded,
              color: AppColors.onSurfaceVariant,
              size: 20.0,
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter your email';
              }
              if (!_emailRegex.hasMatch(value.trim())) {
                return 'Please enter a valid email address';
              }
              return null;
            },
          ),
          const SizedBox(height: 20.0),

          // ── Password ─────────────────────────────────────────────────────
          AppTextFormField(
            label: 'Password',
            hintText: '••••••••',
            controller: _passwordController,
            isPassword: true,
            textInputAction: TextInputAction.done,
            prefixIcon: const Icon(
              Icons.lock_outline_rounded,
              color: AppColors.onSurfaceVariant,
              size: 20.0,
            ),
            onFieldSubmitted: (_) => _submit(),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your password';
              }
              return null;
            },
          ),
          const SizedBox(height: 28.0),

          // ── Submit button ─────────────────────────────────────────────────
          BlocBuilder<AuthCubit, AuthState>(
            builder: (context, state) {
              final isLoading = state.maybeWhen(
                loading: () => true,
                orElse: () => false,
              );
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryContainer.withValues(alpha: 0.16),
                      blurRadius: 10.0,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: AppPrimaryButton(
                  text: 'Login',
                  height: 50.0,
                  isLoading: isLoading,
                  onPressed: _submit,
                  icon: const Icon(
                    Icons.arrow_forward_rounded,
                    size: 18.0,
                    color: AppColors.onPrimaryContainer,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
