import 'package:dineflow/core/router/app_routes.dart';
import 'package:dineflow/core/theme/app_colors.dart';
import 'package:dineflow/core/widgets/app_primary_button.dart';
import 'package:dineflow/features/auth/domain/entity/user_entity.dart';
import 'package:dineflow/features/auth/presintation/view_mode/cubit/auth_cubit.dart';
import 'package:dineflow/features/profile/presintation/view_model/cubit/profile_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'profile_header.dart';

class ProfileContent extends StatelessWidget {
  const ProfileContent({super.key, required this.user});
  final UserEntity user;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 28, 20, 120),
      children: [
        ProfileHeader(user: user),
        const SizedBox(height: 28),
        OutlinedButton.icon(
          onPressed: () async {
            final didUpdate = await context.pushNamed<bool>(
              AppRoutes.customerEditProfile,
              extra: user,
            );

            if (didUpdate == true && context.mounted) {
              context.read<ProfileCubit>().getProfile();
            }
          },
          icon: const Icon(Icons.edit_outlined, size: 18),
          label: const Text('Edit profile'),
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.primaryContainer,
            padding: const EdgeInsets.symmetric(vertical: 14),
            side: BorderSide(
              color: AppColors.primaryContainer.withValues(alpha: 0.55),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ),
        const SizedBox(height: 20),
        _ProfileCard(
          children: [
            _InfoRow('Full Name', user.name, Icons.person_outline_rounded),
            _InfoRow('Email', user.email, Icons.mail_outline_rounded),
            _InfoRow(
              'Phone Number',
              user.phone?.isNotEmpty == true ? user.phone! : 'Not added',
              Icons.phone_outlined,
              showDivider: false,
            ),
          ],
        ),
        const SizedBox(height: 20),
        _ProfileCard(
          children: [
            _MenuRow(
              'My Orders',
              Icons.receipt_long_outlined,
              () => context.goNamed(AppRoutes.customerOrders),
            ),
            _MenuRow(
              'Favourites',
              Icons.favorite_border_rounded,
              () => context.goNamed(AppRoutes.customerFavourites),
            ),
            _MenuRow(
              'Payment Methods',
              Icons.credit_card_outlined,
              () => _comingSoon(context, 'Payment methods'),
            ),
            _MenuRow(
              'Help & Support',
              Icons.help_outline_rounded,
              () => _comingSoon(context, 'Help & support'),
              showDivider: false,
            ),
          ],
        ),
        const SizedBox(height: 28),
        AppPrimaryButton(
          onPressed: () {
            context.read<AuthCubit>().logout();
          },
          text: 'Logout',
          backgroundColor: AppColors.inversePrimary,
        ),
      ],
    );
  }

  void _comingSoon(BuildContext context, String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(feature + ' will be available soon.')),
    );
  }
}

class _ProfileCard extends StatelessWidget {
  const _ProfileCard({required this.children});
  final List<Widget> children;
  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
      color: AppColors.surfaceContainerLow,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(
        color: AppColors.outlineVariant.withValues(alpha: 0.35),
      ),
    ),
    child: Column(children: children),
  );
}

class _InfoRow extends StatelessWidget {
  const _InfoRow(this.label, this.value, this.icon, {this.showDivider = true});
  final String label;
  final String value;
  final IconData icon;
  final bool showDivider;
  @override
  Widget build(BuildContext context) => _ProfileRow(
    title: label,
    subtitle: value,
    icon: icon,
    showDivider: showDivider,
  );
}

class _MenuRow extends StatelessWidget {
  const _MenuRow(this.label, this.icon, this.onTap, {this.showDivider = true});
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final bool showDivider;
  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    child: _ProfileRow(
      title: label,
      icon: icon,
      showDivider: showDivider,
      trailing: const Icon(
        Icons.chevron_right_rounded,
        color: AppColors.onSurfaceVariant,
      ),
    ),
  );
}

class _ProfileRow extends StatelessWidget {
  const _ProfileRow({
    required this.title,
    required this.icon,
    required this.showDivider,
    this.subtitle,
    this.trailing,
  });
  final String title;
  final String? subtitle;
  final IconData icon;
  final bool showDivider;
  final Widget? trailing;
  @override
  Widget build(BuildContext context) => Column(
    children: [
      Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, size: 18, color: AppColors.primaryContainer),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: AppColors.onSurfaceVariant.withValues(alpha: 0.7),
                      fontSize: subtitle == null ? 15 : 11,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 5),
                    Text(
                      subtitle!,
                      style: const TextStyle(
                        color: AppColors.onSurface,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (trailing != null) trailing!,
          ],
        ),
      ),
      if (showDivider)
        Divider(
          height: 1,
          indent: 16,
          endIndent: 16,
          color: AppColors.outlineVariant.withValues(alpha: 0.3),
        ),
    ],
  );
}
