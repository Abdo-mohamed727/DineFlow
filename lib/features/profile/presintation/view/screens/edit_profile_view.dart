import 'package:dineflow/core/theme/app_colors.dart';
import 'package:dineflow/core/widgets/app_scaffold.dart';
import 'package:dineflow/features/auth/domain/entity/user_entity.dart';
import 'package:dineflow/features/profile/presintation/view/widgets/edit_profile_form.dart';
import 'package:dineflow/features/profile/presintation/view_model/cubit/profile_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Screen wrapper for edit-profile feedback and navigation.
class EditProfileView extends StatelessWidget {
  const EditProfileView({super.key, required this.user});

  final UserEntity user;

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Edit Profile',
      role: AppRole.customer,
      resizeToAvoidBottomInset: true,
      body: BlocListener<ProfileCubit, ProfileState>(
        listener: (context, state) {
          state.whenOrNull(
            updateSuccess: (_) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Profile updated successfully!'),
                  backgroundColor: Color(0xFF1B5E20),
                ),
              );
              Navigator.of(context).pop(true);
            },
            error: (message) => ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(message),
                backgroundColor: AppColors.errorContainer,
              ),
            ),
          );
        },
        child: EditProfileForm(user: user),
      ),
    );
  }
}
