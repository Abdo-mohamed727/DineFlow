import 'package:dineflow/core/enums/order_status.dart';
import 'package:dineflow/core/theme/app_colors.dart';
import 'package:dineflow/features/orders/domain/entity/order_entity.dart';
import 'package:dineflow/features/orders/presentation/view/widgets/order_history_card.dart';
import 'package:flutter/material.dart';

/// The "Order History" section below the active orders.
class OrderHistorySection extends StatefulWidget {
  const OrderHistorySection({super.key, required this.orders});

  final List<OrderEntity> orders;

  @override
  State<OrderHistorySection> createState() => _OrderHistorySectionState();
}

class _OrderHistorySectionState extends State<OrderHistorySection> {
  _HistoryFilter _filter = _HistoryFilter.all;

  List<OrderEntity> get _filtered {
    return switch (_filter) {
      _HistoryFilter.all => widget.orders,
      _HistoryFilter.completed => widget.orders
          .where((o) =>
              o.status == OrderStatus.completed ||
              o.status == OrderStatus.paid ||
              o.status == OrderStatus.pickedUp)
          .toList(),
      _HistoryFilter.cancelled =>
        widget.orders.where((o) => o.status == OrderStatus.cancelled).toList(),
    };
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filtered;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Section header ──────────────────────────────────────────────
          Row(
            children: [
              const Text(
                'ORDER HISTORY',
                style: TextStyle(
                  color: AppColors.onSurfaceVariant,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                ),
              ),
              const Spacer(),
              Text(
                '${widget.orders.length} ${widget.orders.length == 1 ? 'Order' : 'Orders'}',
                style: const TextStyle(
                  color: AppColors.onSurfaceVariant,
                  fontSize: 11,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // ── Filter tabs ─────────────────────────────────────────────────
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _HistoryFilter.values.map((f) {
                final isSelected = _filter == f;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: GestureDetector(
                    onTap: () => setState(() => _filter = f),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primaryContainer.withValues(alpha: 0.15)
                            : AppColors.surfaceContainerHigh,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.primaryContainer.withValues(alpha: 0.5)
                              : AppColors.outlineVariant.withValues(alpha: 0.3),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        f.label,
                        style: TextStyle(
                          color: isSelected
                              ? AppColors.primaryContainer
                              : AppColors.onSurfaceVariant,
                          fontSize: 13,
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 14),

          // ── Orders list ─────────────────────────────────────────────────
          if (widget.orders.isEmpty)
            _EmptyHistory()
          else if (filtered.isEmpty)
            _EmptyFilteredHistory(filter: _filter)
          else
            ...filtered.map((o) => OrderHistoryCard(order: o)),
        ],
      ),
    );
  }
}

enum _HistoryFilter {
  all,
  completed,
  cancelled;

  String get label => switch (this) {
        _HistoryFilter.all => 'All',
        _HistoryFilter.completed => 'Completed',
        _HistoryFilter.cancelled => 'Cancelled',
      };
}

class _EmptyHistory extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 24),
      child: Center(
        child: Text(
          'No past orders.',
          style: TextStyle(
            color: AppColors.onSurfaceVariant,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}

class _EmptyFilteredHistory extends StatelessWidget {
  const _EmptyFilteredHistory({required this.filter});
  final _HistoryFilter filter;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Center(
        child: Text(
          'No ${filter.label.toLowerCase()} orders.',
          style: const TextStyle(
            color: AppColors.onSurfaceVariant,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
