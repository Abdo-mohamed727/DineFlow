import 'package:dineflow/core/enums/order_status.dart';
import 'package:dineflow/core/enums/order_type.dart';
import 'package:dineflow/core/theme/app_colors.dart';
import 'package:dineflow/core/widgets/status_badge.dart';
import 'package:dineflow/features/orders/domain/entity/order_entity.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Shows a single active/in-progress order prominently.
class ActiveOrderCard extends StatelessWidget {
  const ActiveOrderCard({super.key, required this.order});

  final OrderEntity order;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _borderColor.withValues(alpha: 0.35),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header ────────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 12, 10),
            child: Row(
              children: [
                // Order number + type
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        order.orderNumber ?? order.id.substring(0, 10),
                        style: const TextStyle(
                          color: AppColors.onSurface,
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Row(
                        children: [
                          Icon(
                            order.orderType.iconData,
                            size: 12,
                            color: AppColors.onSurfaceVariant,
                          ),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              _locationLabel,
                              style: const TextStyle(
                                color: AppColors.onSurfaceVariant,
                                fontSize: 11,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Status badge
                StatusBadge(
                  status: order.status,
                  orderType: order.orderType,
                ),
              ],
            ),
          ),

          // ── Status message ─────────────────────────────────────────────
          _StatusMessageBanner(status: order.status),

          // ── Progress stepper ───────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
            child: _OrderProgressStepper(
              status: order.status,
              orderType: order.orderType,
            ),
          ),

          // ── Divider + total ────────────────────────────────────────────
          Divider(
            color: AppColors.outlineVariant.withValues(alpha: 0.3),
            height: 1,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 10, 14, 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Total Bill',
                      style: TextStyle(
                        color: AppColors.onSurfaceVariant,
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'EGP ${order.total.toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: AppColors.primaryContainer,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
                if (order.createdAt != null)
                  Text(
                    'Ordered ${_relativeDate(order.createdAt!)}',
                    style: const TextStyle(
                      color: AppColors.onSurfaceVariant,
                      fontSize: 11,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String get _locationLabel {
    if (order.orderType == OrderType.dineIn) {
      final table = order.tableId;
      return table != null && table.isNotEmpty
          ? 'Dine In · Table ${table.length > 8 ? table.substring(table.length - 4) : table}'
          : 'Dine In';
    }
    return 'Takeaway Pickup';
  }

  Color get _borderColor {
    switch (order.status) {
      case OrderStatus.preparing:
      case OrderStatus.accepted:
        return AppColors.primaryContainer;
      case OrderStatus.ready:
      case OrderStatus.readyForPickup:
        return const Color(0xFF4CAF50);
      case OrderStatus.served:
        return const Color(0xFF00BCD4);
      case OrderStatus.paymentPending:
        return const Color(0xFFAB47BC);
      default:
        return AppColors.outlineVariant;
    }
  }

  String _relativeDate(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inMinutes < 1) return 'just now';
    if (diff.inHours < 1) return '${diff.inMinutes}m ago';
    if (diff.inDays < 1) return 'at ${DateFormat.Hm().format(dt)}';
    return DateFormat('MMM d').format(dt);
  }
}

// ── Status message banner ────────────────────────────────────────────────────

class _StatusMessageBanner extends StatelessWidget {
  const _StatusMessageBanner({required this.status});
  final OrderStatus status;

  @override
  Widget build(BuildContext context) {
    final (icon, title, subtitle) = _content;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 14),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Text(icon, style: const TextStyle(fontSize: 22)),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.onSurface,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (subtitle.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: AppColors.onSurfaceVariant,
                      fontSize: 11,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  (String, String, String) get _content => switch (status) {
        OrderStatus.pending => (
            '🕐',
            'Order received',
            'Waiting for kitchen confirmation.',
          ),
        OrderStatus.accepted => (
            '✅',
            'Order confirmed!',
            'Your ticket is with the head chef.',
          ),
        OrderStatus.preparing => (
            '🍳',
            'Your order is being prepared.',
            'The kitchen is finishing flame-roast!',
          ),
        OrderStatus.ready ||
        OrderStatus.readyForPickup =>
          ('🎉', 'Your order is ready!', 'Freshly plated — arriving now.'),
        OrderStatus.served => (
            '🍽️',
            'Order served!',
            'Enjoy your meal.',
          ),
        OrderStatus.paymentPending => (
            '💳',
            'Payment pending',
            'Please settle the bill to complete.',
          ),
        _ => ('📦', 'Order in progress', ''),
      };
}

// ── Progress stepper ─────────────────────────────────────────────────────────

class _OrderProgressStepper extends StatelessWidget {
  const _OrderProgressStepper({
    required this.status,
    required this.orderType,
  });

  final OrderStatus status;
  final OrderType orderType;

  @override
  Widget build(BuildContext context) {
    final steps = orderType == OrderType.dineIn
        ? const ['Placed', 'Confirmed', 'Preparing', 'Ready', 'Served']
        : const ['Placed', 'Confirmed', 'Preparing', 'Ready', 'Picked Up'];

    final currentStep = _currentStep;

    return Column(
      children: [
        Row(
          children: List.generate(steps.length * 2 - 1, (i) {
            if (i.isOdd) {
              // connector
              final segIndex = i ~/ 2;
              final filled = segIndex < currentStep;
              return Expanded(
                child: Container(
                  height: 2,
                  decoration: BoxDecoration(
                    color: filled
                        ? AppColors.primaryContainer
                        : AppColors.outlineVariant.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              );
            }
            // step circle
            final stepIndex = i ~/ 2;
            final isCompleted = stepIndex < currentStep;
            final isActive = stepIndex == currentStep;
            return _StepDot(
              isCompleted: isCompleted,
              isActive: isActive,
            );
          }),
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(steps.length, (i) {
            final isActive = i == currentStep;
            final isDone = i < currentStep;
            return Text(
              steps[i],
              style: TextStyle(
                color: isActive
                    ? AppColors.primaryContainer
                    : isDone
                        ? AppColors.onSurface.withValues(alpha: 0.7)
                        : AppColors.onSurfaceVariant.withValues(alpha: 0.5),
                fontSize: 10,
                fontWeight:
                    isActive ? FontWeight.w700 : FontWeight.w400,
              ),
            );
          }),
        ),
      ],
    );
  }

  int get _currentStep {
    switch (status) {
      case OrderStatus.pending:
        return 0;
      case OrderStatus.accepted:
        return 1;
      case OrderStatus.preparing:
        return 2;
      case OrderStatus.ready:
      case OrderStatus.readyForPickup:
        return 3;
      case OrderStatus.served:
      case OrderStatus.pickedUp:
        return 4;
      default:
        return 0;
    }
  }
}

class _StepDot extends StatelessWidget {
  const _StepDot({required this.isCompleted, required this.isActive});
  final bool isCompleted;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isCompleted || isActive
            ? AppColors.primaryContainer
            : AppColors.surfaceContainerHigh,
        border: Border.all(
          color: isActive
              ? AppColors.primaryContainer
              : AppColors.outlineVariant.withValues(alpha: 0.4),
          width: 1.5,
        ),
      ),
      child: isCompleted
          ? const Icon(Icons.check_rounded,
              size: 12, color: AppColors.onPrimaryContainer)
          : isActive
              ? const Icon(Icons.circle, size: 8, color: AppColors.onPrimaryContainer)
              : null,
    );
  }
}
