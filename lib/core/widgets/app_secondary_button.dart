import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
 
class AppSecondaryButton extends StatelessWidget {
  const AppSecondaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.icon,
    this.fullWidth = true,
    this.height = 48.0,
    this.borderRadius = 12.0,
    this.backgroundColor,
    this.borderColor,
    this.textColor,
    this.fontSize = 16.0,
    this.fontWeight = FontWeight.w600,
    this.padding,
  });

  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final Widget? icon;
  final bool fullWidth;
  final double height;
  final double borderRadius;
  final Color? backgroundColor;
  final Color? borderColor;
  final Color? textColor;
  final double fontSize;
  final FontWeight fontWeight;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final effectiveBgColor = backgroundColor ?? AppColors.surfaceContainerHigh;
    final effectiveBorderColor = borderColor ?? AppColors.outline;
    final effectiveTextColor = textColor ?? AppColors.onSurface;
    final isInteractive = onPressed != null && !isLoading;

    final childContent = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (isLoading) ...[
          SizedBox(
            width: 20.0,
            height: 20.0,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              valueColor: AlwaysStoppedAnimation<Color>(effectiveTextColor),
            ),
          ),
          const SizedBox(width: 10.0),
        ] else if (icon != null) ...[
          icon!,
          const SizedBox(width: 8.0),
        ],
        Text(
          text,
          style: TextStyle(
            color: effectiveTextColor,
            fontSize: fontSize,
            fontWeight: fontWeight,
          ),
        ),
      ],
    );

    return OutlinedButton(
      onPressed: isInteractive ? onPressed : null,
      style: OutlinedButton.styleFrom(
        backgroundColor: effectiveBgColor,
        foregroundColor: effectiveTextColor,
        disabledBackgroundColor: effectiveBgColor.withValues(alpha: 0.4),
        disabledForegroundColor: effectiveTextColor.withValues(alpha: 0.4),
        side: BorderSide(
          color: isInteractive
              ? effectiveBorderColor
              : effectiveBorderColor.withValues(alpha: 0.3),
          width: 1.0,
        ),
        elevation: 0.0,
        padding: padding ?? const EdgeInsets.symmetric(horizontal: 16.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        minimumSize: Size(fullWidth ? double.infinity : 0.0, height),
        maximumSize: Size(fullWidth ? double.infinity : double.infinity, height),
      ),
      child: childContent,
    );
  }
}
