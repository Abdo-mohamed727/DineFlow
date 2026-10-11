import 'package:cached_network_image/cached_network_image.dart';
import 'package:dineflow/core/theme/app_colors.dart';
import 'package:dineflow/core/widgets/app_primary_button.dart';
import 'package:dineflow/core/widgets/app_text_form_field.dart';
import 'package:dineflow/features/auth/domain/entity/user_entity.dart';
import 'package:dineflow/features/profile/domain/usecase/update_profile_usecase.dart';
import 'package:dineflow/features/profile/presintation/view_model/cubit/profile_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

/// Editable profile fields. It owns the form controllers and submits updates.
class EditProfileForm extends StatefulWidget {
  const EditProfileForm({super.key, required this.user, this.pickImage});

  final UserEntity user;
  final Future<XFile?> Function()? pickImage;

  @override
  State<EditProfileForm> createState() => _EditProfileFormState();
}

class _EditProfileFormState extends State<EditProfileForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  bool _isPickingImage = false;

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
    if (_isPickingImage) return;
    if (!(_formKey.currentState?.validate() ?? false)) return;
    context.read<ProfileCubit>().updateProfile(
      UpdateProfileParams(
        name: _nameController.text.trim(),
        phone: _phoneController.text.trim().isEmpty
            ? null
            : _phoneController.text.trim(),
      ),
      user: widget.user,
    );
  }

  Future<void> _pickImage() async {
    if (_isPickingImage) return;
    setState(() => _isPickingImage = true);
    try {
      final pickImage = widget.pickImage;
      final image = pickImage == null
          ? await ImagePicker().pickImage(source: ImageSource.gallery)
          : await pickImage();
      if (image != null && mounted) {
        await context.read<ProfileCubit>().selectProfileImage(
          image,
          user: widget.user,
        );
      }
    } on PlatformException catch (error) {
      if (mounted) {
        context.read<ProfileCubit>().reportPickerError(
          'Unable to select an image: ${error.message ?? error.code}',
          user: widget.user,
        );
      }
    } finally {
      if (mounted) setState(() => _isPickingImage = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final initials = widget.user.name.trim().isEmpty
        ? '?'
        : widget.user.name.trim()[0].toUpperCase();
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(24, 28, 24, 40),
        children: [
          BlocBuilder<ProfileCubit, ProfileState>(
            builder: (context, state) {
              final imagePreview = state.maybeWhen(
                loaded: (_, imagePreview) => imagePreview,
                loading: (_, imagePreview) => imagePreview,
                error: (_, _, imagePreview) => imagePreview,
                orElse: () => null,
              );
              return Center(
                child: CircleAvatar(
                  radius: 48,
                  backgroundColor: AppColors.primaryContainer,
                  child: imagePreview != null
                      ? ClipOval(
                          child: Image.memory(
                            imagePreview,
                            width: 96,
                            height: 96,
                            fit: BoxFit.cover,
                          ),
                        )
                      : widget.user.profileImage?.isNotEmpty == true
                      ? ClipOval(
                          child: CachedNetworkImage(
                            imageUrl: widget.user.profileImage!,
                            width: 96,
                            height: 96,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => const Center(
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppColors.onPrimary,
                              ),
                            ),
                            errorWidget: (_, __, ___) => Text(
                              initials,
                              style: const TextStyle(
                                color: AppColors.onPrimary,
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        )
                      : Text(
                          initials,
                          style: const TextStyle(
                            color: AppColors.onPrimary,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              );
            },
          ),
          const SizedBox(height: 10),
          BlocBuilder<ProfileCubit, ProfileState>(
            builder: (context, state) {
              final isSaving = state.maybeWhen(
                loading: (_, _) => true,
                orElse: () => false,
              );
              return Center(
                child: TextButton.icon(
                  onPressed: _isPickingImage || isSaving ? null : _pickImage,
                  icon: _isPickingImage
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.camera_alt_outlined, size: 16),
                  label: Text(
                    _isPickingImage ? 'Selecting photo...' : 'Change photo',
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 24),
          AppTextFormField(
            label: 'Full Name',
            controller: _nameController,
            hintText: 'John Doe',
            keyboardType: TextInputType.name,
            textInputAction: TextInputAction.next,
            prefixIcon: const Icon(
              Icons.person_outline_rounded,
              color: AppColors.onSurfaceVariant,
            ),
            validator: (value) => value == null || value.trim().isEmpty
                ? 'Name cannot be empty'
                : null,
          ),
          const SizedBox(height: 18),
          AppTextFormField(
            label: 'Email Address',
            initialValue: widget.user.email,
            readOnly: true,
            enabled: false,
            prefixIcon: const Icon(
              Icons.mail_outline_rounded,
              color: AppColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 18),
          AppTextFormField(
            label: 'Phone Number',
            controller: _phoneController,
            hintText: '+1 (555) 123-4567',
            keyboardType: TextInputType.phone,
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (_) => _submit(),
            prefixIcon: const Icon(
              Icons.phone_outlined,
              color: AppColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 36),
          BlocBuilder<ProfileCubit, ProfileState>(
            builder: (context, state) {
              final isLoading = state.maybeWhen(
                loading: (_, _) => true,
                orElse: () => false,
              );
              return AppPrimaryButton(
                text: 'Save Changes',
                isLoading: isLoading,
                onPressed: isLoading || _isPickingImage ? null : _submit,
                icon: const Icon(
                  Icons.save_outlined,
                  size: 18,
                  color: AppColors.onPrimaryContainer,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
