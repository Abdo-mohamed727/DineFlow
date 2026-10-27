import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../theme/app_colors.dart';

class AppSkeletonizer extends StatelessWidget {
  const AppSkeletonizer({
    super.key,
    required this.child,
    this.enabled = true,
    this.containersColor,
    this.effect,
    this.ignoreContainers,
  });

  final Widget child;
  final bool enabled;
  final Color? containersColor;
  final PaintingEffect? effect;
  final bool? ignoreContainers;

  @override
  Widget build(BuildContext context) {
    final defaultEffect = ShimmerEffect(
      baseColor: AppColors.surfaceContainerHigh,
      highlightColor: AppColors.surfaceBright,
    );

    return Skeletonizer(
      enabled: enabled,
      containersColor: containersColor ?? AppColors.surfaceContainerHigh,
      effect: effect ?? defaultEffect,
      ignoreContainers: ignoreContainers,
      child: child,
    );
  }
}
