import 'package:dineflow/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class MenuHeader extends StatelessWidget {
  final String userName;
  final VoidCallback? onNotificationPressed;

  const MenuHeader({
    super.key,
    this.userName = 'Guest',
    this.onNotificationPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hi $userName',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.onSurface.withValues(alpha: 0.6),
                    fontWeight: FontWeight.w400,
                  ),
            ),
            const SizedBox(height: 2),
            Text(
              'Good Food, Great Mood',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppColors.onSurface,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerHigh,
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: const Icon(
              Icons.notifications_outlined,
              color: AppColors.onSurface,
            ),
            onPressed: onNotificationPressed ?? () {},
          ),
        ),
      ],
    );
  }
}
