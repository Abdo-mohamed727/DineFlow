import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'app_primary_button.dart';

 class AppErrorState extends StatelessWidget {
  const AppErrorState({
    super.key,
    this.title = 'Something went wrong',
    this.message,
    this.icon,
    this.iconData = Icons.error_outline_rounded,
    this.iconSize = 64.0,
    this.iconColor,
    this.retryText = 'Try Again',
    this.onRetry,
    this.padding = const EdgeInsets.all(24.0),
  });

  final String title;
  final String? message;
  final Widget? icon;
  final IconData? iconData;
  final double iconSize;
  final Color? iconColor;
  final String retryText;
  final VoidCallback? onRetry;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final effectiveIconColor = iconColor ?? AppColors.error;

    final Widget renderedIcon = icon ??
        Icon(
          iconData,
          size: iconSize,
          color: effectiveIconColor,
        );

    return Center(
      child: Padding(
        padding: padding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            renderedIcon,
            const SizedBox(height: 16.0),
            Text(
              title,
              style: const TextStyle(
                color: AppColors.onSurface,
                fontSize: 18.0,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            if (message != null && message!.isNotEmpty) ...[
              const SizedBox(height: 8.0),
              Text(
                message!,
                style: const TextStyle(
                  color: AppColors.onSurfaceVariant,
                  fontSize: 14.0,
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            if (onRetry != null) ...[
              const SizedBox(height: 24.0),
              AppPrimaryButton(
                text: retryText,
                onPressed: onRetry,
                icon: const Icon(Icons.refresh_rounded, size: 18.0),
                fullWidth: false,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
