import 'package:dineflow/core/theme/app_colors.dart';
import 'package:dineflow/core/widgets/app_primary_button.dart';
import 'package:dineflow/core/widgets/app_text_form_field.dart';
import 'package:dineflow/features/auth/domain/entity/user_entity.dart';
import 'package:dineflow/features/profile/domain/usecase/update_profile_usecase.dart';
import 'package:dineflow/features/profile/presintation/view_model/cubit/profile_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Editable profile fields. It owns the form controllers and submits updates.
class EditProfileForm extends StatefulWidget {
  const EditProfileForm({super.key, required this.user});
  final UserEntity user;

  @override
  State<EditProfileForm> createState() => _EditProfileFormState();
}

class _EditProfileFormState extends State<EditProfileForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.name);
    _phoneController = TextEditingController(text: widget.user.phone ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    context.read<ProfileCubit>().updateProfile(UpdateProfileParams(
      name: _nameController.text.trim(),
      phone: _phoneController.text.trim().isEmpty ? null : _phoneController.text.trim(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final initials = widget.user.name.trim().isEmpty ? '?' : widget.user.name.trim()[0].toUpperCase();
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(24, 28, 24, 40),
        children: [
          Center(
            child: CircleAvatar(
              radius: 48,
              backgroundColor: AppColors.primaryContainer,
              child: Text(initials, style: const TextStyle(color: AppColors.onPrimary, fontSize: 32, fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(height: 10),
          Center(child: TextButton.icon(
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Photo editing coming soon'))),
            icon: const Icon(Icons.camera_alt_outlined, size: 16),
            label: const Text('Change photo'),
          )),
          const SizedBox(height: 24),
          AppTextFormField(
            label: 'Full Name',
            controller: _nameController,
            hintText: 'John Doe',
            keyboardType: TextInputType.name,
            textInputAction: TextInputAction.next,
            prefixIcon: const Icon(Icons.person_outline_rounded, color: AppColors.onSurfaceVariant),
            validator: (value) => value == null || value.trim().isEmpty ? 'Name cannot be empty' : null,
          ),
          const SizedBox(height: 18),
          AppTextFormField(
            label: 'Email Address',
            initialValue: widget.user.email,
            readOnly: true,
            enabled: false,
            prefixIcon: const Icon(Icons.mail_outline_rounded, color: AppColors.onSurfaceVariant),
          ),
          const SizedBox(height: 18),
          AppTextFormField(
            label: 'Phone Number',
            controller: _phoneController,
            hintText: '+1 (555) 123-4567',
            keyboardType: TextInputType.phone,
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (_) => _submit(),
            prefixIcon: const Icon(Icons.phone_outlined, color: AppColors.onSurfaceVariant),
          ),
          const SizedBox(height: 36),
          BlocBuilder<ProfileCubit, ProfileState>(
            builder: (context, state) => AppPrimaryButton(
              text: 'Save Changes',
              isLoading: state.maybeWhen(loading: () => true, orElse: () => false),
              onPressed: _submit,
              icon: const Icon(Icons.save_outlined, size: 18, color: AppColors.onPrimaryContainer),
            ),
          ),
        ],
      ),
    );
  }
}
