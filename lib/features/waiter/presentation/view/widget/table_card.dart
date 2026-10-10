import 'package:flutter/material.dart';
import 'package:dineflow/core/theme/app_colors.dart';
import 'package:dineflow/core/widgets/app_primary_button.dart';
import 'package:dineflow/core/widgets/app_secondary_button.dart';
import 'package:dineflow/features/waiter/domain/entity/table_entity.dart';

class TableCard extends StatelessWidget {
  const TableCard({
    super.key,
    required this.table,
    this.onUpdateStatus,
    this.onView,
  });
  final TableEntity table;
  final VoidCallback? onUpdateStatus;
  final VoidCallback? onView;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.primaryContainer.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.table_restaurant,
                  color: AppColors.primaryContainer,
                  size: 26,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Table ${table.tableNumber}',
                      style: const TextStyle(
                        color: AppColors.onSurface,
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      table.location,
                      style: const TextStyle(
                        color: AppColors.onSurfaceVariant,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              _TableStatusBadge(status: table.status),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Icon(
                Icons.people_outline,
                size: 18,
                color: AppColors.onSurfaceVariant,
              ),
              const SizedBox(width: 6),
              Text(
                '${table.capacity} seats',
                style: const TextStyle(
                  color: AppColors.onSurfaceVariant,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (onUpdateStatus != null)
            LayoutBuilder(
              builder: (context, constraints) {
                final buttons = [
                  AppSecondaryButton(
                    text: 'View',
                    fullWidth: true,
                    height: 44,
                    icon: const Icon(Icons.visibility_outlined, size: 18),
                    onPressed: onView,
                  ),
                  AppPrimaryButton(
                    text: 'Update Status',
                    fullWidth: true,
                    height: 44,
                    icon: const Icon(Icons.edit_outlined, size: 18),
                    onPressed: onUpdateStatus,
                  ),
                ];

                if (constraints.maxWidth < 360) {
                  return Column(
                    children: [
                      buttons[0],
                      const SizedBox(height: 10),
                      buttons[1],
                    ],
                  );
                }

                return Row(
                  children: [
                    Expanded(child: buttons[0]),
                    const SizedBox(width: 10),
                    Expanded(child: buttons[1]),
                  ],
                );
              },
            ),
        ],
      ),
    );
  }
}

class _TableStatusBadge extends StatelessWidget {
  const _TableStatusBadge({required this.status});
  final String status;
  @override
  Widget build(BuildContext context) {
    final normalizedStatus = status.toLowerCase();
    final Color backgroundColor;
    final Color textColor;
    final Color dotColor;
    switch (normalizedStatus) {
      case 'available':
        backgroundColor = const Color(0xFF13361E);
        textColor = const Color(0xFF81C784);
        dotColor = const Color(0xFF4CAF50);
        break;
      case 'occupied':
        backgroundColor = const Color(0xFF3B2E00);
        textColor = const Color(0xFFFFE082);
        dotColor = const Color(0xFFFFC107);
        break;
      case 'reserved':
        backgroundColor = const Color(0xFF0D2D4A);
        textColor = const Color(0xFF90CAF9);
        dotColor = const Color(0xFF2196F3);
        break;
      default:
        backgroundColor = AppColors.surfaceContainerHigh;
        textColor = AppColors.onSurfaceVariant;
        dotColor = AppColors.outline;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 7,
            height: 7,
            decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Text(
            _capitalize(status),
            style: TextStyle(
              color: textColor,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  String _capitalize(String value) {
    if (value.isEmpty) {
      return value;
    }
    return value[0].toUpperCase() + value.substring(1);
  }
}
