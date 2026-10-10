import 'package:dineflow/features/waiter/presentation/view/screen/table_details_view.dart';
import 'package:dineflow/features/waiter/presentation/view/widget/table_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dineflow/core/theme/app_colors.dart';
import 'package:dineflow/core/widgets/app_empty_state.dart';
import 'package:dineflow/core/widgets/app_error_state.dart';
import 'package:dineflow/core/widgets/app_loading_indicator.dart';
import 'package:dineflow/features/waiter/domain/entity/table_entity.dart';

import 'package:dineflow/features/waiter/presentation/view_model/cubit/waiter_cubit.dart';

class WaiterTablesView extends StatefulWidget {
  const WaiterTablesView({super.key});
  @override
  State<WaiterTablesView> createState() => _WaiterTablesViewState();
}

class _WaiterTablesViewState extends State<WaiterTablesView> {
  bool _showAvailableOnly = false;
  @override
  void initState() {
    super.initState();
    context.read<WaiterCubit>().getTables();
  }

  void _getTables() {
    if (_showAvailableOnly) {
      context.read<WaiterCubit>().getAvailableTables();
    } else {
      context.read<WaiterCubit>().getTables();
    }
  }

  void _changeFilter(bool availableOnly) {
    setState(() {
      _showAvailableOnly = availableOnly;
    });
    _getTables();
  }

  Future<void> _openTableDetails(TableEntity table) async {
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => TableDetailsView(tableId: table.id)),
    );

    if (mounted) {
      _getTables();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: const Text(
          'Tables',
          style: TextStyle(
            color: AppColors.onSurface,
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          IconButton(
            onPressed: _getTables,
            icon: const Icon(Icons.refresh_rounded, color: AppColors.onSurface),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildFilters(),
          Expanded(
            child: BlocBuilder<WaiterCubit, WaiterState>(
              builder: (context, state) {
                return state.when(
                  initial: () =>
                      const AppLoadingIndicator(message: 'Loading tables...'),
                  loading: () =>
                      const AppLoadingIndicator(message: 'Loading tables...'),
                  error: (message) =>
                      AppErrorState(message: message, onRetry: _getTables),
                  tablesLoaded: (tables) {
                    if (tables.tables.isEmpty) {
                      return AppEmptyState(
                        title: _showAvailableOnly
                            ? 'No available tables'
                            : 'No tables found',
                        message: _showAvailableOnly
                            ? 'There are no available tables right now.'
                            : 'There are no tables to display.',
                        iconData: Icons.table_restaurant_outlined,
                        onAction: _getTables,
                        actionText: 'Refresh',
                      );
                    }
                    return _buildTablesList(tables.tables);
                  },
                  tableLoaded: (table) {
                    return _buildSingleTable(table);
                  },
                  tableUpdated: (table) {
                    return _buildSingleTable(table);
                  },
                  requestsLoaded: (_) => const SizedBox.shrink(),
                  requestUpdated: (_) => const SizedBox.shrink(),
                  ordersLoaded: (_) => const SizedBox.shrink(),
                  orderLoaded: (_) => const SizedBox.shrink(),
                  orderCreated: (_) => const SizedBox.shrink(),
                  orderStatusUpdated: (_) => const SizedBox.shrink(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: Row(
        children: [
          Expanded(
            child: _FilterButton(
              label: 'All Tables',
              selected: !_showAvailableOnly,
              onTap: () => _changeFilter(false),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _FilterButton(
              label: 'Available',
              selected: _showAvailableOnly,
              onTap: () => _changeFilter(true),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTablesList(List<TableEntity> tables) {
    return RefreshIndicator(
      color: AppColors.primaryContainer,
      backgroundColor: AppColors.surfaceContainer,
      onRefresh: () async {
        _getTables();
      },
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        itemCount: tables.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final table = tables[index];
          return TableCard(
            table: table,
            onView: () => _openTableDetails(table),
            onUpdateStatus: () => _showUpdateStatusSheet(table),
          );
        },
      ),
    );
  }

  Widget _buildSingleTable(TableEntity table) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: TableCard(
        table: table,
        onView: () => _openTableDetails(table),
        onUpdateStatus: () => _showUpdateStatusSheet(table),
      ),
    );
  }

  Future<void> _showUpdateStatusSheet(TableEntity table) async {
    final status = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: AppColors.surfaceContainer,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Table ${table.tableNumber}',
                  style: const TextStyle(
                    color: AppColors.onSurface,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Select table status',
                  style: TextStyle(
                    color: AppColors.onSurfaceVariant,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 20),
                _StatusOption(
                  title: 'Available',
                  icon: Icons.check_circle_outline,
                  status: 'available',
                  currentStatus: table.status,
                  onTap: () => Navigator.pop(context, 'available'),
                ),
                _StatusOption(
                  title: 'Occupied',
                  icon: Icons.people_outline,
                  status: 'occupied',
                  currentStatus: table.status,
                  onTap: () => Navigator.pop(context, 'occupied'),
                ),
                _StatusOption(
                  title: 'Reserved',
                  icon: Icons.bookmark_outline,
                  status: 'reserved',
                  currentStatus: table.status,
                  onTap: () => Navigator.pop(context, 'reserved'),
                ),
              ],
            ),
          ),
        );
      },
    );
    if (!mounted || status == null || status == table.status) {
      return;
    }
    await context.read<WaiterCubit>().updateTable(
      table.id,
      status,
      availableOnly: _showAvailableOnly,
    );
  }
}

class _FilterButton extends StatelessWidget {
  const _FilterButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });
  final String label;
  final bool selected;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected
          ? AppColors.primaryContainer
          : AppColors.surfaceContainerHigh,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          height: 44,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selected
                  ? AppColors.primaryContainer
                  : AppColors.outlineVariant,
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: selected
                  ? AppColors.onPrimaryContainer
                  : AppColors.onSurface,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

class _StatusOption extends StatelessWidget {
  const _StatusOption({
    required this.title,
    required this.icon,
    required this.status,
    required this.currentStatus,
    required this.onTap,
  });
  final String title;
  final IconData icon;
  final String status;
  final String currentStatus;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    final isSelected = status == currentStatus;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primaryContainer.withValues(alpha: 0.12)
                : AppColors.surfaceContainerHigh,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected
                  ? AppColors.primaryContainer
                  : AppColors.outlineVariant,
            ),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: isSelected
                    ? AppColors.primaryContainer
                    : AppColors.onSurfaceVariant,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.onSurface,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              if (isSelected)
                const Icon(
                  Icons.check_circle,
                  color: AppColors.primaryContainer,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
