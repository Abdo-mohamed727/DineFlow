import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../theme/app_colors.dart';

class AppIconButton extends StatelessWidget {
  const AppIconButton({
    super.key,
    this.icon,
    this.iconData,
    this.onPressed,
    this.isLoading = false,
    this.size = 44.0,
    this.iconSize = 22.0,
    this.backgroundColor,
    this.iconColor,
    this.borderColor,
    this.borderRadius = 12.0,
    this.tooltip,
    this.badge,
  }) : assert(
         icon != null || iconData != null,
         'Either icon or iconData must be provided',
       );

  final Widget? icon;
  final IconData? iconData;
  final VoidCallback? onPressed;
  final bool isLoading;
  final double size;
  final double iconSize;
  final Color? backgroundColor;
  final Color? iconColor;
  final Color? borderColor;
  final double borderRadius;
  final String? tooltip;
  final Widget? badge;

  @override
  Widget build(BuildContext context) {
    final effectiveBgColor = backgroundColor ?? AppColors.surfaceContainerHigh;
    final effectiveIconColor = iconColor ?? AppColors.onSurface;
    final isInteractive = onPressed != null && !isLoading;

    final Widget renderedIcon = isLoading
        ? SizedBox(
            width: iconSize.w,
            height: iconSize.w,
            child: CircularProgressIndicator(
              strokeWidth: 2.0,
              valueColor: AlwaysStoppedAnimation<Color>(effectiveIconColor),
            ),
          )
        : icon ?? Icon(iconData, size: iconSize.r, color: effectiveIconColor);

    Widget content = Center(child: renderedIcon);

    if (badge != null) {
      content = Stack(
        clipBehavior: Clip.none,
        children: [
          content,
          Positioned(top: -2.h, right: -2.w, child: badge!),
        ],
      );
    }

    final buttonWidget = Container(
      width: size.w,
      height: size.w,
      decoration: BoxDecoration(
        color: isInteractive
            ? effectiveBgColor
            : effectiveBgColor.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(borderRadius.r),
        border: borderColor != null
            ? Border.all(
                color: isInteractive
                    ? borderColor!
                    : borderColor!.withValues(alpha: 0.3),
                width: 1.0,
              )
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isInteractive ? onPressed : null,
          borderRadius: BorderRadius.circular(borderRadius.r),
          child: content,
        ),
      ),
    );

    if (tooltip != null) {
      return Tooltip(message: tooltip!, child: buttonWidget);
    }

    return buttonWidget;
  }
}
