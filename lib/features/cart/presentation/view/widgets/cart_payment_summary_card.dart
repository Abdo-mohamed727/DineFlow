import 'package:dineflow/core/theme/app_colors.dart';
import 'package:dineflow/features/cart/domain/entites/cart_entity.dart';
import 'package:flutter/material.dart';

class CartPaymentSummaryCard extends StatelessWidget {
  const CartPaymentSummaryCard({
    super.key,
    required this.cart,
    required this.isPromoApplied,
  });

  final CartEntity cart;
  final bool isPromoApplied;

  @override
  Widget build(BuildContext context) {
    final subtotal = cart.subtotal;
    final tax = cart.tax;
    final discount = isPromoApplied ? 3 : 0;
    final finalTotal = (cart.total - discount).clamp(0, 999999);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.surfaceContainerHigh.withValues(alpha: 0.5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Payment Summary',
            style: TextStyle(
              color: AppColors.onSurface,
              fontWeight: FontWeight.bold,
              fontSize: 17,
            ),
          ),
          const SizedBox(height: 14),
          _summaryRow('Subtotal', '\$$subtotal'),
          const SizedBox(height: 8),
          _summaryRow('Delivery Fee', '\$2.50', showInfoIcon: true),
          if (isPromoApplied) ...[
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Text(
                      'Discount Voucher',
                      style: TextStyle(
                        color: AppColors.onSurfaceVariant,
                        fontSize: 13.5,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.primaryContainer.withValues(alpha: 0.18),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        'CRAVINGS3',
                        style: TextStyle(
                          color: AppColors.primaryContainer,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const Text(
                  '-\$3.00',
                  style: TextStyle(
                    color: AppColors.primaryContainer,
                    fontWeight: FontWeight.w700,
                    fontSize: 13.5,
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: 8),
          _summaryRow('Estimated Taxes & Fees', '\$$tax'),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 14),
            child: Divider(height: 1, color: AppColors.outlineVariant),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total Amount',
                    style: TextStyle(
                      color: AppColors.onSurface,
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Inclusive of all local taxes',
                    style: TextStyle(
                      color: AppColors.onSurfaceVariant,
                      fontSize: 11.5,
                    ),
                  ),
                ],
              ),
              Text(
                '\$$finalTotal',
                style: const TextStyle(
                  color: AppColors.primaryContainer,
                  fontWeight: FontWeight.w900,
                  fontSize: 26,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _summaryRow(String label, String value, {bool showInfoIcon = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text(
              label,
              style: const TextStyle(
                color: AppColors.onSurfaceVariant,
                fontSize: 13.5,
              ),
            ),
            if (showInfoIcon) ...[
              const SizedBox(width: 4),
              Icon(
                Icons.info_outline_rounded,
                size: 13,
                color: AppColors.onSurfaceVariant.withValues(alpha: 0.6),
              ),
            ],
          ],
        ),
        Text(
          value,
          style: const TextStyle(
            color: AppColors.onSurface,
            fontWeight: FontWeight.w600,
            fontSize: 13.5,
          ),
        ),
      ],
    );
  }
}
