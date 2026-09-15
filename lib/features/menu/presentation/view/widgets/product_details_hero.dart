import 'package:dineflow/core/theme/app_colors.dart';
import 'package:dineflow/features/menu/domain/entity/product_entity.dart';
import 'package:flutter/material.dart';

class ProductDetailsHero extends StatelessWidget {
  final ProductEntity product;
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;
  final VoidCallback onBackTap;

  const ProductDetailsHero({
    super.key,
    required this.product,
    required this.isFavorite,
    required this.onFavoriteToggle,
    required this.onBackTap,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 360,
          width: double.infinity,
          foregroundDecoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.black.withValues(alpha: 0.6),
                Colors.transparent,
                AppColors.background.withValues(alpha: 0.8),
                AppColors.background,
              ],
              stops: const [0.0, 0.3, 0.85, 1.0],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: product.imageUrl != null && product.imageUrl!.isNotEmpty
              ? Image.network(
                  product.imageUrl!,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      _buildImageFallback(),
                )
              : _buildImageFallback(),
        ),

        // Navigation Top Bar Buttons
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Back Button
                GestureDetector(
                  onTap: onBackTap,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.55),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),

                // Favorite Toggle Button
                GestureDetector(
                  onTap: onFavoriteToggle,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.55),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border_rounded,
                      color: isFavorite
                          ? AppColors.primaryContainer
                          : AppColors.primaryContainer.withValues(alpha: 0.9),
                      size: 22,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // Floating Craving Tag Overlay
        Positioned(
          top: 100,
          right: 24,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppColors.primaryContainer.withValues(alpha: 0.6),
                width: 1,
              ),
            ),
            child: const Text(
              'VIBRANT CRAVINGS',
              style: TextStyle(
                color: AppColors.primaryContainer,
                fontSize: 10,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.8,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildImageFallback() {
    return Container(
      color: AppColors.surfaceContainerHigh,
      child: const Center(
        child: Icon(
          Icons.fastfood_rounded,
          color: AppColors.onSurfaceVariant,
          size: 80,
        ),
      ),
    );
  }
}
