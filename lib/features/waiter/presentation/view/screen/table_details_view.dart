
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:dineflow/core/theme/app_colors.dart';
import 'package:dineflow/core/widgets/app_error_state.dart';
import 'package:dineflow/core/widgets/app_loading_indicator.dart';
import 'package:dineflow/features/waiter/domain/entity/table_entity.dart';
import 'package:dineflow/features/waiter/presentation/view_model/cubit/waiter_cubit.dart';

class TableDetailsView extends StatefulWidget {
  const TableDetailsView({
    super.key,
    required this.tableId,
  });

  final String tableId;

  @override
  State<TableDetailsView> createState() => _TableDetailsViewState();
}

class _TableDetailsViewState extends State<TableDetailsView> {
  @override
  void initState() {
    super.initState();
    context.read<WaiterCubit>().getTableById(widget.tableId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.onSurface,
        title: const Text('Table Details'),
      ),
      body: BlocBuilder<WaiterCubit, WaiterState>(
        builder: (context, state) {
          return state.maybeWhen(
            loading: () => const AppLoadingIndicator(
              message: 'Loading table details...',
            ),
            error: (message) => AppErrorState(
              message: message,
              onRetry: () {
                context.read<WaiterCubit>().getTableById(
                      widget.tableId,
                    );
              },
            ),
            tableLoaded: (table) => _buildDetails(table),
            orElse: () => const AppLoadingIndicator(
              message: 'Loading table details...',
            ),
          );
        },
      ),
    );
  }

  Widget _buildDetails(TableEntity table) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Icon(
                Icons.table_restaurant,
                size: 52,
                color: AppColors.primaryContainer,
              ),
            ),
          ),
          const SizedBox(height: 24),
          Center(
            child: Text(
              'Table ${table.tableNumber}',
              style: const TextStyle(
                color: AppColors.onSurface,
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: _StatusBadge(status: table.status),
          ),
          const SizedBox(height: 28),
          _DetailTile(
            icon: Icons.people_outline,
            title: 'Capacity',
            value: '${table.capacity} seats',
          ),
          _DetailTile(
            icon: Icons.location_on_outlined,
            title: 'Location',
            value: table.location.isEmpty ? 'Not specified' : table.location,
          ),
          _DetailTile(
            icon: Icons.info_outline,
            title: 'Status',
            value: table.status,
          ),
          if (table.createdAt != null)
            _DetailTile(
              icon: Icons.calendar_today_outlined,
              title: 'Created At',
              value: table.createdAt!.toLocal().toString().split('.').first,
            ),
          if (table.updatedAt != null)
            _DetailTile(
              icon: Icons.update,
              title: 'Last Updated',
              value: table.updatedAt!.toLocal().toString().split('.').first,
            ),
        ],
      ),
    );
  }
}

class _DetailTile extends StatelessWidget {
  const _DetailTile({
    required this.icon,
    required this.title,
    required this.value,
  });

  final IconData icon;
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.outlineVariant),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primaryContainer, size: 24),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.onSurfaceVariant,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  value,
                  style: const TextStyle(
                    color: AppColors.onSurface,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final normalized = status.toLowerCase();

    final color = switch (normalized) {
      'available' => const Color(0xFF81C784),
      'occupied' => const Color(0xFFFFD54F),
      'reserved' => const Color(0xFF90CAF9),
      _ => AppColors.onSurfaceVariant,
    };

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status.isEmpty
            ? 'Unknown'
            : '${status[0].toUpperCase()}${status.substring(1)}',
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}