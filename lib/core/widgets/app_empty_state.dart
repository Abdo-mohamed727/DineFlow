import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'app_primary_button.dart';
 
class AppEmptyState extends StatelessWidget {
  const AppEmptyState({
    super.key,
    required this.title,
    this.message,
    this.icon,
    this.iconData = Icons.inbox_outlined,
    this.iconSize = 64.0,
    this.iconColor,
    this.actionText,
    this.onAction,
    this.actionButton,
    this.padding = const EdgeInsets.all(24.0),
  });

  final String title;
  final String? message;
  final Widget? icon;
  final IconData? iconData;
  final double iconSize;
  final Color? iconColor;
  final String? actionText;
  final VoidCallback? onAction;
  final Widget? actionButton;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final effectiveIconColor =
        iconColor ?? AppColors.onSurfaceVariant.withValues(alpha: 0.6);

    final Widget renderedIcon = icon ??
        Icon(
          iconData,
          size: iconSize,
          color: effectiveIconColor,
        );

    final Widget? renderedActionButton = actionButton ??
        ((actionText != null && onAction != null)
            ? AppPrimaryButton(
                text: actionText!,
                onPressed: onAction,
                fullWidth: false,
              )
            : null);

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
            if (renderedActionButton != null) ...[
              const SizedBox(height: 24.0),
              renderedActionButton,
            ],
          ],
        ),
      ),
    );
  }
}
