import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../theme/app_colors.dart';

 class AppPrimaryButton extends StatelessWidget {
  const AppPrimaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.icon,
    this.fullWidth = true,
    this.height = 48.0,
    this.borderRadius = 12.0,
    this.backgroundColor,
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
  final Color? textColor;
  final double fontSize;
  final FontWeight fontWeight;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final effectiveBgColor = backgroundColor ?? AppColors.primaryContainer;
    final effectiveTextColor = textColor ?? AppColors.onPrimaryContainer;
    final isInteractive = onPressed != null && !isLoading;

    final childContent = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (isLoading) ...[
          SizedBox(
            width: 20.w,
            height: 20.w,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              valueColor: AlwaysStoppedAnimation<Color>(effectiveTextColor),
            ),
          ),
          SizedBox(width: 10.w),
        ] else if (icon != null) ...[
          icon!,
          SizedBox(width: 8.w),
        ],
        Text(
          text,
          style: TextStyle(
            color: effectiveTextColor,
            fontSize: fontSize.sp,
            fontWeight: fontWeight,
          ),
        ),
      ],
    );

    final buttonWidget = ElevatedButton(
      onPressed: isInteractive ? onPressed : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: effectiveBgColor,
        foregroundColor: effectiveTextColor,
        disabledBackgroundColor: effectiveBgColor.withValues(alpha: 0.4),
        disabledForegroundColor: effectiveTextColor.withValues(alpha: 0.4),
        elevation: 0.0,
        padding: padding ?? EdgeInsets.symmetric(horizontal: 16.w),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius.r),
        ),
        minimumSize: Size(fullWidth ? double.infinity : 0.0, height.h),
        maximumSize: Size(fullWidth ? double.infinity : double.infinity, height.h),
      ),
      child: childContent,
    );

    return buttonWidget;
  }
}
