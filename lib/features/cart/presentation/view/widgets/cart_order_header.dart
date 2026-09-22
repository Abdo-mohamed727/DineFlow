import 'package:dineflow/core/theme/app_colors.dart';
import 'package:dineflow/features/cart/presentation/view_model/cubit/cart_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartOrderHeader extends StatelessWidget {
  const CartOrderHeader({
    super.key,
    required this.totalQuantity,
  });

  final int totalQuantity;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const Text(
              'Order Items',
              style: TextStyle(
                color: AppColors.onSurface,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '$totalQuantity ${totalQuantity == 1 ? "Item" : "Items"}',
                style: const TextStyle(
                  color: AppColors.onSurfaceVariant,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        TextButton.icon(
          onPressed: () => context.read<CartCubit>().clearCart(),
          icon: const Icon(
            Icons.delete_outline_rounded,
            size: 16,
            color: AppColors.onSurfaceVariant,
          ),
          label: const Text(
            'Clear',
            style: TextStyle(
              color: AppColors.onSurfaceVariant,
              fontSize: 13,
            ),
          ),
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ),
      ],
    );
  }
}
