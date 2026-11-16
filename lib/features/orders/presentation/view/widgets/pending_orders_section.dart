import 'package:dineflow/core/theme/app_colors.dart';
import 'package:dineflow/features/orders/domain/entity/pending_order.dart';
import 'package:flutter/material.dart';

class PendingOrdersSection extends StatelessWidget {
  const PendingOrdersSection({
    super.key,
    required this.orders,
    required this.onRetry,
    required this.onDiscard,
  });

  final List<PendingOrder> orders;
  final ValueChanged<String> onRetry;
  final ValueChanged<String> onDiscard;

  @override
  Widget build(BuildContext context) {
    if (orders.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'SAVED ORDERS',
            style: TextStyle(
              color: AppColors.onSurfaceVariant,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 10),
          for (final order in orders)
            _PendingOrderCard(
              order: order,
              onRetry: () => onRetry(order.clientOrderId),
              onDiscard: () => onDiscard(order.clientOrderId),
            ),
        ],
      ),
    );
  }
}

class _PendingOrderCard extends StatelessWidget {
  const _PendingOrderCard({
    required this.order,
    required this.onRetry,
    required this.onDiscard,
  });

  final PendingOrder order;
  final VoidCallback onRetry;
  final VoidCallback onDiscard;

  @override
  Widget build(BuildContext context) {
    final isFailed = order.status == PendingOrderStatus.failed;
    final statusLabel = switch (order.status) {
      PendingOrderStatus.pending => 'Pending',
      PendingOrderStatus.sending => 'Sending',
      PendingOrderStatus.failed => 'Failed',
    };

    return Container(
      key: ValueKey('pending-order-${order.clientOrderId}'),
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isFailed
              ? AppColors.error.withValues(alpha: 0.5)
              : AppColors.outlineVariant.withValues(alpha: 0.35),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Order saved on this device',
                  style: TextStyle(
                    color: AppColors.onSurface,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              DecoratedBox(
                decoration: BoxDecoration(
                  color: isFailed
                      ? AppColors.errorContainer.withValues(alpha: 0.35)
                      : AppColors.primaryContainer.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  child: Text(
                    statusLabel,
                    style: TextStyle(
                      color: isFailed
                          ? AppColors.error
                          : AppColors.primaryContainer,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (order.lastError != null && order.lastError!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              order.lastError!,
              style: const TextStyle(color: AppColors.error, fontSize: 12),
            ),
          ],
          if (isFailed) ...[
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              children: [
                TextButton(onPressed: onRetry, child: const Text('Retry')),
                TextButton(onPressed: onDiscard, child: const Text('Discard')),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
