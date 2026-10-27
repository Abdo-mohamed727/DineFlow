import 'package:cached_network_image/cached_network_image.dart';
import 'package:dineflow/core/theme/app_colors.dart';
import 'package:dineflow/core/widgets/app_scaffold.dart';
import 'package:dineflow/features/auth/domain/entity/user_entity.dart';
import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({
    super.key,
    required this.user,
    this.role = AppRole.customer,
  });

  final UserEntity user;
  final AppRole role;

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
    final isCustomer = role == AppRole.customer;
    final accent = role.accentColor;
    final avatarForeground = isCustomer
        ? AppColors.onPrimary
        : AppColors.surface;

    return Column(
      children: [
        Container(
          width: 90,
          height: 90,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: isCustomer
                  ? [AppColors.primaryContainer, AppColors.inversePrimary]
                  : [accent, accent.withValues(alpha: 0.75)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: (isCustomer ? AppColors.primaryContainer : accent)
                    .withValues(alpha: 0.35),
                blurRadius: 20,
                spreadRadius: 2,
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          alignment: Alignment.center,
          child: hasProfileImage
              ? CachedNetworkImage(
                  imageUrl: user.profileImage!,
                  fit: BoxFit.cover,
                  width: 90,
                  height: 90,
                  placeholder: (context, url) => SizedBox(
                    width: 90,
                    height: 90,
                    child: Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: avatarForeground,
                      ),
                    ),
                  ),
                  errorWidget: (context, url, error) => Text(
                    _initials,
                    style: TextStyle(
                      color: avatarForeground,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              : Text(
                  _initials,
                  style: TextStyle(
                    color: avatarForeground,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ),
        const SizedBox(height: 16),
        Text(
          user.name,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isCustomer ? AppColors.onSurface : accent,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
          decoration: BoxDecoration(
            color: accent.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: accent.withValues(alpha: 0.3)),
          ),
          child: Text(
            '${user.role.name[0].toUpperCase()}${user.role.name.substring(1)} account',
            style: TextStyle(
              color: accent,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
