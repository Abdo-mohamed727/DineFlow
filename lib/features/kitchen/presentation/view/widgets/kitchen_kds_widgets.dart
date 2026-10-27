import 'package:dineflow/core/theme/app_colors.dart';
import 'package:dineflow/features/orders/domain/entity/order_entity.dart';
import 'package:flutter/material.dart';

class KdsHeader extends StatelessWidget {
  const KdsHeader({super.key, required this.orderCount});
  final int orderCount;

  static const _green = Color(0xFF81C784);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
      decoration: const BoxDecoration(
        color: AppColors.surfaceContainerLow,
        border: Border(bottom: BorderSide(color: Color(0xFF2A2A2A))),
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(color: _green, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          const Text(
            'LIVE',
            style: TextStyle(color: _green, fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 1),
          ),
          const SizedBox(width: 12),
          const Text(
            'Active Orders',
            style: TextStyle(color: AppColors.onSurface, fontSize: 16, fontWeight: FontWeight.w700),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: _green.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '$orderCount',
              style: const TextStyle(color: _green, fontSize: 12, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}

class KdsStationFilter extends StatelessWidget {
  const KdsStationFilter({super.key, required this.selected, required this.onSelect});
  final String selected;
  final ValueChanged<String> onSelect;

  static const _stations = ['All Stations', 'Hot Kitchen', 'Grill', 'Bar'];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: _stations.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final active = _stations[i] == selected;
          return GestureDetector(
            onTap: () => onSelect(_stations[i]),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: active ? const Color(0xFF81C784) : AppColors.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: active ? const Color(0xFF81C784) : AppColors.outlineVariant.withValues(alpha: 0.5),
                ),
              ),
              child: Text(
                _stations[i],
                style: TextStyle(
                  color: active ? Colors.black87 : AppColors.onSurfaceVariant,
                  fontSize: 12,
                  fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class KdsEmptyState extends StatelessWidget {
  const KdsEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.restaurant_menu_rounded, size: 64, color: AppColors.outlineVariant.withValues(alpha: 0.4)),
          const SizedBox(height: 16),
          const Text(
            'No active orders',
            style: TextStyle(color: AppColors.onSurfaceVariant, fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 6),
          const Text(
            'New orders will appear here',
            style: TextStyle(color: Color(0xFF616161), fontSize: 13),
          ),
        ],
      ),
    );
  }
}

class KdsErrorState extends StatelessWidget {
  const KdsErrorState({super.key, required this.message, required this.onRetry});
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.wifi_off_rounded, size: 48, color: AppColors.error),
          const SizedBox(height: 12),
          Text(message, style: const TextStyle(color: AppColors.onSurface, fontSize: 14), textAlign: TextAlign.center),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh_rounded),
            label: const Text('Retry'),
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFF81C784),
              foregroundColor: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}

class KdsOrderList extends StatelessWidget {
  const KdsOrderList({super.key, required this.orders, required this.cardBuilder});
  final List<OrderEntity> orders;
  final Widget Function(OrderEntity) cardBuilder;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 8, bottom: 100),
      itemCount: orders.length,
      itemBuilder: (_, i) => cardBuilder(orders[i]),
    );
  }
}
