import 'package:dineflow/core/theme/app_colors.dart';
import 'package:dineflow/features/menu/domain/entity/product_entity.dart';
import 'package:dineflow/features/waiter/presentation/view/widget/create_order/order_quantity_control.dart';
import 'package:flutter/material.dart';

class OrderProductCard extends StatelessWidget {
  final ProductEntity product;
  final int quantity;
  final ValueChanged<int> onQuantityChanged;

  const OrderProductCard({
    super.key,
    required this.product,
    required this.quantity,
    required this.onQuantityChanged,
  });

  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(bottom: 12),
    padding: const EdgeInsets.all(13),
    decoration: BoxDecoration(
      color: AppColors.surfaceContainerLow,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(
        color: quantity > 0
            ? AppColors.waiterPrimary
            : AppColors.outlineVariant,
        width: quantity > 0 ? 1 : 0.6,
      ),
    ),
    child: Row(
      children: [
        _ProductImage(image: product.image),
        const SizedBox(width: 12),
        Expanded(child: _ProductInfo(product: product)),
        const SizedBox(width: 8),
        OrderQuantityControl(quantity: quantity, onChanged: onQuantityChanged),
      ],
    ),
  );
}

class _ProductImage extends StatelessWidget {
  final String image;

  const _ProductImage({required this.image});

  @override
  Widget build(BuildContext context) => Container(
    width: 58,
    height: 58,
    decoration: BoxDecoration(
      color: AppColors.surfaceContainer,
      borderRadius: BorderRadius.circular(12),
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: image.isNotEmpty
          ? Image.network(
              image,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => const _ImageFallback(),
            )
          : const _ImageFallback(),
    ),
  );
}

class _ImageFallback extends StatelessWidget {
  const _ImageFallback();

  @override
  Widget build(BuildContext context) =>
      const Icon(Icons.restaurant_rounded, color: AppColors.waiterPrimary);
}

class _ProductInfo extends StatelessWidget {
  final ProductEntity product;

  const _ProductInfo({required this.product});

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        product.name,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          color: AppColors.onSurface,
          fontSize: 14,
          fontWeight: FontWeight.w700,
        ),
      ),
      const SizedBox(height: 5),
      Text(
        product.description,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(color: AppColors.onSurfaceVariant, fontSize: 11),
      ),
      const SizedBox(height: 7),
      Text(
        product.price.toString(),
        style: const TextStyle(
          color: AppColors.waiterPrimary,
          fontSize: 15,
          fontWeight: FontWeight.w800,
        ),
      ),
    ],
  );
}
