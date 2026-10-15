import 'package:dineflow/core/theme/app_colors.dart';
import 'package:dineflow/features/orders/domain/entity/order_entity.dart';
import 'package:dineflow/features/waiter/presentation/view_model/table/table_cubit.dart';
import 'package:dineflow/features/waiter/presentation/view_model/table/table_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Opens the [SelectTableBottomSheet] and returns the chosen [RestaurantTableEntity],
/// or `null` if the user dismissed without selecting.
Future<RestaurantTableEntity?> showSelectTableBottomSheet(BuildContext context) {
  final tableCubit = context.read<TableCubit>();

  return showModalBottomSheet<RestaurantTableEntity>(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.surfaceContainer,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (_) => BlocProvider.value(
      value: tableCubit,
      child: const SelectTableBottomSheet(),
    ),
  );
}

class SelectTableBottomSheet extends StatefulWidget {
  const SelectTableBottomSheet({super.key});

  @override
  State<SelectTableBottomSheet> createState() => _SelectTableBottomSheetState();
}

class _SelectTableBottomSheetState extends State<SelectTableBottomSheet> {
  @override
  void initState() {
    super.initState();
    // Load available tables when the sheet opens.
    context.read<TableCubit>().getAvailableTables();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.4,
      maxChildSize: 0.92,
      expand: false,
      builder: (context, scrollController) {
        return Padding(
          padding: EdgeInsets.only(bottom: bottomInset),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHandle(),
              _buildHeader(context),
              const Divider(height: 1, color: AppColors.outlineVariant),
              Expanded(child: _buildContent(scrollController)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHandle() => Center(
    child: Container(
      margin: const EdgeInsets.only(top: 12, bottom: 8),
      width: 40,
      height: 4,
      decoration: BoxDecoration(
        color: AppColors.outlineVariant,
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  );

  Widget _buildHeader(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(20, 8, 8, 16),
    child: Row(
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: AppColors.waiterPrimary.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(
            Icons.table_restaurant_rounded,
            color: AppColors.waiterPrimary,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Select Table',
                style: TextStyle(
                  color: AppColors.onSurface,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Choose an available table for this dine-in order',
                style: TextStyle(
                  color: AppColors.onSurfaceVariant,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.close_rounded, color: AppColors.onSurfaceVariant),
        ),
      ],
    ),
  );

  Widget _buildContent(ScrollController scrollController) {
    return BlocBuilder<TableCubit, TableState>(
      builder: (context, state) {
        if (state.status == TableStatus.loading ||
            state.status == TableStatus.initial) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.waiterPrimary),
          );
        }

        if (state.status == TableStatus.failure) {
          return _buildError(context, state.errorMessage);
        }

        final tables = state.availableTables
            .where((t) => t.status.toLowerCase() == 'available')
            .toList();

        if (tables.isEmpty) {
          return _buildEmpty(context);
        }

        return ListView.separated(
          controller: scrollController,
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          itemCount: tables.length,
          separatorBuilder: (_, _) => const SizedBox(height: 10),
          itemBuilder: (context, index) {
            final table = tables[index];
            return _TableOption(
              table: table,
              onSelect: () => Navigator.of(context).pop(table),
            );
          },
        );
      },
    );
  }

  Widget _buildError(BuildContext context, String? message) => Center(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.error_outline_rounded,
            size: 48,
            color: AppColors.onSurfaceVariant,
          ),
          const SizedBox(height: 12),
          Text(
            message ?? 'Failed to load tables',
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.onSurfaceVariant),
          ),
          const SizedBox(height: 20),
          TextButton.icon(
            onPressed: () => context.read<TableCubit>().getAvailableTables(),
            icon: const Icon(Icons.refresh_rounded, color: AppColors.waiterPrimary),
            label: const Text(
              'Retry',
              style: TextStyle(color: AppColors.waiterPrimary),
            ),
          ),
        ],
      ),
    ),
  );

  Widget _buildEmpty(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.table_restaurant_outlined,
            size: 56,
            color: AppColors.onSurfaceVariant,
          ),
          const SizedBox(height: 16),
          const Text(
            'No available tables',
            style: TextStyle(
              color: AppColors.onSurface,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'All tables are currently occupied or reserved.',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.onSurfaceVariant, fontSize: 13),
          ),
          const SizedBox(height: 20),
          TextButton.icon(
            onPressed: () => context.read<TableCubit>().getAvailableTables(),
            icon: const Icon(Icons.refresh_rounded, color: AppColors.waiterPrimary),
            label: const Text(
              'Refresh',
              style: TextStyle(color: AppColors.waiterPrimary),
            ),
          ),
        ],
      ),
    ),
  );
}

// ---------------------------------------------------------------------------
// _TableOption — a tappable card for a single table
// ---------------------------------------------------------------------------

class _TableOption extends StatelessWidget {
  const _TableOption({required this.table, required this.onSelect});

  final RestaurantTableEntity table;
  final VoidCallback onSelect;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surfaceContainerLow,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onSelect,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.outlineVariant, width: 0.7),
          ),
          child: Row(
            children: [
              // Icon
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.waiterPrimary.withValues(alpha: 0.13),
                  borderRadius: BorderRadius.circular(11),
                ),
                child: const Icon(
                  Icons.table_restaurant_rounded,
                  color: AppColors.waiterPrimary,
                  size: 22,
                ),
              ),
              const SizedBox(width: 14),
              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Table ${table.tableNumber}',
                      style: const TextStyle(
                        color: AppColors.onSurface,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.people_outline,
                          size: 14,
                          color: AppColors.onSurfaceVariant,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${table.capacity} seats',
                          style: const TextStyle(
                            color: AppColors.onSurfaceVariant,
                            fontSize: 12,
                          ),
                        ),
                        if ((table.location ?? '').isNotEmpty) ...const [
                          SizedBox(width: 10),
                          Icon(
                            Icons.location_on_outlined,
                            size: 14,
                            color: AppColors.onSurfaceVariant,
                          ),
                          SizedBox(width: 3),
                        ],
                        if ((table.location ?? '').isNotEmpty)
                          Expanded(
                            child: Text(
                              table.location!,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: AppColors.onSurfaceVariant,
                                fontSize: 12,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              // Select arrow
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.waiterPrimary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Select',
                  style: TextStyle(
                    color: AppColors.waiterPrimary,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
