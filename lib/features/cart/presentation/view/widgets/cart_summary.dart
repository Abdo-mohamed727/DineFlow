import 'package:dineflow/core/theme/app_colors.dart';
import 'package:dineflow/core/widgets/app_primary_button.dart';
import 'package:dineflow/features/cart/domain/entites/cart_entity.dart';
import 'package:flutter/material.dart';

class CartSummary extends StatelessWidget {
  const CartSummary({
    super.key,
    required this.cart,
    required this.onPlaceOrder,
  });

  final CartEntity cart;
  final VoidCallback onPlaceOrder;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.35),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _row('Subtotal', cart.subtotal),
            const SizedBox(height: 8),
            _row('Tax', cart.tax),
            const Divider(height: 24, color: AppColors.outlineVariant),
            _row('Total', cart.total, emphasize: true),
            const SizedBox(height: 16),
            AppPrimaryButton(
              text: 'Place Order',
              onPressed: onPlaceOrder,
            ),
          ],
        ),
      ),
    );
  }

  Widget _row(String label, int amount, {bool emphasize = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: emphasize ? AppColors.onSurface : AppColors.onSurfaceVariant,
            fontWeight: emphasize ? FontWeight.w700 : FontWeight.w500,
            fontSize: emphasize ? 16 : 14,
          ),
        ),
        Text(
          '\$$amount',
          style: TextStyle(
            color: emphasize ? AppColors.primaryContainer : AppColors.onSurface,
            fontWeight: FontWeight.w700,
            fontSize: emphasize ? 18 : 14,
          ),
        ),
      ],
    );
  }
}
