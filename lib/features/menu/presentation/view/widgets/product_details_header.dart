import 'package:dineflow/core/theme/app_colors.dart';
import 'package:dineflow/features/menu/domain/entity/product_entity.dart';
import 'package:flutter/material.dart';

class ProductDetailsHeader extends StatelessWidget {
  final ProductEntity product;

  const ProductDetailsHeader({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    const prepTime = '15-20 min';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title & Price Row
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                product.name,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: AppColors.onSurface,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '\$${product.price.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  product.isAvailable ? 'In Stock' : 'Out of Stock',
                  style: TextStyle(
                    color: product.isAvailable
                        ? const Color(0xFF22C55E)
                        : Colors.redAccent,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Rating & Metadata Row
        Row(
          children: [
            // Rating Badge
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.star_rounded,
                    color: Colors.amber,
                    size: 16,
                  ),
                  SizedBox(width: 4),
                  Text(
                    '4.8',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 2),
                  Text(
                    '(120)',
                    style: TextStyle(
                      color: AppColors.outline,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Text(
              '• Fast Food • $prepTime',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.6),
                fontSize: 13,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // Description
        Text(
          product.description.isNotEmpty
              ? product.description
              : 'Juicy beef patty with cheese, lettuce, tomato, onion and our special sauce, served on a toasted sesame seed bun. A classic craving satisfied.',
          style: TextStyle(
            color: AppColors.onSurface.withValues(alpha: 0.75),
            fontSize: 14,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 24),
        Divider(color: AppColors.surfaceContainerHigh.withValues(alpha: 0.6)),
      ],
    );
  }
}
