import 'package:dineflow/core/theme/app_colors.dart';
import 'package:dineflow/features/auth/domain/entity/user_entity.dart';
import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key, required this.user});

  final UserEntity user;

  String get _initials {
    final names = user.name.trim().split(RegExp(r'\s+'));
    if (names.length >= 2) {
      return '${names.first[0]}${names.last[0]}'.toUpperCase();
    }
    return user.name.isEmpty ? '?' : user.name[0].toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final hasProfileImage =
        user.profileImage != null && user.profileImage!.isNotEmpty;

    return Column(
      children: [
        Container(
          width: 90,
          height: 90,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              colors: [AppColors.primaryContainer, AppColors.inversePrimary],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryContainer.withValues(alpha: 0.35),
                blurRadius: 20,
                spreadRadius: 2,
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          alignment: Alignment.center,
          child: hasProfileImage
              ? Image.network(
                  user.profileImage!,
                  fit: BoxFit.cover,
                  width: 90,
                  height: 90,
                  errorBuilder: (context, error, stackTrace) => Text(
                    _initials,
                    style: const TextStyle(
                      color: AppColors.onPrimary,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              : Text(
                  _initials,
                  style: const TextStyle(
                    color: AppColors.onPrimary,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ),
        const SizedBox(height: 16),
        Text(
          user.name,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: AppColors.onSurface,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
          decoration: BoxDecoration(
            color: AppColors.primaryContainer.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppColors.primaryContainer.withValues(alpha: 0.3),
            ),
          ),
          child: Text(
            '${user.role.name[0].toUpperCase()}${user.role.name.substring(1)} account',
            style: const TextStyle(
              color: AppColors.primaryContainer,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
