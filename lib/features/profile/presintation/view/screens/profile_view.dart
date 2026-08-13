import 'package:dineflow/core/theme/app_colors.dart';
import 'package:dineflow/core/widgets/app_loading_indicator.dart';
import 'package:dineflow/core/widgets/app_scaffold.dart';
import 'package:dineflow/features/auth/domain/entity/user_entity.dart';
import 'package:dineflow/features/profile/presintation/view/widgets/profile_content.dart';
import 'package:dineflow/features/profile/presintation/view_model/cubit/profile_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Profile screen: loads profile state and composes the profile widgets.
class ProfileView extends StatefulWidget {
  const ProfileView({super.key});
  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.read<ProfileCubit>().getProfile();
    });
  }

  @override
  Widget build(BuildContext context) => AppScaffold(
    title: 'Profile',
    role: AppRole.customer,
    body: BlocConsumer<ProfileCubit, ProfileState>(
      listener: (context, state) => state.whenOrNull(
        error: (message) => ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message), backgroundColor: AppColors.errorContainer),
        ),
      ),
      builder: (context, state) => state.when(
        initial: () => const SizedBox.shrink(),
        loading: () => const Center(child: AppLoadingIndicator()),
        loaded: (user) => ProfileContent(user: user),
        updateSuccess: (user) => ProfileContent(user: user),
        error: (_) => const ProfileContent(
          user: UserEntity(id: '', name: 'Unavailable', email: 'Unavailable', role: UserRole.customer),
        ),
      ),
    ),
  );
}
