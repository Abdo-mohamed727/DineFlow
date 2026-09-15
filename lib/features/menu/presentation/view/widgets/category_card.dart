import 'package:dineflow/core/theme/app_colors.dart';
import 'package:dineflow/features/menu/domain/entity/category_entity.dart';
import 'package:flutter/material.dart';

class CategoryCard extends StatelessWidget {
  final CategoryEntity category;
  final bool isSelected;
  final VoidCallback onTap;

  const CategoryCard({
    super.key,
    required this.category,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 72,
            height: 72,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.primaryContainer.withValues(alpha: 0.2)
                  : AppColors.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected
                    ? AppColors.primaryContainer
                    : Colors.transparent,
                width: 1.5,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: category.imageUrl != null &&
                      category.imageUrl!.isNotEmpty
                  ? Image.network(
                      category.imageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          _buildDefaultIcon(),
                    )
                  : _buildDefaultIcon(),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            category.name,
            style: TextStyle(
              color: isSelected ? AppColors.primaryContainer : AppColors.onSurface,
              fontSize: 13,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildDefaultIcon() {
    return Icon(
      _getCategoryIconData(category.name),
      color: isSelected ? AppColors.primaryContainer : AppColors.onSurfaceVariant,
      size: 28,
    );
  }

  IconData _getCategoryIconData(String name) {
    final lower = name.toLowerCase();
    if (lower.contains('burger')) return Icons.lunch_dining_rounded;
    if (lower.contains('pizza')) return Icons.local_pizza_rounded;
    if (lower.contains('drink') || lower.contains('beverage')) {
      return Icons.local_drink_rounded;
    }
    if (lower.contains('dessert') || lower.contains('cake')) {
      return Icons.cake_rounded;
    }
    if (lower.contains('sandwich')) return Icons.bakery_dining_rounded;
    if (lower.contains('side')) return Icons.fastfood_rounded;
    return Icons.restaurant_rounded;
  }
}
