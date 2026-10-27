import 'package:cached_network_image/cached_network_image.dart';
import 'package:dineflow/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

/// A drop-in replacement for [Image.network] that caches images to disk,
/// shows a shimmer-style loading placeholder, and falls back gracefully on error.
///
/// Pass [fallbackWidget] to override the default icon placeholder.
class AppNetworkImage extends StatelessWidget {
  const AppNetworkImage({
    super.key,
    required this.url,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
    this.fallbackWidget,
    this.fallbackIcon = Icons.image_not_supported_rounded,
    this.borderRadius,
  });

  final String url;
  final BoxFit fit;
  final double? width;
  final double? height;

  /// Custom widget shown when the image fails to load or the URL is empty.
  final Widget? fallbackWidget;

  /// Icon used in the default fallback widget.
  final IconData fallbackIcon;

  /// If set, wraps the image in a [ClipRRect] with this radius.
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    Widget image;

    if (url.isEmpty) {
      image = _buildFallback();
    } else {
      image = CachedNetworkImage(
        imageUrl: url,
        fit: fit,
        width: width,
        height: height,
        placeholder: (context, url) => _buildShimmer(),
        errorWidget: (context, url, error) => _buildFallback(),
      );
    }

    if (borderRadius != null) {
      return ClipRRect(borderRadius: borderRadius!, child: image);
    }
    return image;
  }

  Widget _buildShimmer() {
    return Container(
      width: width,
      height: height,
      color: AppColors.surfaceContainerHigh,
      child: const Center(
        child: SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: AppColors.primaryContainer,
          ),
        ),
      ),
    );
  }

  Widget _buildFallback() {
    return fallbackWidget ??
        Container(
          width: width,
          height: height,
          color: AppColors.surfaceContainerHigh,
          child: Center(
            child: Icon(
              fallbackIcon,
              color: AppColors.onSurfaceVariant,
              size: 32,
            ),
          ),
        );
  }
}
