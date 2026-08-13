import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/widgets/app_primary_button.dart';
import '../../../../../core/widgets/app_text_form_field.dart';
import '../../../domain/usecase/register_usecase.dart';
import '../../view_mode/cubit/auth_cubit.dart';

/// Register form containing Full Name, Email, Password, and Confirm Password
/// fields plus the submit button.
/// Owns its own [GlobalKey<FormState>] and [TextEditingController]s.
/// Reads [AuthCubit] from context to dispatch [AuthCubit.register].
class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final _emailRegex = RegExp(r'^[\w\-\.]+@([\w\-]+\.)+[\w\-]{2,4}$');

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthCubit>().register(
            RegisterParams(
              name: _nameController.text.trim(),
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
          // ── Full Name ────────────────────────────────────────────────────
          AppTextFormField(
            label: 'Full Name',
            hintText: 'John Doe',
            controller: _nameController,
            textInputAction: TextInputAction.next,
            prefixIcon: const Icon(
              Icons.person_outline_rounded,
              color: AppColors.onSurfaceVariant,
              size: 20.0,
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter your full name';
              }
              if (value.trim().length < 2) {
                return 'Name must be at least 2 characters';
              }
              return null;
            },
          ),
          const SizedBox(height: 20.0),

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
            textInputAction: TextInputAction.next,
            prefixIcon: const Icon(
              Icons.lock_outline_rounded,
              color: AppColors.onSurfaceVariant,
              size: 20.0,
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a password';
              }
              if (value.length < 6) {
                return 'Password must be at least 6 characters';
              }
              return null;
            },
          ),
          const SizedBox(height: 20.0),

          // ── Confirm Password ─────────────────────────────────────────────
          AppTextFormField(
            label: 'Confirm Password',
            hintText: '••••••••',
            controller: _confirmPasswordController,
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
                return 'Please confirm your password';
              }
              if (value != _passwordController.text) {
                return 'Passwords do not match';
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
                      color: AppColors.primaryContainer.withValues(alpha: 0.35),
                      blurRadius: 18.0,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: AppPrimaryButton(
                  text: 'Register',
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
