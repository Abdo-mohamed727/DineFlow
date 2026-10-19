import 'package:dineflow/features/waiter/presentation/view/screen/table_details_view.dart';
import 'package:dineflow/features/waiter/presentation/view/widget/table_card.dart';
import 'package:dineflow/features/waiter/presentation/view_model/table/table_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dineflow/core/theme/app_colors.dart';
import 'package:dineflow/core/widgets/app_empty_state.dart';
import 'package:dineflow/core/widgets/app_error_state.dart';
import 'package:dineflow/core/widgets/app_loading_indicator.dart';
import 'package:dineflow/features/waiter/domain/entity/table_entity.dart';

import 'package:dineflow/features/waiter/presentation/view_model/table/table_state.dart';

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
    context.read<TableCubit>().getTables();
  }

  void _getTables() {
    if (_showAvailableOnly) {
      context.read<TableCubit>().getAvailableTables();
    } else {
      context.read<TableCubit>().getTables();
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
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: context.read<TableCubit>(),
          child: TableDetailsView(tableId: table.id),
        ),
      ),
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
            child: BlocConsumer<TableCubit, TableState>(
              listenWhen: (previous, current) =>
                  (current.sessionClosed && !previous.sessionClosed) ||
                  (current.errorMessage != null &&
                      previous.errorMessage != current.errorMessage),
              listener: (context, state) {
                if (state.sessionClosed) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Dining session closed.')),
                  );
                } else if (state.errorMessage != null) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
                }
              },
              builder: (context, state) {
                if (state.status == TableStatus.loading ||
                    state.status == TableStatus.initial) {
                  return const AppLoadingIndicator(
                    message: 'Loading tables...',
                  );
                }

                if (state.status == TableStatus.failure) {
                  return AppErrorState(
                    message: state.errorMessage ?? 'Something went wrong',
                    onRetry: _getTables,
                  );
                }

                final allTables = state.tables.tables;
                final tables = _showAvailableOnly
                    ? allTables
                          .where((t) => t.status.toLowerCase() == 'available')
                          .toList()
                    : allTables;

                if (tables.isEmpty) {
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

                return _buildTablesList(
                  tables,
                  closingTableId: state.closingTableId,
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

  Widget _buildTablesList(
    List<TableEntity> tables, {
    required String closingTableId,
  }) {
    return RefreshIndicator(
      color: AppColors.waiterPrimary,
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
            onCloseSession: table.status.toLowerCase() == 'occupied'
                ? () => _confirmCloseDiningSession(table)
                : null,
            isClosingSession: closingTableId == table.id,
          );
        },
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
    await context.read<TableCubit>().updateTable(
      table.id,
      status,
      availableOnly: _showAvailableOnly,
    );
  }

  Future<void> _confirmCloseDiningSession(TableEntity table) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('Close Table ${table.tableNumber} session?'),
        content: const Text(
          'The session can only close when its orders and bill allow it.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Close session'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      await context.read<TableCubit>().closeDiningSession(table.id);
    }
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
          ? AppColors.waiterPrimary.withValues(alpha: 0.2)
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
                  ? AppColors.waiterPrimary
                  : AppColors.outlineVariant,
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: selected ? AppColors.waiterPrimary : AppColors.onSurface,
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
                ? AppColors.waiterPrimary.withValues(alpha: 0.12)
                : AppColors.surfaceContainerHigh,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected
                  ? AppColors.waiterPrimary
                  : AppColors.outlineVariant,
            ),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: isSelected
                    ? AppColors.waiterPrimary
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
                const Icon(Icons.check_circle, color: AppColors.waiterPrimary),
            ],
          ),
        ),
      ),
    );
  }
}
