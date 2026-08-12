import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class AppLoadingIndicator extends StatelessWidget {
  const AppLoadingIndicator({
    super.key,
    this.message,
    this.size = 36.0,
    this.strokeWidth = 3.0,
    this.color,
    this.center = true,
  });

  final String? message;
  final double size;
  final double strokeWidth;
  final Color? color;
  final bool center;

  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ?? AppColors.primaryContainer;

    Widget content = Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: size,
          height: size,
          child: CircularProgressIndicator(
            strokeWidth: strokeWidth,
            valueColor: AlwaysStoppedAnimation<Color>(effectiveColor),
          ),
        ),
        if (message != null && message!.isNotEmpty) ...[
          const SizedBox(height: 12.0),
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
      ],
    );

    if (center) {
      return Center(child: content);
    }

    return content;
  }
}
