import 'package:dineflow/core/theme/app_colors.dart';
import 'package:dineflow/features/cart/domain/entites/cart_entity.dart';
import 'package:flutter/material.dart';

class CartItemTile extends StatelessWidget {
  const CartItemTile({
    super.key,
    required this.item,
    required this.isUpdating,
    required this.onIncrement,
    required this.onDecrement,
    required this.onRemove,
  });

  final CartItemEntity item;
  final bool isUpdating;
  final VoidCallback onIncrement;
  final VoidCallback? onDecrement;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final product = item.product;
    final subtitleText = product.description.isNotEmpty
        ? product.description
        : (product.category.name.isNotEmpty
            ? product.category.name
            : 'Standard Prep');

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.surfaceContainerHigh.withValues(alpha: 0.5),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Image Thumbnail
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: SizedBox(
              width: 76,
              height: 76,
              child: product.image.isNotEmpty
                  ? Image.network(
                      product.image,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => _placeholder(),
                    )
                  : _placeholder(),
            ),
          ),
          const SizedBox(width: 14),

          // Details + Controls Column
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title and Remove X Button
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.name.isNotEmpty ? product.name : 'Item',
                            style: const TextStyle(
                              color: AppColors.onSurface,
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            subtitleText,
                            style: TextStyle(
                              color: AppColors.onSurfaceVariant
                                  .withValues(alpha: 0.75),
                              fontSize: 12.5,
                              fontWeight: FontWeight.w400,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: isUpdating ? null : onRemove,
                      behavior: HitTestBehavior.opaque,
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Icon(
                          Icons.close_rounded,
                          size: 18,
                          color: AppColors.onSurfaceVariant.withValues(alpha: 0.6),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Price and Quantity Controls Pill
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '\$${item.lineTotal}',
                      style: const TextStyle(
                        color: AppColors.primaryContainer,
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                      ),
                    ),
                    _QuantityPill(
                      quantity: item.quantity,
                      isUpdating: isUpdating,
                      onIncrement: onIncrement,
                      onDecrement: onDecrement,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _placeholder() {
    return Container(
      color: AppColors.surfaceContainerHigh,
      child: const Icon(
        Icons.fastfood_rounded,
        color: AppColors.onSurfaceVariant,
        size: 32,
      ),
    );
  }
}

class _QuantityPill extends StatelessWidget {
  const _QuantityPill({
    required this.quantity,
    required this.isUpdating,
    required this.onIncrement,
    this.onDecrement,
  });

  final int quantity;
  final bool isUpdating;
  final VoidCallback onIncrement;
  final VoidCallback? onDecrement;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 34,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerHigh.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.outlineVariant.withValues(alpha: 0.25),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: isUpdating ? null : onDecrement,
            icon: Icon(
              Icons.remove,
              size: 14,
              color: onDecrement != null
                  ? AppColors.onSurface
                  : AppColors.onSurfaceVariant.withValues(alpha: 0.3),
            ),
            constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
            padding: EdgeInsets.zero,
            splashRadius: 14,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: isUpdating
                ? const SizedBox(
                    width: 12,
                    height: 12,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.primaryContainer,
                    ),
                  )
                : Text(
                    '$quantity',
                    style: const TextStyle(
                      color: AppColors.onSurface,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
          ),
          IconButton(
            onPressed: isUpdating ? null : onIncrement,
            icon: const Icon(
              Icons.add,
              size: 14,
              color: AppColors.primaryContainer,
            ),
            constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
            padding: EdgeInsets.zero,
            splashRadius: 14,
          ),
        ],
      ),
    );
  }
}
